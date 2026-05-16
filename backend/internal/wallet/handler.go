package wallet

import (
	"encoding/json"
	"net/http"
	"strings"
	"time"

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
	gid, err := parseCreateGroupID(in.GroupID)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	out, err := h.svc.Create(r.Context(), uid, in.Name, in.WalletType, in.Icon, gid)
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
	existing, err := h.svc.GetWallet(r.Context(), uid, id)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	gid, err := parsePatchGroupID(in.GroupIDRaw, existing.GroupID)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	out, err := h.svc.Update(r.Context(), uid, id, in.Name, in.WalletType, in.Icon, gid)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"wallet": out})
}

func (h *Handler) AdjustBalance(w http.ResponseWriter, r *http.Request) {
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
	var in adjustBalanceBody
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	occ := time.Now()
	if in.OccurredAt != "" {
		parsed, err := time.Parse("2006-01-02", in.OccurredAt)
		if err != nil {
			httpx.Error(w, http.StatusBadRequest, "VALIDATION", "occurredAt harus YYYY-MM-DD.")
			return
		}
		occ = parsed
	}
	var catID *uuid.UUID
	if in.CategoryID != nil && *in.CategoryID != "" {
		c, err := uuid.Parse(*in.CategoryID)
		if err != nil {
			httpx.Error(w, http.StatusBadRequest, "VALIDATION", "categoryId invalid.")
			return
		}
		catID = &c
	}
	out, err := h.svc.AdjustBalance(r.Context(), uid, id, AdjustBalanceInput{
		NewBalance:  in.NewBalance,
		RecordAs:    in.RecordAs,
		CategoryID:  catID,
		OccurredAt:  occ,
		Description: in.Description,
	})
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, out)
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

type adjustBalanceBody struct {
	NewBalance  int64   `json:"newBalance"`
	RecordAs    string  `json:"recordAs"`
	CategoryID  *string `json:"categoryId"`
	OccurredAt  string  `json:"occurredAt"`
	Description *string `json:"description"`
}

type createWalletBody struct {
	Name       string  `json:"name"`
	WalletType string  `json:"walletType"`
	Icon       *string `json:"icon"`
	GroupID    *string `json:"groupId"`
}

type updateWalletBody struct {
	Name         string          `json:"name"`
	WalletType   string          `json:"walletType"`
	Icon         *string         `json:"icon"`
	GroupIDRaw   json.RawMessage `json:"groupId"`
}

func parseCreateGroupID(s *string) (*uuid.UUID, error) {
	if s == nil {
		return nil, nil
	}
	t := strings.TrimSpace(*s)
	if t == "" {
		return nil, nil
	}
	id, err := uuid.Parse(t)
	if err != nil {
		return nil, httpx.SvcErr(http.StatusBadRequest, "BAD_ID", "groupId tidak valid.")
	}
	return &id, nil
}

func parsePatchGroupID(raw json.RawMessage, existing *uuid.UUID) (*uuid.UUID, error) {
	if len(raw) == 0 {
		return existing, nil
	}
	if string(raw) == "null" {
		return nil, nil
	}
	var s string
	if err := json.Unmarshal(raw, &s); err != nil {
		return nil, httpx.SvcErr(http.StatusBadRequest, "BAD_ID", "groupId tidak valid.")
	}
	s = strings.TrimSpace(s)
	if s == "" {
		return nil, nil
	}
	id, err := uuid.Parse(s)
	if err != nil {
		return nil, httpx.SvcErr(http.StatusBadRequest, "BAD_ID", "groupId tidak valid.")
	}
	return &id, nil
}
