package sqlc

import (
	"context"

	"github.com/google/uuid"
)

func (q *Queries) ResetUserFinancialData(ctx context.Context, userID uuid.UUID) error {
	stmts := []string{
		`DELETE FROM transactions WHERE user_id = $1`,
		`DELETE FROM budgets WHERE user_id = $1`,
		`DELETE FROM goals WHERE user_id = $1`,
		`DELETE FROM user_preferences WHERE user_id = $1`,
		`DELETE FROM categories WHERE user_id = $1`,
		`DELETE FROM wallets WHERE user_id = $1`,
		`DELETE FROM wallet_groups WHERE user_id = $1`,
	}
	for _, s := range stmts {
		if _, err := q.pool.Exec(ctx, s, userID); err != nil {
			return err
		}
	}
	return nil
}
