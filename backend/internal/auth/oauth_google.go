package auth

import (
	"context"
	"errors"

	"google.golang.org/api/idtoken"
)

// GoogleIDTokenVerifier verifies Google-issued OIDC ID tokens.
// Uses google.golang.org/api/idtoken which fetches Google's JWKS.
type GoogleIDTokenVerifier struct {
	clientID string
}

func NewGoogleIDTokenVerifier(clientID string) *GoogleIDTokenVerifier {
	return &GoogleIDTokenVerifier{clientID: clientID}
}

func (v *GoogleIDTokenVerifier) Verify(ctx context.Context, idToken string) (*OAuthClaims, error) {
	if v.clientID == "" {
		return nil, errors.New("google client id not configured")
	}
	payload, err := idtokenValidate(ctx, idToken, v.clientID)
	if err != nil {
		return nil, err
	}

	out := &OAuthClaims{
		Subject: payload.Subject,
	}
	if email, ok := payload.Claims["email"].(string); ok {
		out.Email = email
	}
	if v, ok := payload.Claims["email_verified"].(bool); ok {
		out.EmailVerified = v
	}
	if name, ok := payload.Claims["name"].(string); ok {
		out.Name = name
	}
	if out.Name == "" {
		given, _ := payload.Claims["given_name"].(string)
		family, _ := payload.Claims["family_name"].(string)
		joined := given
		if family != "" {
			if joined != "" {
				joined += " "
			}
			joined += family
		}
		out.Name = joined
	}
	return out, nil
}

var idtokenValidate = func(ctx context.Context, token, audience string) (*idtoken.Payload, error) {
	return idtoken.Validate(ctx, token, audience)
}
