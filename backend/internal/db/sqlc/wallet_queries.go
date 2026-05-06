package sqlc

import (
	"context"

	"github.com/google/uuid"
)

const walletCols = `id, user_id, name, wallet_type, icon, balance, archived_at, created_at, updated_at`

func scanWallet(row interface{ Scan(dest ...any) error }) (Wallet, error) {
	var w Wallet
	err := row.Scan(
		&w.ID, &w.UserID, &w.Name, &w.WalletType, &w.Icon, &w.Balance,
		&w.ArchivedAt, &w.CreatedAt, &w.UpdatedAt,
	)
	return w, err
}

func (q *Queries) CountWalletsByUser(ctx context.Context, userID uuid.UUID) (int64, error) {
	var n int64
	err := q.pool.QueryRow(ctx, `SELECT COUNT(*) FROM wallets WHERE user_id = $1`, userID).Scan(&n)
	return n, err
}

func (q *Queries) InsertWallet(ctx context.Context, userID uuid.UUID, name, walletType string, icon *string) (Wallet, error) {
	row := q.pool.QueryRow(ctx, `
INSERT INTO wallets (user_id, name, wallet_type, icon)
VALUES ($1, $2, $3, $4)
RETURNING `+walletCols, userID, name, walletType, icon)
	return scanWallet(row)
}

func (q *Queries) ListWalletsByUser(ctx context.Context, userID uuid.UUID, includeArchived bool) ([]Wallet, error) {
	var sql string
	if includeArchived {
		sql = `SELECT ` + walletCols + ` FROM wallets WHERE user_id = $1 ORDER BY created_at ASC`
	} else {
		sql = `SELECT ` + walletCols + ` FROM wallets WHERE user_id = $1 AND archived_at IS NULL ORDER BY created_at ASC`
	}
	rows, err := q.pool.Query(ctx, sql, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Wallet
	for rows.Next() {
		w, err := scanWallet(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, w)
	}
	return out, rows.Err()
}

func (q *Queries) GetWalletForUser(ctx context.Context, userID, walletID uuid.UUID) (Wallet, error) {
	row := q.pool.QueryRow(ctx, `
SELECT `+walletCols+` FROM wallets WHERE id = $1 AND user_id = $2 LIMIT 1`, walletID, userID)
	return scanWallet(row)
}

func (q *Queries) UpdateWallet(ctx context.Context, userID, walletID uuid.UUID, name, walletType string, icon *string) (Wallet, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE wallets SET name = $3, wallet_type = $4, icon = $5, updated_at = NOW()
WHERE id = $2 AND user_id = $1
RETURNING `+walletCols, userID, walletID, name, walletType, icon)
	return scanWallet(row)
}

func (q *Queries) ArchiveWallet(ctx context.Context, userID, walletID uuid.UUID) (Wallet, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE wallets SET archived_at = NOW(), updated_at = NOW()
WHERE id = $2 AND user_id = $1 AND archived_at IS NULL
RETURNING `+walletCols, userID, walletID)
	return scanWallet(row)
}

func (q *Queries) AdjustWalletBalance(ctx context.Context, walletID uuid.UUID, delta int64) error {
	_, err := q.pool.Exec(ctx, `
UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE id = $1`, walletID, delta)
	return err
}

func (q *Queries) SetWalletBalance(ctx context.Context, userID, walletID uuid.UUID, balance int64) (Wallet, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE wallets SET balance = $3, updated_at = NOW() WHERE id = $2 AND user_id = $1
RETURNING `+walletCols, userID, walletID, balance)
	return scanWallet(row)
}
