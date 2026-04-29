package auth

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"strings"
	"time"

	"finku/backend/internal/cache"
	"finku/backend/internal/config"
	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/token"

	"github.com/go-playground/validator/v10"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/redis/go-redis/v9"
)

type Service struct {
	cfg         *config.Config
	q           *sqlc.Queries
	cache       *cache.Client
	access      *token.AccessIssuer
	validate    *validator.Validate
	googleVerif GoogleVerifier
}

// GoogleVerifier verifies a Google OIDC ID token and returns its claims.
type GoogleVerifier interface {
	Verify(ctx context.Context, idToken string) (*OAuthClaims, error)
}

// OAuthClaims is the minimal subset of provider claims we use.
type OAuthClaims struct {
	Subject       string
	Email         string
	EmailVerified bool
	Name          string
}

func NewService(cfg *config.Config, q *sqlc.Queries, c *cache.Client, access *token.AccessIssuer, gv GoogleVerifier) *Service {
	v := validator.New()
	_ = v.RegisterValidation("username", validateUsernameTag)
	return &Service{
		cfg:         cfg,
		q:           q,
		cache:       c,
		access:      access,
		validate:    v,
		googleVerif: gv,
	}
}

func (s *Service) refreshPayloadJSON(userID, family uuid.UUID) string {
	b, _ := json.Marshal(map[string]string{
		"user_id": userID.String(),
		"family":  family.String(),
	})
	return string(b)
}

// issueSession stores refresh in Redis, issues access JWT, caches user. Returns refresh JTI for Set-Cookie.
func (s *Service) issueSession(ctx context.Context, u sqlc.User) (AuthResponse, string, error) {
	providers, err := s.providersOf(ctx, u.ID)
	if err != nil {
		return AuthResponse{}, "", err
	}
	family := uuid.New()
	refreshJTI := uuid.New()
	payload := s.refreshPayloadJSON(u.ID, family)
	if err := s.cache.RefreshSet(ctx, refreshJTI.String(), payload, s.cfg.RefreshTokenTTL); err != nil {
		return AuthResponse{}, "", err
	}
	accessStr, _, _, err := s.access.Issue(u.ID, u.Email)
	if err != nil {
		_ = s.cache.RefreshDel(ctx, refreshJTI.String())
		return AuthResponse{}, "", err
	}
	dto := userToDTO(u, providers)
	if err := s.cacheUserDTO(ctx, u.ID.String(), dto); err != nil {
		_ = s.cache.RefreshDel(ctx, refreshJTI.String())
		return AuthResponse{}, "", err
	}
	return AuthResponse{
		User:        dto,
		AccessToken: accessStr,
	}, refreshJTI.String(), nil
}

func (s *Service) cacheUserDTO(ctx context.Context, id string, dto UserDTO) error {
	b, err := json.Marshal(dto)
	if err != nil {
		return err
	}
	return s.cache.UserCacheSet(ctx, id, string(b), s.cfg.UserCacheTTL)
}

func (s *Service) providersOf(ctx context.Context, userID uuid.UUID) ([]string, error) {
	ids, err := s.q.ListIdentitiesByUser(ctx, userID)
	if err != nil {
		return nil, err
	}
	out := make([]string, 0, len(ids))
	seen := map[string]bool{}
	for _, i := range ids {
		if seen[i.Provider] {
			continue
		}
		seen[i.Provider] = true
		out = append(out, i.Provider)
	}
	return out, nil
}

func (s *Service) Register(ctx context.Context, in RegisterRequest) (AuthResponse, string, error) {
	if err := s.validate.Struct(in); err != nil {
		return AuthResponse{}, "", statusErr(http.StatusBadRequest, "VALIDATION_ERROR", err.Error())
	}
	if err := ValidateUsernameFormat(in.Username); err != nil {
		return AuthResponse{}, "", err
	}
	email := strings.ToLower(strings.TrimSpace(in.Email))
	username := strings.TrimSpace(in.Username)
	hash, err := HashPassword(in.Password, s.cfg.Argon2Params)
	if err != nil {
		return AuthResponse{}, "", err
	}
	exists, err := s.q.UsernameExists(ctx, username)
	if err != nil {
		return AuthResponse{}, "", err
	}
	if exists {
		return AuthResponse{}, "", statusErr(http.StatusConflict, "USERNAME_TAKEN", "Username sudah dipakai. Coba yang lain.")
	}
	hashPtr := &hash
	u, err := s.q.CreateUser(ctx, email, hashPtr, strings.TrimSpace(in.Name))
	if err != nil {
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return AuthResponse{}, "", statusErr(http.StatusConflict, "EMAIL_TAKEN", "Email sudah terdaftar.")
		}
		return AuthResponse{}, "", err
	}
	u, err = s.q.UpdateUserUsername(ctx, u.ID, username)
	if err != nil {
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return AuthResponse{}, "", statusErr(http.StatusConflict, "USERNAME_TAKEN", "Username sudah dipakai. Coba yang lain.")
		}
		return AuthResponse{}, "", err
	}
	emailPtr := email
	if _, err := s.q.InsertIdentity(ctx, u.ID, "password", nil, &emailPtr); err != nil {
		return AuthResponse{}, "", err
	}
	return s.issueSession(ctx, u)
}

