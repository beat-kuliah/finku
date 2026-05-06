package sqlc

import (
	"context"

	"github.com/google/uuid"
)

const categoryCols = `id, user_id, name, icon, kind, archived_at, created_at, updated_at`

func scanCategory(row interface{ Scan(dest ...any) error }) (Category, error) {
	var c Category
	err := row.Scan(
		&c.ID, &c.UserID, &c.Name, &c.Icon, &c.Kind, &c.ArchivedAt, &c.CreatedAt, &c.UpdatedAt,
	)
	return c, err
}

func (q *Queries) CountCategoriesByUser(ctx context.Context, userID uuid.UUID) (int64, error) {
	var n int64
	err := q.pool.QueryRow(ctx, `SELECT COUNT(*) FROM categories WHERE user_id = $1`, userID).Scan(&n)
	return n, err
}

func (q *Queries) InsertCategory(ctx context.Context, userID uuid.UUID, name, kind string, icon *string) (Category, error) {
	row := q.pool.QueryRow(ctx, `
INSERT INTO categories (user_id, name, kind, icon)
VALUES ($1, $2, $3::category_kind, $4)
RETURNING `+categoryCols, userID, name, kind, icon)
	return scanCategory(row)
}

func (q *Queries) ListCategoriesByUser(ctx context.Context, userID uuid.UUID, archived *bool) ([]Category, error) {
	var sql string
	var args []any
	args = append(args, userID)
	if archived == nil {
		sql = `SELECT ` + categoryCols + ` FROM categories WHERE user_id = $1 ORDER BY kind, name`
	} else if *archived {
		sql = `SELECT ` + categoryCols + ` FROM categories WHERE user_id = $1 AND archived_at IS NOT NULL ORDER BY kind, name`
	} else {
		sql = `SELECT ` + categoryCols + ` FROM categories WHERE user_id = $1 AND archived_at IS NULL ORDER BY kind, name`
	}
	rows, err := q.pool.Query(ctx, sql, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Category
	for rows.Next() {
		c, err := scanCategory(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, c)
	}
	return out, rows.Err()
}

func (q *Queries) GetCategoryForUser(ctx context.Context, userID, categoryID uuid.UUID) (Category, error) {
	row := q.pool.QueryRow(ctx, `
SELECT `+categoryCols+` FROM categories WHERE id = $1 AND user_id = $2 LIMIT 1`, categoryID, userID)
	return scanCategory(row)
}

func (q *Queries) UpdateCategory(ctx context.Context, userID, categoryID uuid.UUID, name string, icon *string) (Category, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE categories SET name = $3, icon = $4, updated_at = NOW()
WHERE id = $2 AND user_id = $1 AND archived_at IS NULL
RETURNING `+categoryCols, userID, categoryID, name, icon)
	return scanCategory(row)
}

func (q *Queries) ArchiveCategory(ctx context.Context, userID, categoryID uuid.UUID) (Category, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE categories SET archived_at = NOW(), updated_at = NOW()
WHERE id = $2 AND user_id = $1 AND archived_at IS NULL
RETURNING `+categoryCols, userID, categoryID)
	return scanCategory(row)
}

func (q *Queries) UnarchiveCategory(ctx context.Context, userID, categoryID uuid.UUID) (Category, error) {
	row := q.pool.QueryRow(ctx, `
UPDATE categories SET archived_at = NULL, updated_at = NOW()
WHERE id = $2 AND user_id = $1 AND archived_at IS NOT NULL
RETURNING `+categoryCols, userID, categoryID)
	return scanCategory(row)
}

func (q *Queries) PauseBudgetsForCategory(ctx context.Context, userID, categoryID uuid.UUID) error {
	_, err := q.pool.Exec(ctx, `
UPDATE budgets SET paused_at = NOW(), updated_at = NOW()
WHERE user_id = $1 AND category_id = $2 AND paused_at IS NULL`, userID, categoryID)
	return err
}

func (q *Queries) UnpauseBudgetsForCategory(ctx context.Context, userID, categoryID uuid.UUID) error {
	_, err := q.pool.Exec(ctx, `
UPDATE budgets SET paused_at = NULL, updated_at = NOW()
WHERE user_id = $1 AND category_id = $2`, userID, categoryID)
	return err
}

// DefaultCategorySeed is used by bootstrap.
type DefaultCategorySeed struct {
	Name string
	Kind string
	Icon string
}

func DefaultCategoryTemplates() []DefaultCategorySeed {
	return []DefaultCategorySeed{
		{"Gaji", "income", "💼"},
		{"Bonus", "income", "🎁"},
		{"Investasi", "income", "📈"},
		{"Lainnya (Pemasukan)", "income", "➕"},
		{"Makan", "expense", "🍜"},
		{"Transport", "expense", "🚗"},
		{"Hiburan", "expense", "🎮"},
		{"Tagihan", "expense", "📄"},
		{"Kesehatan", "expense", "💊"},
		{"Lainnya", "expense", "📌"},
	}
}
