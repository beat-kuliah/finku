# AGENTS.md

## Cursor Cloud specific instructions

### Architecture

FinKu is a personal finance web app with three components:

| Component | Tech | Directory | Dev Port |
|-----------|------|-----------|----------|
| Backend API | Go (chi), PostgreSQL, Redis | `backend/` | `:8080` |
| Frontend SPA | React 18, Vite, Tailwind | `frontend/` | `:5173` |
| Mobile (optional) | Flutter/Dart | `mobile/` | N/A |

### Prerequisites

- **Go 1.25+** — the `go.mod` requires `go 1.25.0`; the VM default `go1.22.2` is too old. Go 1.25 is installed at `/usr/local/go/bin/go`.
- **PostgreSQL 16** — database `finku`, user `finku`, password `finku` on `localhost:5432`.
- **Redis 7** — default `localhost:6379`.
- **Node.js 22** (pre-installed via nvm) — used with npm for the frontend.
- **golang-migrate CLI** — installed via `go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest`.

### Starting services

```bash
# Start PostgreSQL and Redis (if not already running)
sudo pg_ctlcluster 16 main start
sudo redis-server --daemonize yes

# Run backend migrations (idempotent)
export PATH=/usr/local/go/bin:$HOME/go/bin:$PATH
export DATABASE_URL="postgres://finku:finku@localhost:5432/finku?sslmode=disable"
cd backend && migrate -path migrations -database "$DATABASE_URL" up

# Start backend (from backend/)
go run ./cmd/server

# Start frontend (from frontend/)
npm run dev
```

### Common commands

| Task | Command | Directory |
|------|---------|-----------|
| Backend run | `make run` or `go run ./cmd/server` | `backend/` |
| Frontend dev | `npm run dev` | `frontend/` |
| Frontend lint | `npm run lint` | `frontend/` |
| Frontend type-check | `npx tsc --noEmit` | `frontend/` |
| Frontend build | `npm run build` | `frontend/` |
| Go vet | `go vet ./...` | `backend/` |
| Run migrations | `make migrate-up` (needs `DATABASE_URL` env) | `backend/` |
| Install Go tools | `make tools` | `backend/` |

### Non-obvious notes

- The backend `.env` file is not committed. Copy `backend/.env.example` to `backend/.env` for local dev; default values work out of the box with the local PostgreSQL/Redis setup described above.
- The Vite dev server proxies `/api` requests to `localhost:8080` (the Go backend), so both servers must be running for the full app to work.
- `go.mod` specifies `go 1.25.0`. Ensure `/usr/local/go/bin` is on `PATH` before the system Go.
- Google OAuth (`GOOGLE_CLIENT_ID`) is optional; email/password auth works without it.
- The frontend has 2 pre-existing ESLint errors in `EditWalletModal.tsx` (setState in effect). These are in the existing codebase and not introduced by setup.
- Most frontend pages beyond auth (Dashboard, Transactions, Budget, Stats, Goals) use mock/hardcoded data — only the auth flow (`/api/auth/*`) is fully wired to the backend at this time. Additional domain routes (wallets, categories, transactions, budgets, goals, summary, preferences) exist in the backend.
