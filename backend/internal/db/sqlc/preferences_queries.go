package sqlc

import (
	"context"

	"github.com/google/uuid"
)

const prefCols = `user_id, notify_budget_warning, notify_reminder, notify_weekly_report, theme, updated_at`

func scanPrefs(row interface{ Scan(dest ...any) error }) (UserPreferences, error) {
	var p UserPreferences
	err := row.Scan(
		&p.UserID, &p.NotifyBudgetWarning, &p.NotifyReminder, &p.NotifyWeeklyReport, &p.Theme, &p.UpdatedAt,
	)
	return p, err
}

func (q *Queries) UpsertUserPreferences(ctx context.Context, userID uuid.UUID, notifyBudget, notifyReminder, notifyWeekly bool, theme string) (UserPreferences, error) {
	row := q.pool.QueryRow(ctx, `
INSERT INTO user_preferences (user_id, notify_budget_warning, notify_reminder, notify_weekly_report, theme)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (user_id) DO UPDATE SET
  notify_budget_warning = EXCLUDED.notify_budget_warning,
  notify_reminder = EXCLUDED.notify_reminder,
  notify_weekly_report = EXCLUDED.notify_weekly_report,
  theme = EXCLUDED.theme,
  updated_at = NOW()
RETURNING `+prefCols, userID, notifyBudget, notifyReminder, notifyWeekly, theme)
	return scanPrefs(row)
}

func (q *Queries) GetUserPreferences(ctx context.Context, userID uuid.UUID) (UserPreferences, error) {
	row := q.pool.QueryRow(ctx, `SELECT `+prefCols+` FROM user_preferences WHERE user_id = $1`, userID)
	return scanPrefs(row)
}

func (q *Queries) UpdateUserFinancial(ctx context.Context, userID uuid.UUID, monthlyIncome *int64, payday *int16, currency *string) (User, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE users SET
  monthly_income = COALESCE($2, monthly_income),
  payday = COALESCE($3, payday),
  currency = COALESCE(NULLIF(TRIM($4), ''), currency),
  updated_at = NOW()
WHERE id = $1
RETURNING `+userColumns, userID, monthlyIncome, payday, currency)
	return scanUser(row)
}
