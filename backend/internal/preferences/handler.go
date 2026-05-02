package preferences

import (
	"encoding/json"
	"net/http"

	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"
)

type Handler struct{ svc *Service }

func NewHandler(svc *Service) *Handler { return &Handler{svc: svc} }

func (h *Handler) Get(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	out, err := h.svc.Get(r.Context(), uid)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"preferences": out})
}

func (h *Handler) Patch(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in struct {
		NotifyBudgetWarning *bool   `json:"notifyBudgetWarning"`
		NotifyReminder       *bool   `json:"notifyReminder"`
		NotifyWeeklyReport   *bool   `json:"notifyWeeklyReport"`
		Theme                *string `json:"theme"`
	}
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.Patch(r.Context(), uid, in.NotifyBudgetWarning, in.NotifyReminder, in.NotifyWeeklyReport, in.Theme)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"preferences": out})
}
