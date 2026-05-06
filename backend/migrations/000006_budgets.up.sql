CREATE TYPE budget_period AS ENUM ('monthly');

CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    period budget_period NOT NULL DEFAULT 'monthly',
    period_anchor DATE NOT NULL,
    limit_amount BIGINT NOT NULL CHECK (limit_amount >= 0),
    paused_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, category_id, period_anchor)
);

CREATE INDEX idx_budgets_user_anchor ON budgets (user_id, period_anchor);
