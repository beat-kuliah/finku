CREATE TYPE transaction_kind AS ENUM ('income', 'expense', 'transfer');

CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    kind transaction_kind NOT NULL,
    wallet_id UUID NOT NULL REFERENCES wallets(id) ON DELETE RESTRICT,
    dest_wallet_id UUID REFERENCES wallets(id) ON DELETE RESTRICT,
    category_id UUID REFERENCES categories(id) ON DELETE RESTRICT,
    amount BIGINT NOT NULL CHECK (amount > 0),
    occurred_at DATE NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_transactions_user_occurred ON transactions (user_id, occurred_at DESC);
CREATE INDEX idx_transactions_wallet ON transactions (wallet_id);
