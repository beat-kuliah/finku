-- name: CreateUser :one
INSERT INTO users (
  email,
  password_hash,
  name
) VALUES (
  $1, $2, $3
)
RETURNING *;

-- name: GetUserByEmail :one
SELECT * FROM users
WHERE email = $1 LIMIT 1;

-- name: GetUserByUsername :one
SELECT * FROM users
WHERE LOWER(username) = LOWER($1) LIMIT 1;

-- name: GetUserByID :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: UpdateUserPassword :one
UPDATE users SET password_hash = $2, updated_at = NOW()
WHERE id = $1 RETURNING *;

-- name: UpdateUserUsername :one
UPDATE users SET username = $2, updated_at = NOW()
WHERE id = $1 RETURNING *;

-- name: UsernameExists :one
SELECT EXISTS (SELECT 1 FROM users WHERE LOWER(username) = LOWER($1));

-- name: ClearUserPassword :one
UPDATE users SET password_hash = NULL, updated_at = NOW()
WHERE id = $1 RETURNING *;

-- name: InsertIdentity :one
INSERT INTO user_identities (user_id, provider, provider_user_id, email)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetIdentityByProviderSub :one
SELECT * FROM user_identities
WHERE provider = $1 AND provider_user_id = $2 LIMIT 1;

-- name: ListIdentitiesByUser :many
SELECT * FROM user_identities WHERE user_id = $1 ORDER BY created_at ASC;

-- name: DeleteIdentityByProvider :exec
DELETE FROM user_identities WHERE user_id = $1 AND provider = $2;
