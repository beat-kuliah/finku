package transaction

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

func txRowDTO(tr sqlc.TransactionRow) map[string]any {
	m := map[string]any{
		"id":         tr.ID.String(),
		"userId":     tr.UserID.String(),
		"kind":       tr.Kind,
		"walletId":   tr.WalletID.String(),
		"amount":     tr.Amount,
		"occurredAt": tr.OccurredAt.Format("2006-01-02"),
		"createdAt":  tr.CreatedAt.UTC().Format(timeRFC),
		"updatedAt":  tr.UpdatedAt.UTC().Format(timeRFC),
	}
	if tr.DestWalletID != nil {
		m["destWalletId"] = tr.DestWalletID.String()
	}
	if tr.CategoryID != nil {
		m["categoryId"] = tr.CategoryID.String()
	}
	if tr.Description != nil {
		m["description"] = *tr.Description
	}
	if tr.CategoryName != nil {
		m["categoryName"] = *tr.CategoryName
	}
	return m
}

type CreateInput struct {
	Kind         string
	WalletID     uuid.UUID
	DestWalletID *uuid.UUID
	CategoryID   *uuid.UUID
	Amount       int64
	OccurredAt   time.Time
	Description  *string
}

func reverseEffect(ctx context.Context, tx pgx.Tx, t sqlc.Transaction) error {
	switch t.Kind {
	case "income":
		_, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance - $2, updated_at = NOW() WHERE id = $1`, t.WalletID, t.Amount)
		return err
	case "expense":
		_, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE id = $1`, t.WalletID, t.Amount)
		return err
	case "transfer":
		if t.DestWalletID == nil {
			return httpx.SvcErr(http.StatusInternalServerError, "DATA", "Transfer corrupt.")
		}
		if _, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE id = $1`, t.WalletID, t.Amount); err != nil {
			return err
		}
		_, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance - $2, updated_at = NOW() WHERE id = $1`, *t.DestWalletID, t.Amount)
		return err
	default:
		return nil
	}
}

