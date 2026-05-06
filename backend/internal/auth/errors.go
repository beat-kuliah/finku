package auth

import "finku/backend/internal/httpx"

// StatusError is an alias for shared HTTP service errors.
type StatusError = httpx.ServiceError

func statusErr(status int, code, msg string) *httpx.ServiceError {
	return httpx.SvcErr(status, code, msg)
}
