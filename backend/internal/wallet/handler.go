package wallet

import (
	"encoding/json"
	"net/http"

	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"

	"github.com/go-chi/chi/v5"
	"github.com/google/uuid"
)

type Handler struct {
	svc *Service
}

func NewHandler(svc *Service) *Handler { return &Handler{svc: svc} }

func (h *Handler) List(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	include := r.URL.Query().Get("archived") == "1"
	out, err := h.svc.List(r.Context(), uid, include)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"wallets": out})
}

func (h *Handler) Create(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in createWalletBody
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.Create(r.Context(), uid, in.Name, in.WalletType, in.Icon)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusCreated, map[string]any{"wallet": out})
}

func (h *Handler) Update(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_ID", "Invalid wallet id.")
		return
	}
	var in updateWalletBody
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	out, err := h.svc.Update(r.Context(), uid, id, in.Name, in.WalletType, in.Icon)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"wallet": out})
}

func (h *Handler) Archive(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	id, err := uuid.Parse(chi.URLParam(r, "id"))
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_ID", "Invalid wallet id.")
		return
	}
	out, err := h.svc.Archive(r.Context(), uid, id)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"wallet": out})
}

type createWalletBody struct {
	Name       string  `json:"name"`
	WalletType string  `json:"walletType"`
	Icon       *string `json:"icon"`
}

type updateWalletBody struct {
	Name       string  `json:"name"`
	WalletType string  `json:"walletType"`
	Icon       *string `json:"icon"`
}
