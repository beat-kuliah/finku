package auth

import (
	"log/slog"
	"net/http"
	"strings"

	"finku/backend/internal/middleware"

	chimw "github.com/go-chi/chi/v5/middleware"
)

// auditLog emits a single structured log entry for an authentication-related
// event. Log lines are intended for security incident review (failed logins,
// brute force, suspicious IP patterns) so we always include IP, user-agent
// and the request id propagated by chi's RequestID middleware.
//
// The identifier (email/username) is partially redacted to avoid storing raw
// PII in long-lived log streams while keeping enough signal to spot patterns.
func auditLog(r *http.Request, action, outcome, identifier string, extra ...any) {
	attrs := []any{
		"event", "auth_audit",
		"action", action,
		"outcome", outcome,
		"ip", middleware.ClientIP(r),
		"ua", r.Header.Get("User-Agent"),
		"req_id", chimw.GetReqID(r.Context()),
	}
	if identifier != "" {
		attrs = append(attrs, "identifier", redactIdentifier(identifier))
	}
	attrs = append(attrs, extra...)
	if outcome == "success" {
		slog.Info("auth", attrs...)
	} else {
		slog.Warn("auth", attrs...)
	}
}

// redactIdentifier turns "alice@example.com" into "a***@example.com" and a
// bare username "alice" into "a***". Keeps first character + domain so we can
// still bucket attempts per user without persisting full PII.
func redactIdentifier(id string) string {
	id = strings.TrimSpace(id)
	if id == "" {
		return ""
	}
	at := strings.LastIndex(id, "@")
	if at <= 0 {
		return maskHead(id)
	}
	return maskHead(id[:at]) + id[at:]
}

func maskHead(s string) string {
	if len(s) <= 1 {
		return "*"
	}
	return s[:1] + "***"
}
