package sqlc

import (
	"time"

	"github.com/google/uuid"
)

// User mirrors the users table (hand-maintained; sqlc generate may replace on Linux).
type User struct {
	ID            uuid.UUID `json:"id"`
	Email         string    `json:"email"`
	PasswordHash  *string   `json:"-"`
	Name          string    `json:"name"`
	Username      *string   `json:"username,omitempty"`
	MonthlyIncome *int64    `json:"monthly_income,omitempty"`
	Payday        *int16    `json:"payday,omitempty"`
	Currency      string    `json:"currency"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

// UserIdentity mirrors the user_identities table.
type UserIdentity struct {
	ID             uuid.UUID `json:"id"`
	UserID         uuid.UUID `json:"user_id"`
	Provider       string    `json:"provider"`
	ProviderUserID *string   `json:"provider_user_id,omitempty"`
	Email          *string   `json:"email,omitempty"`
	CreatedAt      time.Time `json:"created_at"`
}
