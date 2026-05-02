package auth

import (
	"encoding/json"
	"net/http"
	"strings"

	"finku/backend/internal/config"
	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"

	"github.com/go-chi/chi/v5"
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
		auditLog(r, "register", "failure", in.Email, "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	setRefreshCookie(w, h.cfg, refreshJTI)
	auditLog(r, "register", "success", in.Email)
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
		auditLog(r, "login", "failure", in.Identifier, "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	setRefreshCookie(w, h.cfg, refreshJTI)
	auditLog(r, "login", "success", in.Identifier)
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
		auditLog(r, "refresh", "failure", "", "reason", err.Error())
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
		auditLog(r, "logout", "failure", "", "user_id", uid.String(), "reason", err.Error())
		httpx.Error(w, http.StatusInternalServerError, "INTERNAL", "Something went wrong.")
		return
	}
	clearRefreshCookie(w, h.cfg)
	auditLog(r, "logout", "success", "", "user_id", uid.String())
	w.WriteHeader(http.StatusNoContent)
}

func (h *Handler) UpdatePassword(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in UpdatePasswordRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	dto, err := h.service.UpdatePassword(r.Context(), uid, in)
	if err != nil {
		auditLog(r, "password_update", "failure", "", "user_id", uid.String(), "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	auditLog(r, "password_update", "success", "", "user_id", uid.String())
	httpx.JSON(w, http.StatusOK, map[string]any{"user": dto})
}

func (h *Handler) UpdateUsername(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in UpdateUsernameRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	dto, err := h.service.UpdateUsername(r.Context(), uid, in)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"user": dto})
}

func (h *Handler) SuggestUsername(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	suggestion, err := h.service.SuggestUsername(r.Context(), uid)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, UsernameSuggestResponse{Suggestion: suggestion})
}

func (h *Handler) OAuthGoogle(w http.ResponseWriter, r *http.Request) {
	var in OAuthRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	resp, refreshJTI, err := h.service.LoginWithGoogle(r.Context(), in.IDToken)
	if err != nil {
		auditLog(r, "oauth_google", "failure", "", "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	setRefreshCookie(w, h.cfg, refreshJTI)
	identifier := ""
	if resp.User.Email != "" {
		identifier = resp.User.Email
	}
	auditLog(r, "oauth_google", "success", identifier)
	httpx.JSON(w, http.StatusOK, resp)
}

func (h *Handler) ListIdentities(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	out, err := h.service.ListIdentities(r.Context(), uid)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"identities": out})
}

func (h *Handler) UnlinkIdentity(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	provider := chi.URLParam(r, "provider")
	dto, err := h.service.UnlinkIdentity(r.Context(), uid, provider)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"user": dto})
}

func (h *Handler) PatchProfile(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in PatchProfileRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	dto, err := h.service.UpdateProfile(r.Context(), uid, in)
	if err != nil {
		writeSvcErr(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, map[string]any{"user": dto})
}

func writeSvcErr(w http.ResponseWriter, err error) {
	httpx.WriteServiceError(w, err)
}
