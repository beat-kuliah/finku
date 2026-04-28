package sqlc

import (
	"time"

	"github.com/google/uuid"
)

// User mirrors the users table (hand-maintained; sqlc generate may replace on Linux).
type User struct {
	ID            uuid.UUID `json:"id"`
	Email         string    `json:"email"`
	PasswordHash  string    `json:"-"`
	Name          string    `json:"name"`
	MonthlyIncome *int64    `json:"monthly_income,omitempty"`
	Payday        *int16    `json:"payday,omitempty"`
	Currency      string    `json:"currency"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}
