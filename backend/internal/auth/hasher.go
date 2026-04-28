package auth

import "github.com/alexedwards/argon2id"

func HashPassword(password string, p argon2id.Params) (string, error) {
	pp := p
	return argon2id.CreateHash(password, &pp)
}

func VerifyPassword(password, encodedHash string) (bool, error) {
	return argon2id.ComparePasswordAndHash(password, encodedHash)
}
