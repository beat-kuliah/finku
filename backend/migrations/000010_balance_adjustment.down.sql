ALTER TABLE transactions
  DROP CONSTRAINT IF EXISTS transactions_modified_direction_chk;

ALTER TABLE transactions
  DROP COLUMN IF EXISTS is_balance_increase;

-- PostgreSQL does not support removing an enum label; 'modified' remains on transaction_kind.
