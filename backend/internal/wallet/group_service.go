package wallet

import (
	"context"
	"errors"
	"net/http"
	"strings"

	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/finance"
	"finku/backend/internal/httpx"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

func groupDTO(g sqlc.WalletGroup, walletCount, totalBalance int64) map[string]any {
	m := map[string]any{
		"id":           g.ID.String(),
		"userId":       g.UserID.String(),
		"name":         g.Name,
		"walletCount":  walletCount,
		"totalBalance": totalBalance,
		"createdAt":    g.CreatedAt.UTC().Format(timeRFC),
		"updatedAt":    g.UpdatedAt.UTC().Format(timeRFC),
	}
	if g.Icon != nil {
		m["icon"] = *g.Icon
	}
	return m
}

func (s *Service) ListGroups(ctx context.Context, userID uuid.UUID) ([]map[string]any, error) {
	_ = finance.EnsureNewUserDefaults(ctx, s.q, userID)
	list, err := s.q.ListWalletGroupsWithStats(ctx, userID)
	if err != nil {
		return nil, err
	}
	out := make([]map[string]any, 0, len(list))
	for _, row := range list {
		out = append(out, groupDTO(row.WalletGroup, row.WalletCount, row.TotalBalance))
	}
	return out, nil
}

func (s *Service) CreateGroup(ctx context.Context, userID uuid.UUID, name string, icon *string) (map[string]any, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama grup wajib diisi.")
	}
	g, err := s.q.InsertWalletGroup(ctx, userID, name, icon)
	if err != nil {
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return nil, httpx.SvcErr(http.StatusConflict, "DUPLICATE", "Nama grup sudah dipakai.")
		}
		return nil, err
	}
	return groupDTO(g, 0, 0), nil
}

func (s *Service) UpdateGroup(ctx context.Context, userID, groupID uuid.UUID, name string, icon *string) (map[string]any, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama grup wajib diisi.")
	}
	g, err := s.q.UpdateWalletGroup(ctx, userID, groupID, name, icon)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Grup tidak ditemukan.")
		}
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return nil, httpx.SvcErr(http.StatusConflict, "DUPLICATE", "Nama grup sudah dipakai.")
		}
		return nil, err
	}
	stats, err := s.q.ListWalletGroupsWithStats(ctx, userID)
	if err != nil {
		return nil, err
	}
	var wc, tb int64
	for _, row := range stats {
		if row.ID == g.ID {
			wc = row.WalletCount
			tb = row.TotalBalance
			break
		}
	}
	return groupDTO(g, wc, tb), nil
}

func (s *Service) DeleteGroup(ctx context.Context, userID, groupID uuid.UUID) error {
	if err := s.q.DeleteWalletGroup(ctx, userID, groupID); err != nil {
		if err == pgx.ErrNoRows {
			return httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Grup tidak ditemukan.")
		}
		return err
	}
	return nil
}
