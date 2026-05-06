package budget

import (
	"encoding/json"
	"net/http"
	"net/url"
	"time"

	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

type Handler struct{ svc *Service }

func NewHandler(svc *Service) *Handler { return &Handler{svc: svc} }

func parseRange(qs url.Values) (from, to time.Time) {
	now := time.Now().UTC()
	from = time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, time.UTC)
	to = from.AddDate(0, 1, 0).Add(-time.Nanosecond)
	if v := qs.Get("from"); v != "" {
		if t, err := time.Parse("2006-01-02", v); err == nil {
			from = t
		}
	}
	if v := qs.Get("to"); v != "" {
		if t, err := time.Parse("2006-01-02", v); err == nil {
			to = t
		}
	}
	return from, to
}

func (h *Handler) List(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	from, to := parseRange(r.URL.Query())
	out, err := h.svc.List(r.Context(), uid, from, to)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"budgets": out})
}

func (h *Handler) Create(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in struct {
		CategoryID   string `json:"categoryId"`
		Period       string `json:"period"`
		PeriodAnchor string `json:"periodAnchor"`
		LimitAmount  int64  `json:"limitAmount"`
	}
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	cid, err := uuid.Parse(in.CategoryID)
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "VALIDATION", "categoryId invalid.")
		return
	}
	if in.Period == "" {
		in.Period = "monthly"
	}
	anchor := time.Now().UTC()
	if in.PeriodAnchor != "" {
		if t, e := time.Parse("2006-01-02", in.PeriodAnchor); e == nil {
			anchor = t
		}
	}
	out, err := h.svc.Create(r.Context(), uid, cid, in.Period, anchor, in.LimitAmount)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusCreated, map[string]any{"budget": out})
}

func (h *Handler) Update(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_ID", "Invalid id.")
		return
	}
	var in struct {
		LimitAmount int64 `json:"limitAmount"`
	}
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.Update(r.Context(), uid, id, in.LimitAmount)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"budget": out})
}

func (h *Handler) Delete(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_ID", "Invalid id.")
		return
	}
	if err := h.svc.Delete(r.Context(), uid, id); err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}
