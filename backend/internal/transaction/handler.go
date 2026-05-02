package transaction

import (
	"encoding/json"
	"net/http"
	"time"

	"finku/backend/internal/db/sqlc"
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
	q := r.URL.Query()
	p := sqlc.ListTransactionsParams{UserID: uid}
	if v := q.Get("from"); v != "" {
		t, err := time.Parse("2006-01-02", v)
		if err == nil {
			p.From = &t
		}
	}
	if v := q.Get("to"); v != "" {
		t, err := time.Parse("2006-01-02", v)
		if err == nil {
			p.To = &t
		}
	}
	if v := q.Get("kind"); v != "" {
		p.Kind = &v
	}
	if v := q.Get("walletId"); v != "" {
		if id, err := uuid.Parse(v); err == nil {
			p.WalletID = &id
		}
	}
	if v := q.Get("categoryId"); v != "" {
		if id, err := uuid.Parse(v); err == nil {
			p.CategoryID = &id
		}
	}
	if v := q.Get("q"); v != "" {
		p.Search = &v
	}
	p.Limit = 100
	p.Offset = 0
	out, err := h.svc.List(r.Context(), p)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"transactions": out})
}

func (h *Handler) Create(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in bodyTx
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	wid, err := uuid.Parse(in.WalletID)
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "VALIDATION", "walletId invalid.")
		return
	}
	occ, err := time.Parse("2006-01-02", in.OccurredAt)
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "VALIDATION", "occurredAt harus YYYY-MM-DD.")
		return
	}
	ci := CreateInput{
		Kind: in.Kind, WalletID: wid, Amount: in.Amount, OccurredAt: occ, Description: in.Description,
	}
	if in.DestWalletID != nil {
		if d, e := uuid.Parse(*in.DestWalletID); e == nil {
			ci.DestWalletID = &d
		}
	}
	if in.CategoryID != nil {
		if c, e := uuid.Parse(*in.CategoryID); e == nil {
			ci.CategoryID = &c
		}
	}
	out, err := h.svc.Create(r.Context(), uid, ci)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusCreated, map[string]any{"transaction": out})
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
	var in bodyTx
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	wid, err := uuid.Parse(in.WalletID)
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "VALIDATION", "walletId invalid.")
		return
	}
	occ, err := time.Parse("2006-01-02", in.OccurredAt)
	if err != nil {
		httpx.Error(w, http.StatusBadRequest, "VALIDATION", "occurredAt harus YYYY-MM-DD.")
		return
	}
	ui := UpdateInput{
		Kind: in.Kind, WalletID: wid, Amount: in.Amount, OccurredAt: occ, Description: in.Description,
	}
	if in.DestWalletID != nil {
		if d, e := uuid.Parse(*in.DestWalletID); e == nil {
			ui.DestWalletID = &d
		}
	}
	if in.CategoryID != nil {
		if c, e := uuid.Parse(*in.CategoryID); e == nil {
			ui.CategoryID = &c
		}
	}
	out, err := h.svc.Update(r.Context(), uid, id, ui)
	if err != nil {
		httpx.WriteServiceError(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"transaction": out})
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

type bodyTx struct {
	Kind         string  `json:"kind"`
	WalletID     string  `json:"walletId"`
	DestWalletID *string `json:"destWalletId"`
	CategoryID   *string `json:"categoryId"`
	Amount       int64   `json:"amount"`
	OccurredAt   string  `json:"occurredAt"`
	Description  *string `json:"description"`
}
