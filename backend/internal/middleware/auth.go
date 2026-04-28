package middleware

import (
	"context"
	"net/http"
	"strings"
	"time"

	"finku/backend/internal/cache"
	"finku/backend/internal/httpx"
	"finku/backend/internal/token"

	"github.com/google/uuid"
)

type ctxKey int

const (
	ctxUserID ctxKey = iota
	ctxAccessJTI
	ctxAccessExp
)

func UserID(ctx context.Context) (uuid.UUID, bool) {
	v, ok := ctx.Value(ctxUserID).(uuid.UUID)
	return v, ok
}

func AccessJTI(ctx context.Context) (string, bool) {
	v, ok := ctx.Value(ctxAccessJTI).(string)
	return v, ok
}

func AccessExp(ctx context.Context) (time.Time, bool) {
	v, ok := ctx.Value(ctxAccessExp).(time.Time)
	return v, ok
}

type Auth struct {
	access *token.AccessIssuer
	cache  *cache.Client
}

func NewAuth(access *token.AccessIssuer, c *cache.Client) *Auth {
	return &Auth{access: access, cache: c}
}

func (a *Auth) Require(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		h := r.Header.Get("Authorization")
		if h == "" || !strings.HasPrefix(strings.ToLower(h), "bearer ") {
			httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Missing or invalid authorization header.")
			return
		}
		raw := strings.TrimSpace(h[7:])
		claims, err := a.access.Parse(raw)
		if err != nil {
			httpx.Error(w, http.StatusUnauthorized, "INVALID_TOKEN", "Invalid or expired access token.")
			return
		}
		jti := claims.ID
		if jti == "" {
			httpx.Error(w, http.StatusUnauthorized, "INVALID_TOKEN", "Invalid or expired access token.")
			return
		}
		bl, err := a.cache.BlacklistHas(r.Context(), jti)
		if err != nil {
			httpx.Error(w, http.StatusInternalServerError, "INTERNAL", "Something went wrong.")
			return
		}
		if bl {
			httpx.Error(w, http.StatusUnauthorized, "TOKEN_REVOKED", "Session has been revoked.")
			return
		}
		uid, err := uuid.Parse(claims.Subject)
		if err != nil {
			httpx.Error(w, http.StatusUnauthorized, "INVALID_TOKEN", "Invalid or expired access token.")
			return
		}
		var exp time.Time
		if claims.ExpiresAt != nil {
			exp = claims.ExpiresAt.Time
		}
		ctx := context.WithValue(r.Context(), ctxUserID, uid)
		ctx = context.WithValue(ctx, ctxAccessJTI, jti)
		ctx = context.WithValue(ctx, ctxAccessExp, exp)
		next.ServeHTTP(w, r.WithContext(ctx))
	})
}
