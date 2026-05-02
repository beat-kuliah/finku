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

// Wallet mirrors wallets.
type Wallet struct {
	ID          uuid.UUID  `json:"id"`
	UserID      uuid.UUID  `json:"user_id"`
	Name        string     `json:"name"`
	WalletType  string     `json:"wallet_type"`
	Icon        *string    `json:"icon,omitempty"`
	Balance     int64      `json:"balance"`
	ArchivedAt  *time.Time `json:"archived_at,omitempty"`
	CreatedAt   time.Time  `json:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at"`
}

// Category mirrors categories (kind: income | expense).
type Category struct {
	ID         uuid.UUID  `json:"id"`
	UserID     uuid.UUID  `json:"user_id"`
	Name       string     `json:"name"`
	Icon       *string    `json:"icon,omitempty"`
	Kind       string     `json:"kind"`
	ArchivedAt *time.Time `json:"archived_at,omitempty"`
	CreatedAt  time.Time  `json:"created_at"`
	UpdatedAt  time.Time  `json:"updated_at"`
}

// Transaction mirrors transactions.
type Transaction struct {
	ID            uuid.UUID  `json:"id"`
	UserID        uuid.UUID  `json:"user_id"`
	Kind          string     `json:"kind"`
	WalletID      uuid.UUID  `json:"wallet_id"`
	DestWalletID  *uuid.UUID `json:"dest_wallet_id,omitempty"`
	CategoryID    *uuid.UUID `json:"category_id,omitempty"`
	Amount        int64      `json:"amount"`
	OccurredAt    time.Time  `json:"occurred_at"`
	Description   *string    `json:"description,omitempty"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}

// TransactionRow includes joined category name for API responses.
type TransactionRow struct {
	Transaction
	CategoryName *string `json:"category_name,omitempty"`
}

// Budget mirrors budgets.
type Budget struct {
	ID           uuid.UUID  `json:"id"`
	UserID       uuid.UUID  `json:"user_id"`
	CategoryID   uuid.UUID  `json:"category_id"`
	Period       string     `json:"period"`
	PeriodAnchor time.Time  `json:"period_anchor"`
	LimitAmount  int64      `json:"limit_amount"`
	PausedAt     *time.Time `json:"paused_at,omitempty"`
	CreatedAt    time.Time  `json:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at"`
}

// BudgetWithSpent is used for listing budgets with spent in period.
type BudgetWithSpent struct {
	Budget
	Spent          int64  `json:"spent"`
	CategoryName   string `json:"category_name"`
}

// Goal mirrors goals.
type Goal struct {
	ID            uuid.UUID  `json:"id"`
	UserID        uuid.UUID  `json:"user_id"`
	Name          string     `json:"name"`
	TargetAmount  int64      `json:"target_amount"`
	CurrentAmount int64      `json:"current_amount"`
	Deadline      *time.Time `json:"deadline,omitempty"`
	CreatedAt     time.Time  `json:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at"`
}

// UserPreferences mirrors user_preferences.
type UserPreferences struct {
	UserID               uuid.UUID `json:"user_id"`
	NotifyBudgetWarning  bool      `json:"notify_budget_warning"`
	NotifyReminder       bool      `json:"notify_reminder"`
	NotifyWeeklyReport   bool      `json:"notify_weekly_report"`
	Theme                string    `json:"theme"`
	UpdatedAt            time.Time `json:"updated_at"`
}
