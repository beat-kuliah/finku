package auth

import (
	"context"
	"net/http"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

func (s *Service) UpdateProfile(ctx context.Context, userID uuid.UUID, in PatchProfileRequest) (UserDTO, error) {
	if in.Payday != nil && (*in.Payday < 1 || *in.Payday > 31) {
		return UserDTO{}, statusErr(http.StatusBadRequest, "VALIDATION", "Payday harus antara 1 dan 31.")
	}
	u, err := s.q.UpdateUserFinancial(ctx, userID, in.MonthlyIncome, in.Payday, in.Currency)
	if err != nil {
		if err == pgx.ErrNoRows {
			return UserDTO{}, statusErr(http.StatusNotFound, "USER_NOT_FOUND", "User not found.")
		}
		return UserDTO{}, err
	}
	_ = s.cache.UserCacheDel(ctx, userID.String())
	providers, err := s.providersOf(ctx, userID)
	if err != nil {
		return UserDTO{}, err
	}
	return userToDTO(u, providers), nil
}
