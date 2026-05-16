package summary

import (
	"context"
	"time"

	"finku/backend/internal/db/sqlc"

	"github.com/google/uuid"
)

type Service struct{ q *sqlc.Queries }

func NewService(q *sqlc.Queries) *Service { return &Service{q: q} }

func (s *Service) Dashboard(ctx context.Context, userID uuid.UUID, from, to time.Time) (map[string]any, error) {
	totalBal, _ := s.q.TotalWalletBalance(ctx, userID)
	inc, exp, _ := s.q.SumIncomeExpenseInRange(ctx, userID, from, to)
	modBal, _ := s.q.SumModifiedInRange(ctx, userID, from, to)
	trend, _ := s.q.DailyTrend(ctx, userID, from, to)
	cats, _ := s.q.ExpenseByCategoryInRange(ctx, userID, from, to)
	budgets, _ := s.q.ListBudgetsWithSpent(ctx, userID, from, to)
	latest, _ := s.q.LatestTransactions(ctx, userID, 8)

	trendOut := make([]map[string]any, 0, len(trend))
	for _, d := range trend {
		trendOut = append(trendOut, map[string]any{
			"date":    d.Day.Format("2006-01-02"),
			"income":  d.Income,
			"expense": d.Expense,
		})
	}
	catOut := make([]map[string]any, 0, len(cats))
	for _, c := range cats {
		name := c.CategoryName
		if c.Archived {
			name = "Arsip: " + name
		}
		catOut = append(catOut, map[string]any{
			"categoryId": c.CategoryID.String(),
			"name":       name,
			"value":      c.Total,
			"archived":   c.Archived,
		})
	}
	budOut := make([]map[string]any, 0, len(budgets))
	for _, b := range budgets {
		budOut = append(budOut, map[string]any{
			"id":           b.ID.String(),
			"categoryId":   b.CategoryID.String(),
			"categoryName": b.CategoryName,
			"limitAmount":  b.LimitAmount,
			"spent":        b.Spent,
			"periodAnchor": b.PeriodAnchor.Format("2006-01-02"),
			"paused":       b.PausedAt != nil,
		})
	}
	txOut := make([]map[string]any, 0, len(latest))
	for _, t := range latest {
		txOut = append(txOut, map[string]any{
			"id":          t.ID.String(),
			"kind":        t.Kind,
			"amount":      t.Amount,
			"occurredAt":  t.OccurredAt.Format("2006-01-02"),
			"description": derefStr(t.Description),
			"category":    derefStr(t.CategoryName),
		})
	}

	return map[string]any{
		"totalBalance":          totalBal,
		"periodIncome":          inc,
		"periodExpense":         exp,
		"periodModifiedBalance": modBal,
		"periodFrom":            from.Format("2006-01-02"),
		"periodTo":              to.Format("2006-01-02"),
		"dailyTrend":     trendOut,
		"categoryBreakdown": catOut,
		"budgets":        budOut,
		"latestTransactions": txOut,
	}, nil
}

func derefStr(p *string) string {
	if p == nil {
		return ""
	}
	return *p
}

func (s *Service) Stats(ctx context.Context, userID uuid.UUID, from, to time.Time) (map[string]any, error) {
	cats, _ := s.q.ExpenseByCategoryInRange(ctx, userID, from, to)
	weeks, _ := s.q.WeeklyExpenseInRange(ctx, userID, from, to)
	inc, exp, _ := s.q.SumIncomeExpenseInRange(ctx, userID, from, to)
	modBal, _ := s.q.SumModifiedInRange(ctx, userID, from, to)

	catOut := make([]map[string]any, 0, len(cats))
	for _, c := range cats {
		name := c.CategoryName
		if c.Archived {
			name = "Arsip: " + name
		}
		catOut = append(catOut, map[string]any{
			"name":     name,
			"value":    c.Total,
			"archived": c.Archived,
		})
	}
	wOut := make([]map[string]any, 0, len(weeks))
	for _, w := range weeks {
		wOut = append(wOut, map[string]any{
			"week":  w.WeekStart.Format("2006-01-02"),
			"total": w.Total,
		})
	}
	return map[string]any{
		"periodFrom":            from.Format("2006-01-02"),
		"periodTo":              to.Format("2006-01-02"),
		"totalIncome":           inc,
		"totalExpense":          exp,
		"totalModifiedBalance":  modBal,
		"categoryBreakdown":   catOut,
		"weeklyExpense":       wOut,
	}, nil
}
