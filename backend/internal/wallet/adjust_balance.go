package wallet

import (
	"context"
	"net/http"
	"strings"
	"time"

	"finku/backend/internal/db/sqlc"
	"finku/backend/internal/httpx"
	"finku/backend/internal/transaction"

	"github.com/google/uuid"
)

// AdjustBalanceInput is the service input for POST /wallets/{id}/adjust-balance.
type AdjustBalanceInput struct {
	NewBalance  int64
	RecordAs    string
	CategoryID  *uuid.UUID
	OccurredAt  time.Time
	Description *string
}

func validateAdjustRecordAs(delta int64, recordAs string) error {
	recordAs = strings.ToLower(strings.TrimSpace(recordAs))
	if delta > 0 {
		if recordAs != "income" && recordAs != "modified" {
			return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Kenaikan saldo: pilih income atau modified.")
		}
		return nil
	}
	if delta < 0 {
		if recordAs != "expense" && recordAs != "modified" {
			return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Penurunan saldo: pilih expense atau modified.")
		}
		return nil
	}
	return httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "recordAs tidak valid.")
}

func (s *Service) AdjustBalance(ctx context.Context, userID, walletID uuid.UUID, in AdjustBalanceInput) (map[string]any, error) {
	w, err := s.GetWallet(ctx, userID, walletID)
	if err != nil {
		return nil, err
	}
	if w.ArchivedAt != nil {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Dompet diarsipkan tidak bisa disesuaikan.")
	}

	delta := in.NewBalance - w.Balance
	if delta == 0 {
		return map[string]any{"wallet": walletDTO(w)}, nil
	}

	recordAs := strings.ToLower(strings.TrimSpace(in.RecordAs))
	if recordAs == "" {
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "recordAs wajib diisi.")
	}
	if err := validateAdjustRecordAs(delta, recordAs); err != nil {
		return nil, err
	}

	amount := delta
	if amount < 0 {
		amount = -amount
	}

	ci := transaction.CreateInput{
		WalletID:    walletID,
		Amount:      amount,
		OccurredAt:  in.OccurredAt,
		Description: in.Description,
	}

	switch recordAs {
	case "income":
		ci.Kind = "income"
		if in.CategoryID == nil || *in.CategoryID == uuid.Nil {
			return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Kategori wajib untuk income.")
		}
		ci.CategoryID = in.CategoryID
	case "expense":
		ci.Kind = "expense"
		if in.CategoryID == nil || *in.CategoryID == uuid.Nil {
			return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "Kategori wajib untuk expense.")
		}
		ci.CategoryID = in.CategoryID
	case "modified":
		ci.Kind = "modified"
		inc := delta > 0
		ci.IsBalanceIncrease = &inc
	default:
		return nil, httpx.SvcErr(http.StatusBadRequest, "VALIDATION", "recordAs harus income, expense, atau modified.")
	}

	pgTx, err := s.q.Pool().Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer pgTx.Rollback(ctx)

	tr, err := s.txSvc.CreateInTx(ctx, pgTx, userID, ci)
	if err != nil {
		return nil, err
	}
	if err := pgTx.Commit(ctx); err != nil {
		return nil, err
	}

	updated, err := s.q.GetWalletForUser(ctx, userID, walletID)
	if err != nil {
		updated = w
		updated.Balance = in.NewBalance
	}

	out := map[string]any{"wallet": walletDTO(updated)}
	row, err := s.q.GetTransactionRowForUser(ctx, userID, tr.ID)
	if err != nil {
		out["transaction"] = transaction.RowDTO(sqlc.TransactionRow{Transaction: tr})
	} else {
		out["transaction"] = transaction.RowDTO(row)
	}
	return out, nil
}
