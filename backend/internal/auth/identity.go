package auth

import (
	"context"
	"errors"
	"net/http"
	"strings"

	"finku/backend/internal/db/sqlc"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

const (
	ProviderPassword = "password"
	ProviderGoogle   = "google"
)

type userResolveResult struct {
	user    sqlc.User
	created bool
	linked  bool
}

// resolveIdentity is the core "social login or signup" flow.
//  1. Lookup user_identities by (provider, sub) -> session.
//  2. Otherwise, lookup user by email and LINK a new identity row -> session.
//  3. Otherwise, create a new user (no password, no username) + identity row -> session.
//
// The created/linked user's `username` may be NULL — frontend will then prompt the user
// to set one (with a server-side suggestion derived from email).
func (s *Service) resolveIdentity(ctx context.Context, provider string, claims *OAuthClaims) (userResolveResult, error) {
	if claims == nil || claims.Subject == "" {
		return userResolveResult{}, statusErr(http.StatusUnauthorized, "INVALID_OAUTH", "Token OAuth tidak valid.")
	}

	id, err := s.q.GetIdentityByProviderSub(ctx, provider, claims.Subject)
	if err == nil {
		u, err := s.q.GetUserByID(ctx, id.UserID)
		if err != nil {
			return userResolveResult{}, err
		}
		return userResolveResult{user: u, created: false, linked: false}, nil
	}
	if !errors.Is(err, pgx.ErrNoRows) {
		return userResolveResult{}, err
	}

	emailLower := strings.ToLower(strings.TrimSpace(claims.Email))
	if emailLower != "" {
		existing, err := s.q.GetUserByEmail(ctx, emailLower)
		if err == nil {
			subPtr := claims.Subject
			emailPtr := emailLower
			if _, err := s.q.InsertIdentity(ctx, existing.ID, provider, &subPtr, &emailPtr); err != nil {
				return userResolveResult{}, err
			}
			_ = s.cache.UserCacheDel(ctx, existing.ID.String())
			return userResolveResult{user: existing, created: false, linked: true}, nil
		}
		if !errors.Is(err, pgx.ErrNoRows) {
			return userResolveResult{}, err
		}
	}

	if emailLower == "" {
		return userResolveResult{}, statusErr(http.StatusBadRequest, "OAUTH_NO_EMAIL", "Provider tidak memberikan email. Tidak bisa membuat akun.")
	}
	name := strings.TrimSpace(claims.Name)
	if name == "" {
		name = emailLower
	}
	u, err := s.q.CreateUser(ctx, emailLower, nil, name)
	if err != nil {
		return userResolveResult{}, err
	}
	subPtr := claims.Subject
	emailPtr := emailLower
	if _, err := s.q.InsertIdentity(ctx, u.ID, provider, &subPtr, &emailPtr); err != nil {
		return userResolveResult{}, err
	}
	return userResolveResult{user: u, created: true, linked: false}, nil
}

// LoginWithGoogle verifies a Google ID token and returns an auth session.
func (s *Service) LoginWithGoogle(ctx context.Context, idToken string) (AuthResponse, string, error) {
	if s.googleVerif == nil {
		return AuthResponse{}, "", statusErr(http.StatusServiceUnavailable, "GOOGLE_DISABLED", "Login Google belum aktif.")
	}
	claims, err := s.googleVerif.Verify(ctx, idToken)
	if err != nil {
		return AuthResponse{}, "", statusErr(http.StatusUnauthorized, "INVALID_OAUTH", "Token Google tidak valid.")
	}
	res, err := s.resolveIdentity(ctx, ProviderGoogle, claims)
	if err != nil {
		return AuthResponse{}, "", err
	}
	return s.issueSession(ctx, res.user)
}

// ListIdentities returns the connected identities for a user (provider list with metadata).
func (s *Service) ListIdentities(ctx context.Context, userID uuid.UUID) ([]IdentityDTO, error) {
	ids, err := s.q.ListIdentitiesByUser(ctx, userID)
	if err != nil {
		return nil, err
	}
	out := make([]IdentityDTO, 0, len(ids))
	for _, i := range ids {
		dto := IdentityDTO{
			Provider:  i.Provider,
			CreatedAt: i.CreatedAt.UTC().Format(timeRFC3339Millis),
		}
		if i.Email != nil {
			dto.Email = *i.Email
		}
		out = append(out, dto)
	}
	return out, nil
}

// UnlinkIdentity removes a provider link. Refuses to remove the last sign-in path
// (e.g., unlinking 'password' is rejected if no other identity exists).
func (s *Service) UnlinkIdentity(ctx context.Context, userID uuid.UUID, provider string) (UserDTO, error) {
	provider = strings.ToLower(strings.TrimSpace(provider))
	if provider != ProviderPassword && provider != ProviderGoogle {
		return UserDTO{}, statusErr(http.StatusBadRequest, "INVALID_PROVIDER", "Provider tidak dikenal.")
	}
	ids, err := s.q.ListIdentitiesByUser(ctx, userID)
	if err != nil {
		return UserDTO{}, err
	}
	hasOther := false
	hasTarget := false
	for _, i := range ids {
		if i.Provider == provider {
			hasTarget = true
			continue
		}
		hasOther = true
	}
	if !hasTarget {
		return UserDTO{}, statusErr(http.StatusNotFound, "IDENTITY_NOT_FOUND", "Akun ini tidak terhubung dengan provider tersebut.")
	}
	if !hasOther {
		return UserDTO{}, statusErr(http.StatusBadRequest, "LAST_IDENTITY", "Tidak bisa unlink — ini satu-satunya cara login. Set password atau hubungkan akun lain dulu.")
	}
	if _, err := s.q.DeleteIdentityByProvider(ctx, userID, provider); err != nil {
		return UserDTO{}, err
	}
	if provider == ProviderPassword {
		if _, err := s.q.ClearUserPassword(ctx, userID); err != nil {
			return UserDTO{}, err
		}
	}
	u, err := s.q.GetUserByID(ctx, userID)
	if err != nil {
		return UserDTO{}, err
	}
	providers, err := s.providersOf(ctx, userID)
	if err != nil {
		return UserDTO{}, err
	}
	dto := userToDTO(u, providers)
	_ = s.cacheUserDTO(ctx, userID.String(), dto)
	return dto, nil
}
