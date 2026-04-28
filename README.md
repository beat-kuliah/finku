# finku

Personal finance UI (React) + Go auth API.

- **Frontend**: `frontend/` — `npm install` then `npm run dev` (Vite proxies `/api` → `http://localhost:8080`).
- **Backend**: `backend/` — Postgres + Redis, see [backend/README.md](backend/README.md). Copy `backend/.env.example` to `backend/.env`, run migrations, then `go run ./cmd/server`.
