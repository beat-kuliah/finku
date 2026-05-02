package budget

import (
	"context"
	"errors"
	"net/http"
	"time"

	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/httpx"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
)

type Service struct{ q *sqlc.Queries }

func NewService(q *sqlc.Queries) *Service { return &Service{q: q} }

const timeRFC = "2006-01-02T15:04:05.000Z07:00"

func budgetDTO(b sqlc.BudgetWithSpent) map[string]any {
	m := map[string]any{
		"id":           b.ID.String(),
		"userId":       b.UserID.String(),
		"categoryId":   b.CategoryID.String(),
		"categoryName": b.CategoryName,
		"period":       b.Period,
		"periodAnchor": b.PeriodAnchor.Format("2006-01-02"),
		"limitAmount":  b.LimitAmount,
		"spent":        b.Spent,
		"createdAt":    b.CreatedAt.UTC().Format(timeRFC),
		"updatedAt":    b.UpdatedAt.UTC().Format(timeRFC),
		"paused":       b.PausedAt != nil,
	}
	if b.PausedAt != nil {
		m["pausedAt"] = b.PausedAt.UTC().Format(timeRFC)
	}
	return m
}

func (s *Service) List(ctx context.Context, userID uuid.UUID, from, to time.Time) ([]map[string]any, error) {
	list, err := s.q.ListBudgetsWithSpent(ctx, userID, from, to)
	if err != nil {
		return nil, err
	}
	out := make([]map[string]any, 0, len(list))
	for _, b := range list {
		out = append(out, budgetDTO(b))
	}
	return out, nil
}

func (s *Service) Create(ctx context.Context, userID, categoryID uuid.UUID, period string, periodAnchor time.Time, limit int64) (map[string]any, error) {
	if limit < 0 {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Limit tidak valid.")
	}
	cat, err := s.q.GetCategoryForUser(ctx, userID, categoryID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusBadRequest, "CATEGORY", "Kategori tidak ditemukan.")
		}
		return nil, err
	}
	if cat.Kind != "expense" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "CATEGORY", "Budget hanya untuk kategori pengeluaran.")
	}
	if period == "" {
		period = "monthly"
	}
	b, err := s.q.InsertBudget(ctx, userID, categoryID, period, periodAnchor, limit)
	if err != nil {
		var pe *pgconn.PgError
		if errors.As(err, &pe) && pe.Code == "23505" {
			return nil, httpx.SvcErr(http.StatusConflict, "DUPLICATE", "Budget untuk kategori & periode ini sudah ada.")
		}
		return nil, err
	}
	start := time.Date(periodAnchor.Year(), periodAnchor.Month(), 1, 0, 0, 0, 0, time.UTC)
	end := start.AddDate(0, 1, 0).Add(-time.Nanosecond)
	spent, err := s.q.SpentForCategoryInRange(ctx, userID, categoryID, start, end)
	if err != nil {
		spent = 0
	}
	return budgetDTO(sqlc.BudgetWithSpent{Budget: b, Spent: spent, CategoryName: cat.Name}), nil
}

func (s *Service) Update(ctx context.Context, userID, budgetID uuid.UUID, limit int64) (map[string]any, error) {
	if limit < 0 {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Limit tidak valid.")
	}
	b, err := s.q.UpdateBudget(ctx, userID, budgetID, limit)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Budget tidak ditemukan.")
		}
		return nil, err
	}
	monthEnd := b.PeriodAnchor.AddDate(0, 1, 0).Add(-time.Nanosecond)
	spent, _ := s.q.SpentForCategoryInRange(ctx, userID, b.CategoryID, b.PeriodAnchor, monthEnd)
	cat, err := s.q.GetCategoryForUser(ctx, userID, b.CategoryID)
	name := ""
	if err == nil {
		name = cat.Name
	}
	return budgetDTO(sqlc.BudgetWithSpent{Budget: b, Spent: spent, CategoryName: name}), nil
}

func (s *Service) Delete(ctx context.Context, userID, budgetID uuid.UUID) error {
	n, err := s.q.DeleteBudget(ctx, userID, budgetID)
	if err != nil {
		return err
	}
	if n == 0 {
		return httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Budget tidak ditemukan.")
	}
	return nil
}
