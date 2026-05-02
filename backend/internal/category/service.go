package category

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

type Service struct{ q *sqlc.Queries }

func NewService(q *sqlc.Queries) *Service { return &Service{q: q} }

const timeRFC = "2006-01-02T15:04:05.000Z07:00"

func catDTO(c sqlc.Category) map[string]any {
	m := map[string]any{
		"id":        c.ID.String(),
		"userId":    c.UserID.String(),
		"name":      c.Name,
		"kind":      c.Kind,
		"createdAt": c.CreatedAt.UTC().Format(timeRFC),
		"updatedAt": c.UpdatedAt.UTC().Format(timeRFC),
	}
	if c.Icon != nil {
		m["icon"] = *c.Icon
	}
	if c.ArchivedAt != nil {
		m["archivedAt"] = c.ArchivedAt.UTC().Format(timeRFC)
	}
	return m
}

func (s *Service) List(ctx context.Context, userID uuid.UUID, archived *bool) ([]map[string]any, error) {
	_ = finance.EnsureNewUserDefaults(ctx, s.q, userID)
	list, err := s.q.ListCategoriesByUser(ctx, userID, archived)
	if err != nil {
		return nil, err
	}
	out := make([]map[string]any, 0, len(list))
	for _, c := range list {
		out = append(out, catDTO(c))
	}
	return out, nil
}

func (s *Service) Create(ctx context.Context, userID uuid.UUID, name, kind string, icon *string) (map[string]any, error) {
	name = strings.TrimSpace(name)
	kind = strings.ToLower(strings.TrimSpace(kind))
	if name == "" || (kind != "income" && kind != "expense") {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama dan kind (income|expense) wajib valid.")
	}
	c, err := s.q.InsertCategory(ctx, userID, name, kind, icon)
	if err != nil {
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return nil, httpx.SvcErr(http.StatusConflict, "DUPLICATE", "Nama kategori aktif sudah dipakai.")
		}
		return nil, err
	}
	return catDTO(c), nil
}

func (s *Service) Update(ctx context.Context, userID, id uuid.UUID, name string, icon *string) (map[string]any, error) {
	name = strings.TrimSpace(name)
	if name == "" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama wajib diisi.")
	}
	c, err := s.q.UpdateCategory(ctx, userID, id, name, icon)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Kategori tidak ditemukan atau sudah diarsipkan.")
		}
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return nil, httpx.SvcErr(http.StatusConflict, "DUPLICATE", "Nama kategori aktif sudah dipakai.")
		}
		return nil, err
	}
	return catDTO(c), nil
}

func (s *Service) Archive(ctx context.Context, userID, id uuid.UUID) (map[string]any, error) {
	c, err := s.q.ArchiveCategory(ctx, userID, id)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Kategori tidak ditemukan atau sudah diarsipkan.")
		}
		return nil, err
	}
	_ = s.q.PauseBudgetsForCategory(ctx, userID, id)
	return catDTO(c), nil
}

func (s *Service) Unarchive(ctx context.Context, userID, id uuid.UUID) (map[string]any, error) {
	c, err := s.q.UnarchiveCategory(ctx, userID, id)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Kategori tidak ditemukan atau tidak diarsipkan.")
		}
		return nil, err
	}
	_ = s.q.UnpauseBudgetsForCategory(ctx, userID, id)
	return catDTO(c), nil
}
