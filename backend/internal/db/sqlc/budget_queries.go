package sqlc

import (
	"context"
	"time"

	"github.com/google/uuid"
)

const budgetCols = `id, user_id, category_id, period, period_anchor, limit_amount, paused_at, created_at, updated_at`

func scanBudget(row interface{ Scan(dest ...any) error }) (Budget, error) {
	var b Budget
	err := row.Scan(
		&b.ID, &b.UserID, &b.CategoryID, &b.Period, &b.PeriodAnchor, &b.LimitAmount,
		&b.PausedAt, &b.CreatedAt, &b.UpdatedAt,
	)
	return b, err
}

func (q *Queries) ListBudgetsWithSpent(ctx context.Context, userID uuid.UUID, from, to time.Time) ([]BudgetWithSpent, error) {
	rows, err := q.pool.Query(ctx, `
SELECT b.id, b.user_id, b.category_id, b.period::text, b.period_anchor, b.limit_amount, b.paused_at, b.created_at, b.updated_at,
  COALESCE(s.spent, 0)::bigint,
  c.name AS category_name
FROM budgets b
JOIN categories c ON c.id = b.category_id AND c.user_id = b.user_id
LEFT JOIN (
  SELECT category_id, SUM(amount)::bigint AS spent
  FROM transactions
  WHERE user_id = $1 AND kind = 'expense' AND occurred_at >= $2::date AND occurred_at <= $3::date
  GROUP BY category_id
) s ON s.category_id = b.category_id
WHERE b.user_id = $1
ORDER BY b.period_anchor DESC, b.created_at ASC`, userID, from, to)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []BudgetWithSpent
	for rows.Next() {
		var bw BudgetWithSpent
		err := rows.Scan(
			&bw.ID, &bw.UserID, &bw.CategoryID, &bw.Period, &bw.PeriodAnchor, &bw.LimitAmount,
			&bw.PausedAt, &bw.CreatedAt, &bw.UpdatedAt, &bw.Spent, &bw.CategoryName,
		)
		if err != nil {
			return nil, err
		}
		out = append(out, bw)
	}
	return out, rows.Err()
}

func (q *Queries) InsertBudget(ctx context.Context, userID, categoryID uuid.UUID, period string, periodAnchor time.Time, limitAmount int64) (Budget, error) {
	row := q.pool.QueryRow(ctx, `
INSERT INTO budgets (user_id, category_id, period, period_anchor, limit_amount)
VALUES ($1, $2, $3::budget_period, $4, $5)
RETURNING `+budgetCols, userID, categoryID, period, periodAnchor, limitAmount)
	return scanBudget(row)
}

func (q *Queries) UpdateBudget(ctx context.Context, userID, budgetID uuid.UUID, limitAmount int64) (Budget, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE budgets SET limit_amount = $3, updated_at = NOW()
WHERE id = $2 AND user_id = $1
RETURNING `+budgetCols, userID, budgetID, limitAmount)
	return scanBudget(row)
}

func (q *Queries) DeleteBudget(ctx context.Context, userID, budgetID uuid.UUID) (int64, error) {
	tag, err := q.pool.Exec(ctx, `DELETE FROM budgets WHERE id = $1 AND user_id = $2`, budgetID, userID)
	if err != nil {
		return 0, err
	}
	return tag.RowsAffected(), nil
}

func (q *Queries) GetBudgetForUser(ctx context.Context, userID, budgetID uuid.UUID) (Budget, error) {
	row := q.pool.QueryRow(ctx, `SELECT `+budgetCols+` FROM budgets WHERE id = $1 AND user_id = $2`, budgetID, userID)
	return scanBudget(row)
}
