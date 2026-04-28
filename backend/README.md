# FinKu backend (Go)

Auth API: register, login, refresh (httpOnly cookie), me, logout. Uses PostgreSQL + Redis.

## Prerequisites

- Go 1.22+
- PostgreSQL 16+ (or 15)
- Redis 7+
- [golang-migrate](https://github.com/golang-migrate/migrate) CLI for migrations

## Local dev (Docker Postgres + Redis)

```bash
docker run -d --name finku-pg -e POSTGRES_PASSWORD=finku -e POSTGRES_USER=finku -e POSTGRES_DB=finku -p 5432:5432 postgres:16-alpine
docker run -d --name finku-redis -p 6379:6379 redis:7-alpine
```

Copy `.env.example` to `.env` and set `JWT_SECRET` (min 32 characters).

```bash
export DATABASE_URL=postgres://finku:finku@localhost:5432/finku?sslmode=disable
migrate -path migrations -database "$DATABASE_URL" up
```

Run server:

```bash
go run ./cmd/server
```

API base: `http://localhost:8080/api`

## Redis authentication

You can configure Redis credentials in either way:

- In URL form: `REDIS_URL=redis://:your_password@localhost:6379/0`
- Or with separate env vars:
  - `REDIS_URL=redis://localhost:6379/0`
  - `REDIS_USERNAME=...` (optional, ACL user)
  - `REDIS_PASSWORD=...`

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/health` | Health check |
| POST | `/api/auth/register` | Body `{name,email,password}` → `{user, accessToken}` + refresh cookie |
| POST | `/api/auth/login` | Body `{email,password}` |
| POST | `/api/auth/refresh` | Uses refresh cookie → `{accessToken}` + rotated cookie |
| GET | `/api/auth/me` | Bearer access token → `{user}` |
| POST | `/api/auth/logout` | Bearer + refresh cookie → 204 |

## sqlc

`sqlc generate` may fail on some Windows setups (WASM). Query code lives in `internal/db/sqlc/queries.go` (hand-maintained, mirrors sqlc).

## Frontend

Run Vite with proxy to this server (see repo `frontend/vite.config.ts`). `CORS_ORIGIN` must match the dev UI origin (default `http://localhost:5173`).
