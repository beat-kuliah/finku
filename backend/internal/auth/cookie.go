package auth

import (
	"net/http"
	"time"

	"finku/backend/internal/config"
)

func setRefreshCookie(w http.ResponseWriter, cfg *config.Config, jti string) {
	http.SetCookie(w, &http.Cookie{
		Name:     cfg.RefreshCookieName,
		Value:    jti,
		Path:     "/api/auth",
		MaxAge:   int(cfg.RefreshTokenTTL.Seconds()),
		HttpOnly: true,
		Secure:   cfg.CookieSecure,
		SameSite: http.SameSiteLaxMode,
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
		SameSite: http.SameSiteLaxMode,
		Domain:   cfg.CookieDomain,
	})
}
