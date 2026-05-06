package auth

import "finku/backend/internal/db/sqlc"

type RegisterRequest struct {
	Name     string `json:"name" validate:"required,min=2,max=120"`
	Username string `json:"username" validate:"required,min=3,max=32"`
	Email    string `json:"email" validate:"required,email,max=255"`
	Password string `json:"password" validate:"required,min=8"`
}

type LoginRequest struct {
	Identifier string `json:"identifier" validate:"required,min=3,max=255"`
	Password   string `json:"password" validate:"required"`
}

type UpdatePasswordRequest struct {
	CurrentPassword    string `json:"currentPassword"`
	NewPassword        string `json:"newPassword" validate:"required,min=8"`
	ConfirmNewPassword string `json:"confirmNewPassword" validate:"required,min=8"`
}

type UpdateUsernameRequest struct {
	Username string `json:"username" validate:"required,min=3,max=32"`
}

type OAuthRequest struct {
	IDToken string `json:"idToken" validate:"required"`
}

// PatchProfileRequest updates optional financial fields on the user row.
type PatchProfileRequest struct {
	MonthlyIncome *int64  `json:"monthlyIncome"`
	Payday        *int16  `json:"payday"`
	Currency      *string `json:"currency"`
}

type AuthResponse struct {
	User        UserDTO `json:"user"`
	AccessToken string  `json:"accessToken"`
}

type RefreshResponse struct {
	AccessToken string `json:"accessToken"`
}

type UsernameSuggestResponse struct {
	Suggestion string `json:"suggestion"`
}

type IdentityDTO struct {
	Provider  string `json:"provider"`
	Email     string `json:"email,omitempty"`
	CreatedAt string `json:"createdAt"`
}

type UserDTO struct {
	ID            string   `json:"id"`
	Email         string   `json:"email"`
	Name          string   `json:"name"`
	Username      *string  `json:"username"`
	HasPassword   bool     `json:"hasPassword"`
	Providers     []string `json:"providers"`
	MonthlyIncome *int64   `json:"monthlyIncome,omitempty"`
	Payday        *int16   `json:"payday,omitempty"`
	Currency      string   `json:"currency"`
	CreatedAt     string   `json:"createdAt"`
	UpdatedAt     string   `json:"updatedAt"`
}

func userToDTO(u sqlc.User, providers []string) UserDTO {
	if providers == nil {
		providers = []string{}
	}
	return UserDTO{
		ID:            u.ID.String(),
		Email:         u.Email,
		Name:          u.Name,
		Username:      u.Username,
		HasPassword:   u.PasswordHash != nil && *u.PasswordHash != "",
		Providers:     providers,
		MonthlyIncome: u.MonthlyIncome,
		Payday:        u.Payday,
		Currency:      u.Currency,
		CreatedAt:     u.CreatedAt.UTC().Format(timeRFC3339Millis),
		UpdatedAt:     u.UpdatedAt.UTC().Format(timeRFC3339Millis),
	}
}

const timeRFC3339Millis = "2006-01-02T15:04:05.000Z07:00"
