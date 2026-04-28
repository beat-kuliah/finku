package auth

import "finku/backend/internal/db/sqlc"

type RegisterRequest struct {
	Name     string `json:"name" validate:"required,min=2,max=120"`
	Email    string `json:"email" validate:"required,email,max=255"`
	Password string `json:"password" validate:"required,min=8"`
}

type LoginRequest struct {
	Email    string `json:"email" validate:"required,email,max=255"`
	Password string `json:"password" validate:"required"`
}

type AuthResponse struct {
	User         UserDTO `json:"user"`
	AccessToken  string  `json:"accessToken"`
}

type RefreshResponse struct {
	AccessToken string `json:"accessToken"`
}

type UserDTO struct {
	ID            string  `json:"id"`
	Email         string  `json:"email"`
	Name          string  `json:"name"`
	MonthlyIncome *int64  `json:"monthlyIncome,omitempty"`
	Payday        *int16  `json:"payday,omitempty"`
	Currency      string  `json:"currency"`
	CreatedAt     string  `json:"createdAt"`
	UpdatedAt     string  `json:"updatedAt"`
}

func userToDTO(u sqlc.User) UserDTO {
	return UserDTO{
		ID:            u.ID.String(),
		Email:         u.Email,
		Name:          u.Name,
		MonthlyIncome: u.MonthlyIncome,
		Payday:        u.Payday,
		Currency:      u.Currency,
		CreatedAt:     u.CreatedAt.UTC().Format(timeRFC3339Millis),
		UpdatedAt:     u.UpdatedAt.UTC().Format(timeRFC3339Millis),
	}
}

const timeRFC3339Millis = "2006-01-02T15:04:05.000Z07:00"
