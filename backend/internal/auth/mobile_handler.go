package auth

import (
	"encoding/json"
	"net/http"
	"strings"

	"finku/backend/internal/httpx"
	"finku/backend/internal/middleware"
)

func (h *Handler) MobileRegister(w http.ResponseWriter, r *http.Request) {
	var in RegisterRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	resp, refreshJTI, err := h.service.Register(r.Context(), in)
	if err != nil {
		auditLog(r, "mobile_register", "failure", in.Email, "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	auditLog(r, "mobile_register", "success", in.Email)
	httpx.JSON(w, http.StatusCreated, MobileAuthResponse{
		User:         resp.User,
		AccessToken:  resp.AccessToken,
		RefreshToken: refreshJTI,
	})
}

func (h *Handler) MobileLogin(w http.ResponseWriter, r *http.Request) {
	var in LoginRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	resp, refreshJTI, err := h.service.Login(r.Context(), in)
	if err != nil {
		auditLog(r, "mobile_login", "failure", in.Identifier, "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	auditLog(r, "mobile_login", "success", in.Identifier)
	httpx.JSON(w, http.StatusOK, MobileAuthResponse{
		User:         resp.User,
		AccessToken:  resp.AccessToken,
		RefreshToken: refreshJTI,
	})
}

func (h *Handler) MobileOAuthGoogle(w http.ResponseWriter, r *http.Request) {
	var in OAuthRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	resp, refreshJTI, err := h.service.LoginWithGoogle(r.Context(), in.IDToken)
	if err != nil {
		auditLog(r, "mobile_oauth_google", "failure", "", "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	identifier := ""
	if resp.User.Email != "" {
		identifier = resp.User.Email
	}
	auditLog(r, "mobile_oauth_google", "success", identifier)
	httpx.JSON(w, http.StatusOK, MobileAuthResponse{
		User:         resp.User,
		AccessToken:  resp.AccessToken,
		RefreshToken: refreshJTI,
	})
}

func (h *Handler) MobileRefresh(w http.ResponseWriter, r *http.Request) {
	var in MobileRefreshRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	in.RefreshToken = strings.TrimSpace(in.RefreshToken)
	resp, newJTI, err := h.service.Refresh(r.Context(), in.RefreshToken)
	if err != nil {
		auditLog(r, "mobile_refresh", "failure", "", "reason", err.Error())
		writeSvcErr(w, err)
		return
	}
	httpx.JSON(w, http.StatusOK, MobileRefreshResponse{
		AccessToken:  resp.AccessToken,
		RefreshToken: newJTI,
	})
}

func (h *Handler) MobileLogout(w http.ResponseWriter, r *http.Request) {
	uid, ok := middleware.UserID(r.Context())
	if !ok {
		httpx.Error(w, http.StatusUnauthorized, "UNAUTHORIZED", "Unauthorized.")
		return
	}
	var in MobileRefreshRequest
	if err := json.NewDecoder(r.Body).Decode(&in); err != nil {
		httpx.Error(w, http.StatusBadRequest, "BAD_JSON", "Invalid JSON body.")
		return
	}
	in.RefreshToken = strings.TrimSpace(in.RefreshToken)
	jti, _ := middleware.AccessJTI(r.Context())
	exp, _ := middleware.AccessExp(r.Context())
	if err := h.service.Logout(r.Context(), uid, jti, exp, in.RefreshToken); err != nil {
		auditLog(r, "mobile_logout", "failure", "", "user_id", uid.String(), "reason", err.Error())
		httpx.Error(w, http.StatusInternalServerError, "INTERNAL", "Something went wrong.")
		return
	}
	auditLog(r, "mobile_logout", "success", "", "user_id", uid.String())
	w.WriteHeader(http.StatusNoContent)
}
