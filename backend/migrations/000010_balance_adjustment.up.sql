ALTER TYPE transaction_kind ADD VALUE IF NOT EXISTS 'modified';

ALTER TABLE transactions
  ADD COLUMN is_balance_increase BOOLEAN;

ALTER TABLE transactions
  ADD CONSTRAINT transactions_modified_direction_chk
  CHECK (
    (kind::text <> 'modified' AND is_balance_increase IS NULL)
    OR (kind::text = 'modified' AND is_balance_increase IS NOT NULL)
  );
