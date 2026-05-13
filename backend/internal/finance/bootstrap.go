package finance

import (
	"context"

	"finku/backend/internal/db/sqlc"

	"github.com/google/uuid"
)

// EnsureNewUserDefaults creates the default wallet and category template when missing (idempotent).
func EnsureNewUserDefaults(ctx context.Context, q *sqlc.Queries, userID uuid.UUID) error {
	nW, err := q.CountWalletsByUser(ctx, userID)
	if err != nil {
		return err
	}
	if nW == 0 {
		if _, err := q.InsertWallet(ctx, userID, "Dompet utama", "cash", nil, nil); err != nil {
			return err
		}
	}
	nC, err := q.CountCategoriesByUser(ctx, userID)
	if err != nil {
		return err
	}
	if nC == 0 {
		for _, d := range sqlc.DefaultCategoryTemplates() {
			icon := d.Icon
			if _, err := q.InsertCategory(ctx, userID, d.Name, d.Kind, &icon); err != nil {
				return err
			}
		}
	}
	return nil
}
