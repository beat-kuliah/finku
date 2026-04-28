package auth

import (
	"encoding/json"
	"errors"
	"net/http"
	"strings"

	"finku/backend/internal/config"
	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"
)

type Handler struct {
	cfg     *config.Config
	service *Service
}

func NewHandler(cfg *config.Config, svc *Service) *Handler {
	return &Handler{cfg: cfg, service: svc}
}

func (h *Handler) Register(w http.ResponseWriter, r *http.Request) {
	var in RegisterRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	resp, refreshJTI, err := h.service.Register(r.Context(), in)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	setRefreshCookie(w, h.cfg, refreshJTI)
	httpx.JSON(w, http.StatusCreated, resp)
}

func (h *Handler) Login(w http.ResponseWriter, r *http.Request) {
	var in LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	resp, refreshJTI, err := h.service.Login(r.Context(), in)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	setRefreshCookie(w, h.cfg, refreshJTI)
	httpx.JSON(w, http.StatusOK, resp)
}

func (h *Handler) Refresh(w http.ResponseWriter, r *http.Request) {
	c, err := r.Cookie(h.cfg.RefreshCookieName)
	refreshJTI := ""
	if err == nil && c != nil {
		refreshJTI = strings.TrimSpace(c.Value)
	}
	resp, newJTI, err := h.service.Refresh(r.Context(), refreshJTI)
	if err != nil {
		clearRefreshCookie(w, h.cfg)
		writeSvcErr(w, err)
		return
	}
	setRefreshCookie(w, h.cfg, newJTI)
	httpx.JSON(w, http.StatusOK, resp)
}

func (h *Handler) Me(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	dto, err := h.service.Me(r.Context(), uid)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"user": dto})
}

func (h *Handler) Logout(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	jti, _ := middleware.AccessJTI(r.Context())
	exp, _ := middleware.AccessExp(r.Context())
	c, err := r.Cookie(h.cfg.RefreshCookieName)
	refreshJTI := ""
	if err == nil && c != nil {
		refreshJTI = strings.TrimSpace(c.Value)
	}
	if err := h.service.Logout(r.Context(), uid, jti, exp, refreshJTI); err != nil {
		httpx.Error(w, http.StatusInternalServerError, "INTERNAL", "Something went wrong.")
		return
	}
	clearRefreshCookie(w, h.cfg)
	w.WriteHeader(http.StatusNoContent)
}

func writeSvcErr(w http.ResponseWriter, err error) {
	var se *StatusError
	if errors.As(err, &se) {
		httpx.Error(w, se.Status, se.Code, se.Message)
		return
	}
	httpx.Error(w, http.StatusInternalServerError, "INTERNAL", "Something went wrong.")
}
