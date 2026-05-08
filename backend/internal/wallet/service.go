package wallet

import (
	"context"
	"net/http"
	"strings"

	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/finance"
	"finku/backend/internal/httpx"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

type Service struct {
	q *sqlc.Queries
}

func NewService(q *sqlc.Queries) *Service { return &Service{q: q} }

func walletDTO(w sqlc.Wallet) map[string]any {
	m := map[string]any{
		"id":         w.ID.String(),
		"userId":     w.UserID.String(),
		"name":       w.Name,
		"walletType": w.WalletType,
		"balance":    w.Balance,
		"createdAt":  w.CreatedAt.UTC().Format(timeRFC),
		"updatedAt":  w.UpdatedAt.UTC().Format(timeRFC),
	}
	if w.GroupID != nil {
		m["groupId"] = w.GroupID.String()
	} else {
		m["groupId"] = nil
	}
	if w.Icon != nil {
		m["icon"] = *w.Icon
	}
	if w.ArchivedAt != nil {
		m["archivedAt"] = w.ArchivedAt.UTC().Format(timeRFC)
	}
	return m
}

const timeRFC = "2006-01-02T15:04:05.000Z07:00"

func (s *Service) GetWallet(ctx context.Context, userID, walletID uuid.UUID) (sqlc.Wallet, error) {
	w, err := s.q.GetWalletForUser(ctx, userID, walletID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return sqlc.Wallet{}, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Dompet tidak ditemukan.")
		}
		return sqlc.Wallet{}, err
	}
	return w, nil
}

func (s *Service) List(ctx context.Context, userID uuid.UUID, includeArchived bool) ([]map[string]any, error) {
	_ = finance.EnsureNewUserDefaults(ctx, s.q, userID)
	list, err := s.q.ListWalletsByUser(ctx, userID, includeArchived)
	if err != nil {
		return nil, err
	}
	out := make([]map[string]any, 0, len(list))
	for _, w := range list {
		out = append(out, walletDTO(w))
	}
	return out, nil
}

func (s *Service) ensureGroupOwned(ctx context.Context, userID uuid.UUID, groupID *uuid.UUID) error {
	if groupID == nil {
		return nil
	}
	if _, err := s.q.GetWalletGroupForUser(ctx, userID, *groupID); err != nil {
		if err == pgx.ErrNoRows {
			return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Grup tidak ditemukan.")
		}
		return err
	}
	return nil
}

func (s *Service) Create(ctx context.Context, userID uuid.UUID, name, walletType string, icon *string, groupID *uuid.UUID) (map[string]any, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama dompet wajib diisi.")
	}
	if walletType == "" {
		walletType = "cash"
	}
	if err := s.ensureGroupOwned(ctx, userID, groupID); err != nil {
		return nil, err
	}
	w, err := s.q.InsertWallet(ctx, userID, name, walletType, icon, groupID)
	if err != nil {
		return nil, err
	}
	return walletDTO(w), nil
}

func (s *Service) Update(ctx context.Context, userID, walletID uuid.UUID, name, walletType string, icon *string, groupID *uuid.UUID) (map[string]any, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama dompet wajib diisi.")
	}
	if walletType == "" {
		walletType = "cash"
	}
	if err := s.ensureGroupOwned(ctx, userID, groupID); err != nil {
		return nil, err
	}
	w, err := s.q.UpdateWallet(ctx, userID, walletID, name, walletType, icon, groupID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Dompet tidak ditemukan.")
		}
		return nil, err
	}
	return walletDTO(w), nil
}

func (s *Service) Archive(ctx context.Context, userID, walletID uuid.UUID) (map[string]any, error) {
	w, err := s.q.ArchiveWallet(ctx, userID, walletID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Dompet tidak ditemukan atau sudah diarsipkan.")
		}
		return nil, err
	}
	return walletDTO(w), nil
}
