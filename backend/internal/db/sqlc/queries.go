package sqlc

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

// Queries wraps user queries (manual implementation; mirrors sqlc output).
type Queries struct {
	pool *pgxpool.Pool
}

func New(pool *pgxpool.Pool) *Queries {
	return &Queries{pool: pool}
}

const createUserSQL = `
INSERT INTO users (email, password_hash, name)
VALUES ($1, $2, $3)
RETURNING id, email, password_hash, name, monthly_income, payday, currency, created_at, updated_at
`

func (q *Queries) CreateUser(ctx context.Context, email, passwordHash, name string) (User, error) {
	row := q.pool.QueryRow(ctx, createUserSQL, email, passwordHash, name)
	var u User
	err := row.Scan(
		&u.ID,
		&u.Email,
		&u.PasswordHash,
		&u.Name,
		&u.MonthlyIncome,
		&u.Payday,
		&u.Currency,
		&u.CreatedAt,
		&u.UpdatedAt,
	)
	if err != nil {
		return User{}, err
	}
	return u, nil
}

const getUserByEmailSQL = `
SELECT id, email, password_hash, name, monthly_income, payday, currency, created_at, updated_at
FROM users
WHERE email = $1
LIMIT 1
`

func (q *Queries) GetUserByEmail(ctx context.Context, email string) (User, error) {
	row := q.pool.QueryRow(ctx, getUserByEmailSQL, email)
	var u User
	err := row.Scan(
		&u.ID,
		&u.Email,
		&u.PasswordHash,
		&u.Name,
		&u.MonthlyIncome,
		&u.Payday,
		&u.Currency,
		&u.CreatedAt,
		&u.UpdatedAt,
	)
	if err != nil {
		return User{}, err
	}
	return u, nil
}

const getUserByIDSQL = `
SELECT id, email, password_hash, name, monthly_income, payday, currency, created_at, updated_at
FROM users
WHERE id = $1
LIMIT 1
`

func (q *Queries) GetUserByID(ctx context.Context, id uuid.UUID) (User, error) {
	row := q.pool.QueryRow(ctx, getUserByIDSQL, id)
	var u User
	err := row.Scan(
		&u.ID,
		&u.Email,
		&u.PasswordHash,
		&u.Name,
		&u.MonthlyIncome,
		&u.Payday,
		&u.Currency,
		&u.CreatedAt,
		&u.UpdatedAt,
	)
	if err != nil {
		return User{}, err
	}
	return u, nil
}
