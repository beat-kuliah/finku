package httpx

import (
	"encoding/json"
	"errors"
	"net/http"
)

type APIError struct {
	Code    string `json:"code"`
	Message string `json:"message"`
}

type errBody struct {
	Error APIError `json:"error"`
}

func JSON(w http.ResponseWriter, status int, v any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(v)
}

func Error(w http.ResponseWriter, status int, code, message string) {
	JSON(w, status, errBody{Error: APIError{Code: code, Message: message}})
}

// ServiceError is returned by domain services for HTTP mapping.
type ServiceError struct {
	Status  int
	Code    string
	Message string
}

func (e *ServiceError) Error() string { return e.Message }

func SvcErr(status int, code, msg string) *ServiceError {
	return &ServiceError{Status: status, Code: code, Message: msg}
}

func WriteServiceError(w http.ResponseWriter, err error) {
	var se *ServiceError
	if errors.As(err, &se) {
		Error(w, se.Status, se.Code, se.Message)
		return
	}
	Error(w, http.StatusInternalServerError, "INTERNAL", "Something went wrong.")
}
