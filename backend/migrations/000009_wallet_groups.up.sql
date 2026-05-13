CREATE TABLE wallet_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(120) NOT NULL,
    icon VARCHAR(64),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_wallet_groups_user_id ON wallet_groups (user_id);
CREATE UNIQUE INDEX idx_wallet_groups_user_name ON wallet_groups (user_id, LOWER(name));

ALTER TABLE wallets ADD COLUMN group_id UUID REFERENCES wallet_groups(id) ON DELETE SET NULL;
CREATE INDEX idx_wallets_group_id ON wallets (group_id);
