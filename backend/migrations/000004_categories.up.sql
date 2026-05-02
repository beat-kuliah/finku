CREATE TYPE category_kind AS ENUM ('income', 'expense');

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(120) NOT NULL,
    icon VARCHAR(64),
    kind category_kind NOT NULL,
    archived_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_categories_user_name_active ON categories (user_id, LOWER(name))
    WHERE archived_at IS NULL;

CREATE INDEX idx_categories_user_kind ON categories (user_id, kind);
