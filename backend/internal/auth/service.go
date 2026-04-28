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
	cfg      *config.Config
	q        *sqlc.Queries
	cache    *cache.Client
	access   *token.AccessIssuer
	validate *validator.Validate
}

func NewService(cfg *config.Config, q *sqlc.Queries, c *cache.Client, access *token.AccessIssuer) *Service {
	return &Service{
		cfg:      cfg,
		q:        q,
		cache:    c,
		access:   access,
		validate: validator.New(),
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
	if err := s.cacheUser(ctx, u); err != nil {
		_ = s.cache.RefreshDel(ctx, refreshJTI.String())
		return AuthResponse{}, "", err
	}
	return AuthResponse{
		User:        userToDTO(u),
		AccessToken: accessStr,
	}, refreshJTI.String(), nil
}

func (s *Service) cacheUser(ctx context.Context, u sqlc.User) error {
	dto := userToDTO(u)
	b, err := json.Marshal(dto)
	if err != nil {
		return err
	}
	return s.cache.UserCacheSet(ctx, u.ID.String(), string(b), s.cfg.UserCacheTTL)
}

func (s *Service) Register(ctx context.Context, in RegisterRequest) (AuthResponse, string, error) {
	if err := s.validate.Struct(in); err != nil {
		return AuthResponse{}, "", statusErr(http.StatusBadRequest, "VALIDATION_ERROR", err.Error())
	}
	email := strings.ToLower(strings.TrimSpace(in.Email))
	hash, err := HashPassword(in.Password, s.cfg.Argon2Params)
	if err != nil {
		return AuthResponse{}, "", err
	}
	u, err := s.q.CreateUser(ctx, email, hash, strings.TrimSpace(in.Name))
	if err != nil {
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return AuthResponse{}, "", statusErr(http.StatusConflict, "EMAIL_TAKEN", "Email is already registered.")
		}
		return AuthResponse{}, "", err
	}
	return s.issueSession(ctx, u)
}

func (s *Service) Login(ctx context.Context, in LoginRequest) (AuthResponse, string, error) {
	if err := s.validate.Struct(in); err != nil {
		return AuthResponse{}, "", statusErr(http.StatusBadRequest, "VALIDATION_ERROR", err.Error())
	}
	email := strings.ToLower(strings.TrimSpace(in.Email))
	locked, err := s.cache.LockoutActive(ctx, email)
	if err != nil {
		return AuthResponse{}, "", err
	}
	if locked {
		return AuthResponse{}, "", statusErr(http.StatusLocked, "ACCOUNT_LOCKED", "Too many failed attempts. Try again in 15 minutes.")
	}
	u, err := s.q.GetUserByEmail(ctx, email)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			if _, e := s.cache.LockoutIncr(ctx, email); e != nil {
				return AuthResponse{}, "", e
			}
			return AuthResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_CREDENTIALS", "Invalid email or password.")
		}
		return AuthResponse{}, "", err
	}
	okpw, err := VerifyPassword(in.Password, u.PasswordHash)
	if err != nil || !okpw {
		if _, e := s.cache.LockoutIncr(ctx, email); e != nil {
			return AuthResponse{}, "", e
		}
		return AuthResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_CREDENTIALS", "Invalid email or password.")
	}
	if err := s.cache.LockoutReset(ctx, email); err != nil {
		return AuthResponse{}, "", err
	}
	return s.issueSession(ctx, u)
}

func (s *Service) Refresh(ctx context.Context, refreshJTI string) (RefreshResponse, string, error) {
	if refreshJTI == "" {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "NO_REFRESH", "Missing refresh token.")
	}
	raw, err := s.cache.RefreshGet(ctx, refreshJTI)
	if err == redis.Nil || raw == "" {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Session expired. Please log in again.")
	}
	if err != nil {
		return RefreshResponse{}, "", err
	}
	var meta struct {
		UserID string `json:"user_id"`
		Family string `json:"family"`
	}
	if err := json.Unmarshal([]byte(raw), &meta); err != nil {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Session expired. Please log in again.")
	}
	userID, err := uuid.Parse(meta.UserID)
	if err != nil {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Session expired. Please log in again.")
	}
	family, err := uuid.Parse(meta.Family)
	if err != nil {
		return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Session expired. Please log in again.")
	}
	if err := s.cache.RefreshDel(ctx, refreshJTI); err != nil {
		return RefreshResponse{}, "", err
	}
	u, err := s.q.GetUserByID(ctx, userID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return RefreshResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_REFRESH", "Session expired. Please log in again.")
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
	if err := s.cacheUser(ctx, u); err != nil {
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
	_ = s.cacheUser(ctx, u)
	return userToDTO(u), nil
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
