package token

import (
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type AccessClaims struct {
	Email string `json:"email"`
	jwt.RegisteredClaims
}

type AccessIssuer struct {
	secret []byte
	ttl    time.Duration
}

func NewAccessIssuer(secret []byte, ttl time.Duration) *AccessIssuer {
	return &AccessIssuer{secret: secret, ttl: ttl}
}

func (a *AccessIssuer) Issue(userID uuid.UUID, email string) (token string, jti string, exp time.Time, err error) {
	jti = uuid.NewString()
	now := time.Now()
	exp = now.Add(a.ttl)
	claims := AccessClaims{
		Email: email,
		RegisteredClaims: jwt.RegisteredClaims{
			Subject:   userID.String(),
			ID:        jti,
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(exp),
		},
	}
	t := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	s, err := t.SignedString(a.secret)
	if err != nil {
		return "", "", time.Time{}, err
	}
	return s, jti, exp, nil
}

func (a *AccessIssuer) Parse(tokenStr string) (*AccessClaims, error) {
	t, err := jwt.ParseWithClaims(tokenStr, &AccessClaims{}, func(t *jwt.Token) (any, error) {
		if t.Method != jwt.SigningMethodHS256 {
			return nil, fmt.Errorf("unexpected signing method")
		}
		return a.secret, nil
	})
	if err != nil {
		return nil, err
	}
	claims, ok := t.Claims.(*AccessClaims)
	if !ok || !t.Valid {
		return nil, fmt.Errorf("invalid token")
	}
	return claims, nil
}
