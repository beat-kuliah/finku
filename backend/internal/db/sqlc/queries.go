package sqlc

import (
	"context"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgxpool"
)

// Queries wraps DB queries.
type Queries struct {
	pool *pgxpool.Pool
}

func New(pool *pgxpool.Pool) *Queries {
	return &Queries{pool: pool}
}

// Pool exposes the underlying pgx pool for transactional callers.
func (q *Queries) Pool() *pgxpool.Pool {
	return q.pool
}

const userColumns = `id, email, password_hash, name, username, monthly_income, payday, currency, created_at, updated_at`

func scanUser(row interface {
	Scan(dest ...any) error
}) (User, error) {
	var u User
	err := row.Scan(
		&u.ID,
		&u.Email,
		&u.PasswordHash,
		&u.Name,
		&u.Username,
		&u.MonthlyIncome,
		&u.Payday,
		&u.Currency,
		&u.CreatedAt,
		&u.UpdatedAt,
	)
	return u, err
}

const createUserSQL = `
INSERT INTO users (email, password_hash, name)
VALUES ($1, $2, $3)
RETURNING ` + userColumns

func (q *Queries) CreateUser(ctx context.Context, email string, passwordHash *string, name string) (User, error) {
	row := q.pool.QueryRow(ctx, createUserSQL, email, passwordHash, name)
	return scanUser(row)
}

const getUserByEmailSQL = `
SELECT ` + userColumns + ` FROM users WHERE email = $1 LIMIT 1`

func (q *Queries) GetUserByEmail(ctx context.Context, email string) (User, error) {
	row := q.pool.QueryRow(ctx, getUserByEmailSQL, email)
	return scanUser(row)
}

const getUserByUsernameSQL = `
SELECT ` + userColumns + ` FROM users WHERE LOWER(username) = LOWER($1) LIMIT 1`

func (q *Queries) GetUserByUsername(ctx context.Context, username string) (User, error) {
	row := q.pool.QueryRow(ctx, getUserByUsernameSQL, username)
	return scanUser(row)
}

const getUserByIDSQL = `
SELECT ` + userColumns + ` FROM users WHERE id = $1 LIMIT 1`

func (q *Queries) GetUserByID(ctx context.Context, id uuid.UUID) (User, error) {
	row := q.pool.QueryRow(ctx, getUserByIDSQL, id)
	return scanUser(row)
}

const updateUserPasswordSQL = `
UPDATE users SET password_hash = $2, updated_at = NOW() WHERE id = $1
RETURNING ` + userColumns

func (q *Queries) UpdateUserPassword(ctx context.Context, id uuid.UUID, passwordHash string) (User, error) {
	row := q.pool.QueryRow(ctx, updateUserPasswordSQL, id, passwordHash)
	return scanUser(row)
}

const updateUserUsernameSQL = `
UPDATE users SET username = $2, updated_at = NOW() WHERE id = $1
RETURNING ` + userColumns

func (q *Queries) UpdateUserUsername(ctx context.Context, id uuid.UUID, username string) (User, error) {
	row := q.pool.QueryRow(ctx, updateUserUsernameSQL, id, username)
	return scanUser(row)
}

const usernameExistsSQL = `
SELECT EXISTS (SELECT 1 FROM users WHERE LOWER(username) = LOWER($1))`

func (q *Queries) UsernameExists(ctx context.Context, username string) (bool, error) {
	var exists bool
	err := q.pool.QueryRow(ctx, usernameExistsSQL, username).Scan(&exists)
	return exists, err
}

// ----- user_identities -----

const identityColumns = `id, user_id, provider, provider_user_id, email, created_at`

func scanIdentity(row interface {
	Scan(dest ...any) error
}) (UserIdentity, error) {
	var i UserIdentity
	err := row.Scan(
		&i.ID,
		&i.UserID,
		&i.Provider,
		&i.ProviderUserID,
		&i.Email,
		&i.CreatedAt,
	)
	return i, err
}

const insertIdentitySQL = `
INSERT INTO user_identities (user_id, provider, provider_user_id, email)
VALUES ($1, $2, $3, $4)
RETURNING ` + identityColumns

func (q *Queries) InsertIdentity(ctx context.Context, userID uuid.UUID, provider string, providerUserID, email *string) (UserIdentity, error) {
	row := q.pool.QueryRow(ctx, insertIdentitySQL, userID, provider, providerUserID, email)
	return scanIdentity(row)
}

const getIdentityByProviderSubSQL = `
SELECT ` + identityColumns + ` FROM user_identities
WHERE provider = $1 AND provider_user_id = $2 LIMIT 1`

func (q *Queries) GetIdentityByProviderSub(ctx context.Context, provider, sub string) (UserIdentity, error) {
	row := q.pool.QueryRow(ctx, getIdentityByProviderSubSQL, provider, sub)
	return scanIdentity(row)
}

const listIdentitiesByUserSQL = `
SELECT ` + identityColumns + ` FROM user_identities
WHERE user_id = $1 ORDER BY created_at ASC`

func (q *Queries) ListIdentitiesByUser(ctx context.Context, userID uuid.UUID) ([]UserIdentity, error) {
	rows, err := q.pool.Query(ctx, listIdentitiesByUserSQL, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []UserIdentity
	for rows.Next() {
		i, err := scanIdentity(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, i)
	}
	return out, rows.Err()
}

const deleteIdentityByProviderSQL = `
DELETE FROM user_identities WHERE user_id = $1 AND provider = $2`

func (q *Queries) DeleteIdentityByProvider(ctx context.Context, userID uuid.UUID, provider string) (int64, error) {
	tag, err := q.pool.Exec(ctx, deleteIdentityByProviderSQL, userID, provider)
	if err != nil {
		return 0, err
	}
	return tag.RowsAffected(), nil
}

const clearUserPasswordSQL = `
UPDATE users SET password_hash = NULL, updated_at = NOW() WHERE id = $1
RETURNING ` + userColumns

func (q *Queries) ClearUserPassword(ctx context.Context, id uuid.UUID) (User, error) {
	row := q.pool.QueryRow(ctx, clearUserPasswordSQL, id)
	return scanUser(row)
}
