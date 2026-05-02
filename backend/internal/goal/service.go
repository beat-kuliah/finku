package goal

import (
	"context"
	"net/http"
	"strings"
	"time"

	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/httpx"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

type Service struct{ q *sqlc.Queries }

func NewService(q *sqlc.Queries) *Service { return &Service{q: q} }

const timeRFC = "2006-01-02T15:04:05.000Z07:00"

func goalDTO(g sqlc.Goal) map[string]any {
	m := map[string]any{
		"id":            g.ID.String(),
		"userId":        g.UserID.String(),
		"name":          g.Name,
		"targetAmount":  g.TargetAmount,
		"currentAmount": g.CurrentAmount,
		"createdAt":     g.CreatedAt.UTC().Format(timeRFC),
		"updatedAt":     g.UpdatedAt.UTC().Format(timeRFC),
	}
	if g.Deadline != nil {
		m["deadline"] = g.Deadline.Format("2006-01-02")
	}
	if g.TargetAmount > 0 {
		m["progressPct"] = float64(g.CurrentAmount) / float64(g.TargetAmount) * 100
	}
	return m
}

func (s *Service) List(ctx context.Context, userID uuid.UUID) ([]map[string]any, error) {
	list, err := s.q.ListGoalsByUser(ctx, userID)
	if err != nil {
		return nil, err
	}
	out := make([]map[string]any, 0, len(list))
	for _, g := range list {
		out = append(out, goalDTO(g))
	}
	return out, nil
}

func (s *Service) Create(ctx context.Context, userID uuid.UUID, name string, target int64, deadline *time.Time) (map[string]any, error) {
	name = strings.TrimSpace(name)
	if name == "" || target <= 0 {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama dan target wajib valid.")
	}
	g, err := s.q.InsertGoal(ctx, userID, name, target, deadline)
	if err != nil {
		return nil, err
	}
	return goalDTO(g), nil
}

func (s *Service) Update(ctx context.Context, userID, id uuid.UUID, name string, target int64, deadline *time.Time) (map[string]any, error) {
	name = strings.TrimSpace(name)
	if name == "" || target <= 0 {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Nama dan target wajib valid.")
	}
	g, err := s.q.UpdateGoal(ctx, userID, id, name, target, deadline)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Goal tidak ditemukan.")
		}
		return nil, err
	}
	return goalDTO(g), nil
}

func (s *Service) Contribute(ctx context.Context, userID, id uuid.UUID, delta int64) (map[string]any, error) {
	if delta == 0 {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Jumlah tidak boleh 0.")
	}
	g, err := s.q.ContributeGoal(ctx, userID, id, delta)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Goal tidak ditemukan.")
		}
		return nil, err
	}
	return goalDTO(g), nil
}

func (s *Service) Delete(ctx context.Context, userID, id uuid.UUID) error {
	n, err := s.q.DeleteGoal(ctx, userID, id)
	if err != nil {
		return err
	}
	if n == 0 {
		return httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Goal tidak ditemukan.")
	}
	return nil
}
