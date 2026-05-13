package wallet

import (
	"encoding/json"
	"net/http"

	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

func (h *Handler) ListGroups(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	out, err := h.svc.ListGroups(r.Context(), uid)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"groups": out})
}

func (h *Handler) CreateGroup(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in createGroupBody
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.CreateGroup(r.Context(), uid, in.Name, in.Icon)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusCreated, map[string]any{"group": out})
}

func (h *Handler) UpdateGroup(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_ID", "Invalid group id.")
		return
	}
	var in updateGroupBody
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.UpdateGroup(r.Context(), uid, id, in.Name, in.Icon)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"group": out})
}

func (h *Handler) DeleteGroup(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_ID", "Invalid group id.")
		return
	}
	if err := h.svc.DeleteGroup(r.Context(), uid, id); err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	w.WriteHeader(http.StatusNoContent)
}

type createGroupBody struct {
	Name string  `json:"name"`
	Icon *string `json:"icon"`
}

type updateGroupBody struct {
	Name string  `json:"name"`
	Icon *string `json:"icon"`
}
