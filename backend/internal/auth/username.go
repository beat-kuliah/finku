package auth

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"

	"github.com/go-playground/validator/v10"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

var usernameRegex = regexp.MustCompile(`^[a-zA-Z0-9_]{3,32}$`)

var reservedUsernames = map[string]bool{
	"admin": true, "administrator": true, "root": true, "system": true,
	"api": true, "auth": true, "login": true, "logout": true, "register": true,
	"support": true, "help": true, "info": true, "contact": true,
	"finku": true, "official": true, "staff": true, "moderator": true, "mod": true,
	"me": true, "you": true, "user": true, "users": true, "null": true, "undefined": true,
}

// validateUsernameTag is a struct-tag validator (registered via validator.RegisterValidation).
func validateUsernameTag(fl validator.FieldLevel) bool {
	return usernameRegex.MatchString(fl.Field().String())
}

// ValidateUsernameFormat returns a StatusError if the username fails policy.
func ValidateUsernameFormat(username string) error {
	u := strings.TrimSpace(username)
	if !usernameRegex.MatchString(u) {
		return statusErr(http.StatusBadRequest, "INVALID_USERNAME", "Username harus 3-32 karakter, hanya huruf, angka, dan underscore.")
	}
	if reservedUsernames[strings.ToLower(u)] {
		return statusErr(http.StatusConflict, "USERNAME_RESERVED", "Username ini tidak tersedia, coba yang lain.")
	}
	return nil
}

func (s *Service) UpdateUsername(ctx context.Context, userID uuid.UUID, in UpdateUsernameRequest) (UserDTO, error) {
	username := strings.TrimSpace(in.Username)
	if err := ValidateUsernameFormat(username); err != nil {
		return UserDTO{}, err
	}
	exists, err := s.q.UsernameExists(ctx, username)
	if err != nil {
		return UserDTO{}, err
	}
	if exists {
		current, _ := s.q.GetUserByID(ctx, userID)
		if current.Username == nil || !strings.EqualFold(*current.Username, username) {
			return UserDTO{}, statusErr(http.StatusConflict, "USERNAME_TAKEN", "Username sudah dipakai. Coba yang lain.")
		}
	}
	u, err := s.q.UpdateUserUsername(ctx, userID, username)
	if err != nil {
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return UserDTO{}, statusErr(http.StatusConflict, "USERNAME_TAKEN", "Username sudah dipakai. Coba yang lain.")
		}
		if errors.Is(err, pgx.ErrNoRows) {
			return UserDTO{}, statusErr(http.StatusUnauthorized, "USER_NOT_FOUND", "User not found.")
		}
		return UserDTO{}, err
	}
	providers, err := s.providersOf(ctx, userID)
	if err != nil {
		return UserDTO{}, err
	}
	dto := userToDTO(u, providers)
	_ = s.cacheUserDTO(ctx, userID.String(), dto)
	return dto, nil
}

// SuggestUsername derives a unique username candidate based on the user's email.
func (s *Service) SuggestUsername(ctx context.Context, userID uuid.UUID) (string, error) {
	u, err := s.q.GetUserByID(ctx, userID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", statusErr(http.StatusUnauthorized, "USER_NOT_FOUND", "User not found.")
		}
		return "", err
	}
	return s.deriveUsernameFromEmail(ctx, u.Email)
}

var nonAlphanumeric = regexp.MustCompile(`[^a-z0-9_]`)

// deriveUsernameFromEmail returns a sanitized + unique candidate based on email prefix.
func (s *Service) deriveUsernameFromEmail(ctx context.Context, email string) (string, error) {
	prefix := email
	if i := strings.Index(prefix, "@"); i >= 0 {
		prefix = prefix[:i]
	}
	base := strings.ToLower(prefix)
	base = nonAlphanumeric.ReplaceAllString(base, "")
	if len(base) > 32 {
		base = base[:32]
	}
	if len(base) < 3 {
		base = base + "_user"
	}
	if reservedUsernames[base] {
		base = base + "_user"
	}
	if len(base) > 32 {
		base = base[:32]
	}

	candidate := base
	free, err := s.q.UsernameExists(ctx, candidate)
	if err != nil {
		return "", err
	}
	if !free {
		return candidate, nil
	}

	for i := 2; i <= 50; i++ {
		suffix := fmt.Sprintf("%d", i)
		room := 32 - len(suffix)
		if room < 1 {
			room = 1
		}
		head := base
		if len(head) > room {
			head = head[:room]
		}
		candidate = head + suffix
		exists, err := s.q.UsernameExists(ctx, candidate)
		if err != nil {
			return "", err
		}
		if !exists {
			return candidate, nil
		}
	}

	buf := make([]byte, 3)
	if _, err := rand.Read(buf); err != nil {
		return "", err
	}
	suffix := "_" + hex.EncodeToString(buf)
	room := 32 - len(suffix)
	if room < 1 {
		room = 1
	}
	head := base
	if len(head) > room {
		head = head[:room]
	}
	return head + suffix, nil
}
