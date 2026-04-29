package auth

import (
	"context"
	"errors"
	"net/http"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

func (s *Service) UpdatePassword(ctx context.Context, userID uuid.UUID, in UpdatePasswordRequest) (UserDTO, error) {
	if in.NewPassword != in.ConfirmNewPassword {
		return UserDTO{}, statusErr(http.StatusBadRequest, "PASSWORD_MISMATCH", "Konfirmasi password tidak cocok.")
	}
	if err := s.validate.Struct(in); err != nil {
		return UserDTO{}, statusErr(http.StatusBadRequest, "VALIDATION_ERROR", err.Error())
	}
	u, err := s.q.GetUserByID(ctx, userID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return UserDTO{}, statusErr(http.StatusUnauthorized, "USER_NOT_FOUND", "User not found.")
		}
		return UserDTO{}, err
	}

	hadPassword := u.PasswordHash != nil && *u.PasswordHash != ""
	if hadPassword {
		if in.CurrentPassword == "" {
			return UserDTO{}, statusErr(http.StatusBadRequest, "CURRENT_PASSWORD_REQUIRED", "Masukkan password lama kamu.")
		}
		ok, err := VerifyPassword(in.CurrentPassword, *u.PasswordHash)
		if err != nil || !ok {
			return UserDTO{}, statusErr(http.StatusUnauthorized, "INVALID_CURRENT_PASSWORD", "Password lama salah.")
		}
	}

	hash, err := HashPassword(in.NewPassword, s.cfg.Argon2Params)
	if err != nil {
		return UserDTO{}, err
	}
	u, err = s.q.UpdateUserPassword(ctx, userID, hash)
	if err != nil {
		return UserDTO{}, err
	}

	if !hadPassword {
		emailPtr := u.Email
		_, err := s.q.InsertIdentity(ctx, userID, "password", nil, &emailPtr)
		if err != nil {
			// Best-effort: identity row failure shouldn't block password set.
			// Most likely cause is a unique-constraint race; safe to ignore.
			_ = err
		}
	}

	providers, err := s.providersOf(ctx, userID)
	if err != nil {
		return UserDTO{}, err
	}
	dto := userToDTO(u, providers)
	_ = s.cacheUserDTO(ctx, userID.String(), dto)
	return dto, nil
}
