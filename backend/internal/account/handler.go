package account

import (
	"net/http"

	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/finance"
	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"
)

type Handler struct{ q *sqlc.Queries }

func NewHandler(q *sqlc.Queries) *Handler { return &Handler{q: q} }

func (h *Handler) ResetData(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	if err := h.q.ResetUserFinancialData(r.Context(), uid); err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	if err := finance.EnsureNewUserDefaults(r.Context(), h.q, uid); err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
