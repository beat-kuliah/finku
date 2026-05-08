package sqlc

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

const walletGroupCols = `id, user_id, name, icon, created_at, updated_at`

func scanWalletGroup(row interface{ Scan(dest ...any) error }) (WalletGroup, error) {
	var g WalletGroup
	err := row.Scan(&g.ID, &g.UserID, &g.Name, &g.Icon, &g.CreatedAt, &g.UpdatedAt)
	return g, err
}

func (q *Queries) InsertWalletGroup(ctx context.Context, userID uuid.UUID, name string, icon *string) (WalletGroup, error) {
	row := q.pool.QueryRow(ctx, `
INSERT INTO wallet_groups (user_id, name, icon)
VALUES ($1, $2, $3)
RETURNING `+walletGroupCols, userID, name, icon)
	return scanWalletGroup(row)
}

func (q *Queries) ListWalletGroupsWithStats(ctx context.Context, userID uuid.UUID) ([]WalletGroupWithStats, error) {
	rows, err := q.pool.Query(ctx, `
SELECT wg.id, wg.user_id, wg.name, wg.icon, wg.created_at, wg.updated_at,
       COUNT(w.id) FILTER (WHERE w.archived_at IS NULL),
       COALESCE(SUM(w.balance) FILTER (WHERE w.archived_at IS NULL), 0)::bigint
FROM wallet_groups wg
LEFT JOIN wallets w ON w.group_id = wg.id
WHERE wg.user_id = $1
GROUP BY wg.id
ORDER BY LOWER(wg.name)`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []WalletGroupWithStats
	for rows.Next() {
		var r WalletGroupWithStats
		err := rows.Scan(
			&r.ID, &r.UserID, &r.Name, &r.Icon, &r.CreatedAt, &r.UpdatedAt,
			&r.WalletCount, &r.TotalBalance,
		)
		if err != nil {
			return nil, err
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

func (q *Queries) GetWalletGroupForUser(ctx context.Context, userID, groupID uuid.UUID) (WalletGroup, error) {
	row := q.pool.QueryRow(ctx, `
SELECT `+walletGroupCols+` FROM wallet_groups WHERE id = $1 AND user_id = $2 LIMIT 1`, groupID, userID)
	return scanWalletGroup(row)
}

func (q *Queries) UpdateWalletGroup(ctx context.Context, userID, groupID uuid.UUID, name string, icon *string) (WalletGroup, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE wallet_groups SET name = $3, icon = $4, updated_at = NOW()
WHERE id = $2 AND user_id = $1
RETURNING `+walletGroupCols, userID, groupID, name, icon)
	return scanWalletGroup(row)
}

func (q *Queries) DeleteWalletGroup(ctx context.Context, userID, groupID uuid.UUID) error {
	tag, err := q.pool.Exec(ctx, `DELETE FROM wallet_groups WHERE id = $1 AND user_id = $2`, groupID, userID)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return pgx.ErrNoRows
	}
	return nil
}