func applyEffect(ctx context.Context, tx pgx.Tx, t sqlc.Transaction) error {
	switch t.Kind {
	case "income":
		_, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE id = $1`, t.WalletID, t.Amount)
		return err
	case "expense":
		_, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance - $2, updated_at = NOW() WHERE id = $1`, t.WalletID, t.Amount)
		return err
	case "transfer":
		if t.DestWalletID == nil {
			return httpx.SvcErr(http.StatusInternalServerError, "DATA", "Transfer corrupt.")
		}
		if _, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance - $2, updated_at = NOW() WHERE id = $1`, t.WalletID, t.Amount); err != nil {
			return err
		}
		_, err := tx.Exec(ctx, `UPDATE wallets SET balance = balance + $2, updated_at = NOW() WHERE id = $1`, *t.DestWalletID, t.Amount)
		return err
	default:
		return nil
	}
}

func (s *Service) validateCreate(ctx context.Context, userID uuid.UUID, in CreateInput) error {
	in.Kind = strings.ToLower(strings.TrimSpace(in.Kind))
	if in.Kind != "income" && in.Kind != "expense" && in.Kind != "transfer" {
		return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Kind harus income, expense, atau transfer.")
	}
	if in.Amount <= 0 {
		return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Jumlah harus lebih dari 0.")
	}
	if in.Kind == "transfer" {
		if in.DestWalletID == nil || *in.DestWalletID == uuid.Nil {
			return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Transfer membutuhkan dompet tujuan.")
		}
		if in.CategoryID != nil {
			return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Transfer tidak memakai kategori.")
		}
		if *in.DestWalletID == in.WalletID {
			return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Dompet sumber dan tujuan harus berbeda.")
		}
		if _, err := s.q.GetWalletForUser(ctx, userID, in.WalletID); err != nil {
			if err == pgx.ErrNoRows {
				return httpx.SvcErr(http.StatusBadRequest, "WALLET", "Dompet sumber tidak valid.")
			}
			return err
		}
		if _, err := s.q.GetWalletForUser(ctx, userID, *in.DestWalletID); err != nil {
			if err == pgx.ErrNoRows {
				return httpx.SvcErr(http.StatusBadRequest, "WALLET", "Dompet tujuan tidak valid.")
			}
			return err
		}
		return nil
	}
	if in.DestWalletID != nil {
		return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "destWalletId hanya untuk transfer.")
	}
	if in.CategoryID == nil || *in.CategoryID == uuid.Nil {
		return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Pemasukan/pengeluaran wajib punya kategori.")
	}
	cat, err := s.q.GetCategoryForUser(ctx, userID, *in.CategoryID)
	if err != nil {
		if err == pgx.ErrNoRows {
			return httpx.SvcErr(http.StatusBadRequest, "CATEGORY", "Kategori tidak ditemukan.")
		}
		return err
	}
	if cat.ArchivedAt != nil {
		return httpx.SvcErr(http.StatusBadRequest, "CATEGORY", "Kategori diarsipkan tidak bisa dipakai untuk transaksi baru.")
	}
	if (in.Kind == "income" && cat.Kind != "income") || (in.Kind == "expense" && cat.Kind != "expense") {
		return httpx.SvcErr(http.StatusBadRequest, "CATEGORY", "Kind kategori tidak cocok dengan transaksi.")
	}
	if _, err := s.q.GetWalletForUser(ctx, userID, in.WalletID); err != nil {
		if err == pgx.ErrNoRows {
			return httpx.SvcErr(http.StatusBadRequest, "WALLET", "Dompet tidak valid.")
		}
		return err
	}
	return nil
}

func (s *Service) Create(ctx context.Context, userID uuid.UUID, in CreateInput) (map[string]any, error) {
	if err := s.validateCreate(ctx, userID, in); err != nil {
		return nil, err
	}
	var dest *uuid.UUID
	if in.DestWalletID != nil && *in.DestWalletID != uuid.Nil {
		dest = in.DestWalletID
	}

	tx, err := s.q.Pool().Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback(ctx)

	var tr sqlc.Transaction
	err = tx.QueryRow(ctx, `
INSERT INTO transactions (user_id, kind, wallet_id, dest_wallet_id, category_id, amount, occurred_at, description)
VALUES ($1, $2::transaction_kind, $3, $4, $5, $6, $7, $8)
RETURNING id, user_id, kind, wallet_id, dest_wallet_id, category_id, amount, occurred_at, description, created_at, updated_at`,
		userID, in.Kind, in.WalletID, dest, in.CategoryID, in.Amount, in.OccurredAt, in.Description,
	).Scan(&tr.ID, &tr.UserID, &tr.Kind, &tr.WalletID, &tr.DestWalletID, &tr.CategoryID, &tr.Amount, &tr.OccurredAt, &tr.Description, &tr.CreatedAt, &tr.UpdatedAt)
	if err != nil {
		return nil, err
	}
	if err := applyEffect(ctx, tx, tr); err != nil {
		return nil, err
	}
	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}
	row, err := s.q.GetTransactionRowForUser(ctx, userID, tr.ID)
	if err != nil {
		return txRowDTO(sqlc.TransactionRow{Transaction: tr}), nil
	}
	return txRowDTO(row), nil
}

func (s *Service) List(ctx context.Context, p sqlc.ListTransactionsParams) ([]map[string]any, error) {
	rows, err := s.q.ListTransactions(ctx, p)
	if err != nil {
		return nil, err
	}
	out := make([]map[string]any, 0, len(rows))
	for _, r := range rows {
		out = append(out, txRowDTO(r))
	}
	return out, nil
}

func (s *Service) Delete(ctx context.Context, userID, id uuid.UUID) error {
	t, err := s.q.GetTransactionForUser(ctx, userID, id)
	if err != nil {
		if err == pgx.ErrNoRows {
			return httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Transaksi tidak ditemukan.")
		}
		return err
	}
	tx, err := s.q.Pool().Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)
	if err := reverseEffect(ctx, tx, t); err != nil {
		return err
	}
	tag, err := tx.Exec(ctx, `DELETE FROM transactions WHERE id = $1 AND user_id = $2`, id, userID)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Transaksi tidak ditemukan.")
	}
	return tx.Commit(ctx)
}

type UpdateInput struct {
	Kind         string
	WalletID     uuid.UUID
	DestWalletID *uuid.UUID
	CategoryID   *uuid.UUID
	Amount       int64
	OccurredAt   time.Time
	Description  *string
}

func (s *Service) Update(ctx context.Context, userID, id uuid.UUID, in UpdateInput) (map[string]any, error) {
	ci := CreateInput{
		Kind: in.Kind, WalletID: in.WalletID, DestWalletID: in.DestWalletID,
		CategoryID: in.CategoryID, Amount: in.Amount, OccurredAt: in.OccurredAt, Description: in.Description,
	}
	if err := s.validateCreate(ctx, userID, ci); err != nil {
		return nil, err
	}
	old, err := s.q.GetTransactionForUser(ctx, userID, id)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Transaksi tidak ditemukan.")
		}
		return nil, err
	}
	var dest *uuid.UUID
	if in.DestWalletID != nil && *in.DestWalletID != uuid.Nil {
		dest = in.DestWalletID
	}

	tx, err := s.q.Pool().Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback(ctx)
	if err := reverseEffect(ctx, tx, old); err != nil {
		return nil, err
	}
	var tr sqlc.Transaction
	err = tx.QueryRow(ctx, `
UPDATE transactions SET
  kind = $3::transaction_kind,
  wallet_id = $4,
  dest_wallet_id = $5,
  category_id = $6,
  amount = $7,
  occurred_at = $8,
  description = $9,
  updated_at = NOW()
WHERE id = $2 AND user_id = $1
RETURNING id, user_id, kind, wallet_id, dest_wallet_id, category_id, amount, occurred_at, description, created_at, updated_at`,
		userID, id, in.Kind, in.WalletID, dest, in.CategoryID, in.Amount, in.OccurredAt, in.Description,
	).Scan(&tr.ID, &tr.UserID, &tr.Kind, &tr.WalletID, &tr.DestWalletID, &tr.CategoryID, &tr.Amount, &tr.OccurredAt, &tr.Description, &tr.CreatedAt, &tr.UpdatedAt)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, httpx.SvcErr(http.StatusNotFound, "NOT_FOUND", "Transaksi tidak ditemukan.")
		}
		return nil, err
	}
	if err := applyEffect(ctx, tx, tr); err != nil {
		return nil, err
	}
	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}
	row, err := s.q.GetTransactionRowForUser(ctx, userID, id)
	if err != nil {
		return txRowDTO(sqlc.TransactionRow{Transaction: tr}), nil
	}
	return txRowDTO(row), nil
}
