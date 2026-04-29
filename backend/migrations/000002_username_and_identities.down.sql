DROP INDEX IF EXISTS idx_user_identities_user;
DROP TABLE IF EXISTS user_identities;
DROP INDEX IF EXISTS idx_users_username_lower;
ALTER TABLE users DROP COLUMN IF EXISTS username;
-- Note: cannot fully restore NOT NULL on password_hash if any social-only users exist.
-- Restore for legacy rollback assumes no NULL password_hash rows remain.
ALTER TABLE users ALTER COLUMN password_hash SET NOT NULL;
