package auth

type StatusError struct {
	Status  int
	Code    string
	Message string
}

func (e *StatusError) Error() string {
	return e.Message
}

func statusErr(status int, code, msg string) *StatusError {
	return &StatusError{Status: status, Code: code, Message: msg}
}
