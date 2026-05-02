package sqlc

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

const txCols = `t.id, t.user_id, t.kind, t.wallet_id, t.dest_wallet_id, t.category_id, t.amount, t.occurred_at, t.description, t.created_at, t.updated_at`

func scanTransaction(row interface{ Scan(dest ...any) error }) (Transaction, error) {
	var t Transaction
	err := row.Scan(
		&t.ID, &t.UserID, &t.Kind, &t.WalletID, &t.DestWalletID, &t.CategoryID,
		&t.Amount, &t.OccurredAt, &t.Description, &t.CreatedAt, &t.UpdatedAt,
	)
	return t, err
}

type ListTransactionsParams struct {
	UserID     uuid.UUID
	From       *time.Time
	To         *time.Time
	Kind       *string
	WalletID   *uuid.UUID
	CategoryID *uuid.UUID
	Search     *string
	Limit      int32
	Offset     int32
}

func (q *Queries) ListTransactions(ctx context.Context, p ListTransactionsParams) ([]TransactionRow, error) {
	var b strings.Builder
	b.WriteString(`SELECT ` + txCols + `, c.name AS category_name
FROM transactions t
LEFT JOIN categories c ON c.id = t.category_id
WHERE t.user_id = $1`)
	args := []any{p.UserID}
	argN := 2
	if p.From != nil {
		b.WriteString(fmt.Sprintf(` AND t.occurred_at >= $%d`, argN))
		args = append(args, *p.From)
		argN++
	}
	if p.To != nil {
		b.WriteString(fmt.Sprintf(` AND t.occurred_at <= $%d`, argN))
		args = append(args, *p.To)
		argN++
	}
	if p.Kind != nil && *p.Kind != "" {
		b.WriteString(fmt.Sprintf(` AND t.kind = $%d::transaction_kind`, argN))
		args = append(args, *p.Kind)
		argN++
	}
	if p.WalletID != nil {
		b.WriteString(fmt.Sprintf(` AND (t.wallet_id = $%d OR t.dest_wallet_id = $%d)`, argN, argN))
		args = append(args, *p.WalletID)
		argN++
	}
	if p.CategoryID != nil {
		b.WriteString(fmt.Sprintf(` AND t.category_id = $%d`, argN))
		args = append(args, *p.CategoryID)
		argN++
	}
	if p.Search != nil && *p.Search != "" {
		b.WriteString(fmt.Sprintf(` AND t.description ILIKE $%d`, argN))
		args = append(args, "%"+*p.Search+"%")
		argN++
	}
	b.WriteString(` ORDER BY t.occurred_at DESC, t.created_at DESC`)
	limit := p.Limit
	if limit <= 0 {
		limit = 100
	}
	b.WriteString(fmt.Sprintf(` LIMIT %d OFFSET %d`, limit, maxInt32(0, p.Offset)))

	rows, err := q.pool.Query(ctx, b.String(), args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []TransactionRow
	for rows.Next() {
		var tr TransactionRow
		err := rows.Scan(
			&tr.ID, &tr.UserID, &tr.Kind, &tr.WalletID, &tr.DestWalletID, &tr.CategoryID,
			&tr.Amount, &tr.OccurredAt, &tr.Description, &tr.CreatedAt, &tr.UpdatedAt,
			&tr.CategoryName,
		)
		if err != nil {
			return nil, err
		}
		out = append(out, tr)
	}
	return out, rows.Err()
}

func maxInt32(a, b int32) int32 {
	if a > b {
		return a
	}
	return b
}

func (q *Queries) InsertTransaction(ctx context.Context, userID uuid.UUID, kind string, walletID uuid.UUID, destWalletID *uuid.UUID, categoryID *uuid.UUID, amount int64, occurredAt time.Time, description *string) (Transaction, error) {
	row := q.pool.QueryRow(ctx, `
INSERT INTO transactions (user_id, kind, wallet_id, dest_wallet_id, category_id, amount, occurred_at, description)
VALUES ($1, $2::transaction_kind, $3, $4, $5, $6, $7, $8)
RETURNING id, user_id, kind, wallet_id, dest_wallet_id, category_id, amount, occurred_at, description, created_at, updated_at`,
		userID, kind, walletID, destWalletID, categoryID, amount, occurredAt, description)
	return scanTransaction(row)
}

func (q *Queries) GetTransactionForUser(ctx context.Context, userID, txID uuid.UUID) (Transaction, error) {
	row := q.pool.QueryRow(ctx, `
SELECT id, user_id, kind, wallet_id, dest_wallet_id, category_id, amount, occurred_at, description, created_at, updated_at
FROM transactions WHERE id = $1 AND user_id = $2`, txID, userID)
	return scanTransaction(row)
}

func (q *Queries) GetTransactionRowForUser(ctx context.Context, userID, txID uuid.UUID) (TransactionRow, error) {
	row := q.pool.QueryRow(ctx, `
SELECT `+txCols+`, c.name AS category_name
FROM transactions t
LEFT JOIN categories c ON c.id = t.category_id
WHERE t.id = $1 AND t.user_id = $2`, txID, userID)
	var tr TransactionRow
	err := row.Scan(
		&tr.ID, &tr.UserID, &tr.Kind, &tr.WalletID, &tr.DestWalletID, &tr.CategoryID,
		&tr.Amount, &tr.OccurredAt, &tr.Description, &tr.CreatedAt, &tr.UpdatedAt,
		&tr.CategoryName,
	)
	return tr, err
}

func (q *Queries) UpdateTransaction(ctx context.Context, userID, txID uuid.UUID, kind string, walletID uuid.UUID, destWalletID *uuid.UUID, categoryID *uuid.UUID, amount int64, occurredAt time.Time, description *string) (Transaction, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE transactions SET
  kind = $3::transaction_kind,
  wallet_id = $4,
  dest_wallet_id = $5,
  category_id = $6,
  amount = $7,
  occurred_at = $8,
  description = $9,
  updated_at = NOW()
WHERE id = $2 AND user_id = $1
RETURNING id, user_id, kind, wallet_id, dest_wallet_id, category_id, amount, occurred_at, description, created_at, updated_at`,
		userID, txID, kind, walletID, destWalletID, categoryID, amount, occurredAt, description)
	return scanTransaction(row)
}

func (q *Queries) DeleteTransaction(ctx context.Context, userID, txID uuid.UUID) (int64, error) {
	tag, err := q.pool.Exec(ctx, `DELETE FROM transactions WHERE id = $1 AND user_id = $2`, txID, userID)
	if err != nil {
		return 0, err
	}
	return tag.RowsAffected(), nil
}

func (q *Queries) SumIncomeExpenseInRange(ctx context.Context, userID uuid.UUID, from, to time.Time) (income int64, expense int64, err error) {
	err = q.pool.QueryRow(ctx, `
SELECT
  COALESCE(SUM(CASE WHEN kind = 'income' THEN amount ELSE 0 END), 0),
  COALESCE(SUM(CASE WHEN kind = 'expense' THEN amount ELSE 0 END), 0)
FROM transactions
WHERE user_id = $1 AND occurred_at >= $2 AND occurred_at <= $3`, userID, from, to).Scan(&income, &expense)
	return
}

type DailyTrendRow struct {
	Day     time.Time `json:"day"`
	Income  int64     `json:"income"`
	Expense int64     `json:"expense"`
}

func (q *Queries) DailyTrend(ctx context.Context, userID uuid.UUID, from, to time.Time) ([]DailyTrendRow, error) {
	rows, err := q.pool.Query(ctx, `
SELECT d::date AS day,
  COALESCE(SUM(CASE WHEN t.kind = 'income' THEN t.amount END), 0)::bigint,
  COALESCE(SUM(CASE WHEN t.kind = 'expense' THEN t.amount END), 0)::bigint
FROM generate_series($2::date, $3::date, '1 day'::interval) d
LEFT JOIN transactions t ON t.user_id = $1 AND t.occurred_at = d::date AND t.kind IN ('income','expense')
GROUP BY d::date
ORDER BY d::date`, userID, from, to)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []DailyTrendRow
	for rows.Next() {
		var r DailyTrendRow
		if err := rows.Scan(&r.Day, &r.Income, &r.Expense); err != nil {
			return nil, err
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

type CategorySpendRow struct {
	CategoryID   uuid.UUID `json:"category_id"`
	CategoryName string    `json:"category_name"`
	Archived     bool      `json:"archived"`
	Total        int64     `json:"total"`
}

func (q *Queries) ExpenseByCategoryInRange(ctx context.Context, userID uuid.UUID, from, to time.Time) ([]CategorySpendRow, error) {
	rows, err := q.pool.Query(ctx, `
SELECT c.id, c.name, (c.archived_at IS NOT NULL) AS archived,
  COALESCE(SUM(t.amount), 0)::bigint
FROM transactions t
JOIN categories c ON c.id = t.category_id AND c.user_id = t.user_id
WHERE t.user_id = $1 AND t.kind = 'expense' AND t.occurred_at >= $2 AND t.occurred_at <= $3
GROUP BY c.id, c.name, c.archived_at
ORDER BY total DESC`, userID, from, to)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []CategorySpendRow
	for rows.Next() {
		var r CategorySpendRow
		if err := rows.Scan(&r.CategoryID, &r.CategoryName, &r.Archived, &r.Total); err != nil {
			return nil, err
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

type WeeklyExpenseRow struct {
	WeekStart time.Time `json:"week_start"`
	Total     int64     `json:"total"`
}

func (q *Queries) WeeklyExpenseInRange(ctx context.Context, userID uuid.UUID, from, to time.Time) ([]WeeklyExpenseRow, error) {
	rows, err := q.pool.Query(ctx, `
SELECT date_trunc('week', t.occurred_at)::date AS week_start,
  COALESCE(SUM(t.amount), 0)::bigint
FROM transactions t
WHERE t.user_id = $1 AND t.kind = 'expense' AND t.occurred_at >= $2 AND t.occurred_at <= $3
GROUP BY 1
ORDER BY 1`, userID, from, to)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []WeeklyExpenseRow
	for rows.Next() {
		var r WeeklyExpenseRow
		if err := rows.Scan(&r.WeekStart, &r.Total); err != nil {
			return nil, err
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

func (q *Queries) SpentForCategoryInRange(ctx context.Context, userID, categoryID uuid.UUID, from, to time.Time) (int64, error) {
	var sum int64
	err := q.pool.QueryRow(ctx, `
SELECT COALESCE(SUM(amount), 0)::bigint FROM transactions
WHERE user_id = $1 AND category_id = $2 AND kind = 'expense'
  AND occurred_at >= $3 AND occurred_at <= $4`,
		userID, categoryID, from, to).Scan(&sum)
	if err != nil {
		if err == pgx.ErrNoRows {
			return 0, nil
		}
		return 0, err
	}
	return sum, nil
}

func (q *Queries) LatestTransactions(ctx context.Context, userID uuid.UUID, n int) ([]TransactionRow, error) {
	if n <= 0 {
		n = 10
	}
	rows, err := q.pool.Query(ctx, `
SELECT `+txCols+`, c.name AS category_name
FROM transactions t
LEFT JOIN categories c ON c.id = t.category_id
WHERE t.user_id = $1
ORDER BY t.occurred_at DESC, t.created_at DESC
LIMIT $2`, userID, n)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []TransactionRow
	for rows.Next() {
		var tr TransactionRow
		err := rows.Scan(
			&tr.ID, &tr.UserID, &tr.Kind, &tr.WalletID, &tr.DestWalletID, &tr.CategoryID,
			&tr.Amount, &tr.OccurredAt, &tr.Description, &tr.CreatedAt, &tr.UpdatedAt,
			&tr.CategoryName,
		)
		if err != nil {
			return nil, err
		}
		out = append(out, tr)
	}
	return out, rows.Err()
}

func (q *Queries) TotalWalletBalance(ctx context.Context, userID uuid.UUID) (int64, error) {
	var sum int64
	err := q.pool.QueryRow(ctx, `
SELECT COALESCE(SUM(balance), 0)::bigint FROM wallets WHERE user_id = $1 AND archived_at IS NULL`, userID).Scan(&sum)
	return sum, err
}
