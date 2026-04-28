package middleware

import (
	"net"
	"net/http"
	"strings"

	"finku/backend/internal/cache"
	"finku/backend/internal/httpx"
)

type RateLimiter struct {
	cache *cache.Client
}

func NewRateLimiter(c *cache.Client) *RateLimiter {
	return &RateLimiter{cache: c}
}

func (r *RateLimiter) Limit(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		ip := clientIP(req)
		ok, err := r.cache.RateLimitAllow(req.Context(), ip)
		if err != nil {
			httpx.Error(w, http.StatusInternalServerError, "INTERNAL", "Something went wrong.")
			return
		}
		if !ok {
			httpx.Error(w, http.StatusTooManyRequests, "RATE_LIMITED", "Too many requests. Try again later.")
			return
		}
		next.ServeHTTP(w, req)
	})
}

func clientIP(r *http.Request) string {
	if fwd := r.Header.Get("X-Forwarded-For"); fwd != "" {
		return strings.TrimSpace(strings.Split(fwd, ",")[0])
	}
	if rip := r.Header.Get("X-Real-IP"); rip != "" {
		return strings.TrimSpace(rip)
	}
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err == nil {
		return host
	}
	return r.RemoteAddr
}
