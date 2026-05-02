package middleware

import "net/http"

// SecurityHeaders sets a strict baseline of HTTP response headers to mitigate
// common browser-side attacks. The CSP is API-friendly (this server returns
// JSON only); if the same process ever serves HTML, the policy must be revised.
//
// hstsEnabled should only be true behind HTTPS (i.e. production behind a TLS
// terminator). Wired to APP_ENV=production at the call site so dev machines
// on plain HTTP never accidentally pin browsers to https://localhost.
func SecurityHeaders(hstsEnabled bool) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			h := w.Header()
			h.Set("X-Content-Type-Options", "nosniff")
			h.Set("X-Frame-Options", "DENY")
			h.Set("Referrer-Policy", "strict-origin-when-cross-origin")
			h.Set("Permissions-Policy", "geolocation=(), microphone=(), camera=(), payment=()")
			h.Set("Cross-Origin-Opener-Policy", "same-origin")
			h.Set("Cross-Origin-Resource-Policy", "same-site")
			// API-only CSP: nothing should ever be loaded from a JSON response.
			h.Set("Content-Security-Policy", "default-src 'none'; frame-ancestors 'none'")
			if hstsEnabled {
				h.Set("Strict-Transport-Security", "max-age=63072000; includeSubDomains; preload")
			}
			next.ServeHTTP(w, r)
		})
	}
}
