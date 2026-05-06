package preferences

import (
	"context"
	"net/http"

	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/httpx"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
)

type Service struct{ q *sqlc.Queries }

func NewService(q *sqlc.Queries) *Service { return &Service{q: q} }

const timeRFC = "2006-01-02T15:04:05.000Z07:00"

func prefsDTO(p sqlc.UserPreferences) map[string]any {
	return map[string]any{
		"notifyBudgetWarning": p.NotifyBudgetWarning,
		"notifyReminder":      p.NotifyReminder,
		"notifyWeeklyReport":  p.NotifyWeeklyReport,
		"theme":               p.Theme,
		"updatedAt":           p.UpdatedAt.UTC().Format(timeRFC),
	}
}

func (s *Service) Get(ctx context.Context, userID uuid.UUID) (map[string]any, error) {
	p, err := s.q.GetUserPreferences(ctx, userID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return map[string]any{
				"notifyBudgetWarning": true,
				"notifyReminder":      true,
				"notifyWeeklyReport":  false,
				"theme":               "system",
			}, nil
		}
		return nil, err
	}
	return prefsDTO(p), nil
}

func (s *Service) Patch(ctx context.Context, userID uuid.UUID, nb, nr, nw *bool, theme *string) (map[string]any, error) {
	cur, err := s.q.GetUserPreferences(ctx, userID)
	if err != nil && err != pgx.ErrNoRows {
		return nil, err
	}
	a, b, c, th := true, true, false, "system"
	if err == nil {
		a, b, c, th = cur.NotifyBudgetWarning, cur.NotifyReminder, cur.NotifyWeeklyReport, cur.Theme
	}
	if nb != nil {
		a = *nb
	}
	if nr != nil {
		b = *nr
	}
	if nw != nil {
		c = *nw
	}
	if theme != nil && *theme != "" {
		th = *theme
	}
	if th != "system" && th != "light" && th != "dark" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "theme harus system, light, atau dark.")
	}
	p, err := s.q.UpsertUserPreferences(ctx, userID, a, b, c, th)
	if err != nil {
		return nil, err
	}
	return prefsDTO(p), nil
}
