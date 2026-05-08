DROP INDEX IF EXISTS idx_wallets_group_id;
ALTER TABLE wallets DROP COLUMN IF EXISTS group_id;
DROP INDEX IF EXISTS idx_wallet_groups_user_name;
DROP INDEX IF EXISTS idx_wallet_groups_user_id;
DROP TABLE IF EXISTS wallet_groups;
