package auth

import (
	"net/http"
	"time"

	"finku/backend/internal/config"
)

// sameSiteMode returns SameSite=Strict in production (Secure cookies) to
// prevent the refresh token from being attached to cross-site requests. In
// dev (Secure=false), Lax is used so cookie still flows over plain HTTP from
// a local Vite proxy without needing __Host- prefix semantics.
func sameSiteMode(cfg *config.Config) http.SameSite {
	if cfg.CookieSecure {
		return http.SameSiteStrictMode
	}
	return http.SameSiteLaxMode
}

func setRefreshCookie(w http.ResponseWriter, cfg *config.Config, jti string) {
	http.SetCookie(w, &http.Cookie{
		Name:     cfg.RefreshCookieName,
		Value:    jti,
		Path:     "/api/auth",
		MaxAge:   int(cfg.RefreshTokenTTL.Seconds()),
		HttpOnly: true,
		Secure:   cfg.CookieSecure,
		SameSite: sameSiteMode(cfg),
		Domain:   cfg.CookieDomain,
	})
}

func clearRefreshCookie(w http.ResponseWriter, cfg *config.Config) {
	http.SetCookie(w, &http.Cookie{
		Name:     cfg.RefreshCookieName,
		Value:    "",
		Path:     "/api/auth",
		MaxAge:   -1,
		Expires:  time.Unix(0, 0),
		HttpOnly: true,
		Secure:   cfg.CookieSecure,
		SameSite: sameSiteMode(cfg),
		Domain:   cfg.CookieDomain,
	})
}
