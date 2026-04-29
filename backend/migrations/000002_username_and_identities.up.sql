ALTER TABLE users ADD COLUMN username VARCHAR(32) UNIQUE;
ALTER TABLE users ALTER COLUMN password_hash DROP NOT NULL;
CREATE UNIQUE INDEX idx_users_username_lower ON users (LOWER(username)) WHERE username IS NOT NULL;

CREATE TABLE user_identities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    provider VARCHAR(20) NOT NULL,
    provider_user_id VARCHAR(255),
    email VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (provider, provider_user_id)
);
CREATE INDEX idx_user_identities_user ON user_identities(user_id);

INSERT INTO user_identities (user_id, provider, email)
SELECT id, 'password', email FROM users WHERE password_hash IS NOT NULL;