func (s *Service) Login(ctx context.Context, in LoginRequest) (AuthResponse, string, error) {
	if err := s.validate.Struct(in); err != nil {
		return AuthResponse{}, "", statusErr(http.StatusBadRequest, "VALIDATION_ERROR", err.Error())
	}
	identifier := strings.TrimSpace(in.Identifier)
	if identifier == "" {
		return AuthResponse{}, "", statusErr(http.StatusBadRequest, "VALIDATION_ERROR", "Identifier required.")
	}
	lockKey := strings.ToLower(identifier)
	locked, err := s.cache.LockoutActive(ctx, lockKey)
	if err != nil {
		return AuthResponse{}, "", err
	}
	if locked {
		return AuthResponse{}, "", statusErr(http.StatusLocked, "ACCOUNT_LOCKED", "Terlalu banyak percobaan. Coba lagi dalam 15 menit.")
	}
	u, err := s.lookupByIdentifier(ctx, identifier)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			if _, e := s.cache.LockoutIncr(ctx, lockKey); e != nil {
				return AuthResponse{}, "", e
			}
			return AuthResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_CREDENTIALS", "Email/username atau password salah.")
		}
		return AuthResponse{}, "", err
	}
	if u.PasswordHash == nil || *u.PasswordHash == "" {
		return AuthResponse{}, "", statusErr(http.StatusUnauthorized, "NO_PASSWORD_SET", "Akun ini login pakai social login. Silakan login lewat Google atau set password dulu.")
	}
	okpw, err := VerifyPassword(in.Password, *u.PasswordHash)
	if err != nil || !okpw {
		if _, e := s.cache.LockoutIncr(ctx, lockKey); e != nil {
			return AuthResponse{}, "", e
		}
		return AuthResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_CREDENTIALS", "Email/username atau password salah.")
	}
	if err := s.cache.LockoutReset(ctx, lockKey); err != nil {
		return AuthResponse{}, "", err
	}
	return s.issueSession(ctx, u)
}

func (s *Service) lookupByIdentifier(ctx context.Context, identifier string) (sqlc.User, error) {
	if strings.Contains(identifier, "@") {
		return s.q.GetUserByEmail(ctx, strings.ToLower(identifier))
	}
	return s.q.GetUserByUsername(ctx, identifier)
}

func (s *Service) Refresh(ctx context.Context, refreshJTI string) (RefreshResponse, string, error) {
	if refreshJTI == "" {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "NO_REFRESH", "Missing refresh token.")
	}
	raw, err := s.cache.RefreshGet(ctx, refreshJTI)
	if err == redis.Nil || raw == "" {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Sesi sudah berakhir, silakan login ulang.")
	}
	if err != nil {
		return RefreshResponse{}, "", err
	}
	var meta struct {
		UserID string `json:"user_id"`
		Family string `json:"family"`
	}
	if err := json.Unmarshal([]byte(raw), &meta); err != nil {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Sesi sudah berakhir, silakan login ulang.")
	}
	userID, err := uuid.Parse(meta.UserID)
	if err != nil {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Sesi sudah berakhir, silakan login ulang.")
	}
	family, err := uuid.Parse(meta.Family)
	if err != nil {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Sesi sudah berakhir, silakan login ulang.")
	}
	if err := s.cache.RefreshDel(ctx, refreshJTI); err != nil {
		return RefreshResponse{}, "", err
	}
	u, err := s.q.GetUserByID(ctx, userID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Sesi sudah berakhir, silakan login ulang.")
		}
		return RefreshResponse{}, "", err
	}
	newJTI := uuid.New()
	payload := s.refreshPayloadJSON(u.ID, family)
	if err := s.cache.RefreshSet(ctx, newJTI.String(), payload, s.cfg.RefreshTokenTTL); err != nil {
		return RefreshResponse{}, "", err
	}
	accessStr, _, _, err := s.access.Issue(u.ID, u.Email)
	if err != nil {
		_ = s.cache.RefreshDel(ctx, newJTI.String())
		return RefreshResponse{}, "", err
	}
	providers, err := s.providersOf(ctx, u.ID)
	if err != nil {
		return RefreshResponse{}, "", err
	}
	dto := userToDTO(u, providers)
	if err := s.cacheUserDTO(ctx, u.ID.String(), dto); err != nil {
		return RefreshResponse{}, "", err
	}
	return RefreshResponse{AccessToken: accessStr}, newJTI.String(), nil
}

func (s *Service) Me(ctx context.Context, userID uuid.UUID) (UserDTO, error) {
	key := userID.String()
	if js, err := s.cache.UserCacheGet(ctx, key); err == nil {
		var dto UserDTO
		if json.Unmarshal([]byte(js), &dto) == nil {
			return dto, nil
		}
	} else if err != nil && err != redis.Nil {
		return UserDTO{}, err
	}
	u, err := s.q.GetUserByID(ctx, userID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return UserDTO{}, statusErr(http.StatusUnauthorized, "USER_NOT_FOUND", "User not found.")
		}
		return UserDTO{}, err
	}
	providers, err := s.providersOf(ctx, u.ID)
	if err != nil {
		return UserDTO{}, err
	}
	dto := userToDTO(u, providers)
	_ = s.cacheUserDTO(ctx, u.ID.String(), dto)
	return dto, nil
}

func (s *Service) Logout(ctx context.Context, userID uuid.UUID, accessJTI string, accessExp time.Time, refreshJTI string) error {
	ttl := time.Until(accessExp)
	if ttl > 0 {
		if err := s.cache.BlacklistAdd(ctx, accessJTI, ttl); err != nil {
			return err
		}
	}
	if refreshJTI != "" {
		_ = s.cache.RefreshDel(ctx, refreshJTI)
	}
	_ = s.cache.UserCacheDel(ctx, userID.String())
	return nil
}
