package category

import (
	"encoding/json"
	"net/http"

	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

type Handler struct{ svc *Service }

func NewHandler(svc *Service) *Handler { return &Handler{svc: svc} }

func (h *Handler) List(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	archived := r.URL.Query().Get("archived")
	var a *bool
	switch archived {
	case "1", "true":
		v := true
		a = &v
	case "0", "false":
		v := false
		a = &v
	}
	out, err := h.svc.List(r.Context(), uid, a)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"categories": out})
}

func (h *Handler) Create(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in bodyCreate
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.Create(r.Context(), uid, in.Name, in.Kind, in.Icon)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusCreated, map[string]any{"category": out})
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
	var in bodyUpdate
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.Update(r.Context(), uid, id, in.Name, in.Icon)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"category": out})
}

func (h *Handler) Archive(w http.ResponseWriter, r *http.Request) {
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
	out, err := h.svc.Archive(r.Context(), uid, id)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"category": out})
}

func (h *Handler) Unarchive(w http.ResponseWriter, r *http.Request) {
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
	out, err := h.svc.Unarchive(r.Context(), uid, id)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"category": out})
}

type bodyCreate struct {
	Name string  `json:"name"`
	Kind string  `json:"kind"`
	Icon *string `json:"icon"`
}

type bodyUpdate struct {
	Name string  `json:"name"`
	Icon *string `json:"icon"`
}
