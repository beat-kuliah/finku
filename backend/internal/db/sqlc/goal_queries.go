package sqlc

import (
	"context"
	"time"

	"github.com/google/uuid"
)

const goalCols = `id, user_id, name, target_amount, current_amount, deadline, created_at, updated_at`

func scanGoal(row interface{ Scan(dest ...any) error }) (Goal, error) {
	var g Goal
	err := row.Scan(
		&g.ID, &g.UserID, &g.Name, &g.TargetAmount, &g.CurrentAmount, &g.Deadline, &g.CreatedAt, &g.UpdatedAt,
	)
	return g, err
}

func (q *Queries) ListGoalsByUser(ctx context.Context, userID uuid.UUID) ([]Goal, error) {
	rows, err := q.pool.Query(ctx, `SELECT `+goalCols+` FROM goals WHERE user_id = $1 ORDER BY created_at DESC`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Goal
	for rows.Next() {
		g, err := scanGoal(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, g)
	}
	return out, rows.Err()
}

func (q *Queries) InsertGoal(ctx context.Context, userID uuid.UUID, name string, targetAmount int64, deadline *time.Time) (Goal, error) {
	row := q.pool.QueryRow(ctx, `
INSERT INTO goals (user_id, name, target_amount, deadline)
VALUES ($1, $2, $3, $4)
RETURNING `+goalCols, userID, name, targetAmount, deadline)
	return scanGoal(row)
}

func (q *Queries) UpdateGoal(ctx context.Context, userID, goalID uuid.UUID, name string, targetAmount int64, deadline *time.Time) (Goal, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE goals SET name = $3, target_amount = $4, deadline = $5, updated_at = NOW()
WHERE id = $2 AND user_id = $1
RETURNING `+goalCols, userID, goalID, name, targetAmount, deadline)
	return scanGoal(row)
}

func (q *Queries) ContributeGoal(ctx context.Context, userID, goalID uuid.UUID, delta int64) (Goal, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE goals SET current_amount = GREATEST(0, LEAST(current_amount + $3, target_amount)), updated_at = NOW()
WHERE id = $2 AND user_id = $1
RETURNING `+goalCols, userID, goalID, delta)
	return scanGoal(row)
}

func (q *Queries) DeleteGoal(ctx context.Context, userID, goalID uuid.UUID) (int64, error) {
	tag, err := q.pool.Exec(ctx, `DELETE FROM goals WHERE id = $1 AND user_id = $2`, goalID, userID)
	if err != nil {
		return 0, err
	}
	return tag.RowsAffected(), nil
}

func (q *Queries) GetGoalForUser(ctx context.Context, userID, goalID uuid.UUID) (Goal, error) {
	row := q.pool.QueryRow(ctx, `SELECT `+goalCols+` FROM goals WHERE id = $1 AND user_id = $2`, goalID, userID)
	return scanGoal(row)
}
