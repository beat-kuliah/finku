CREATE TABLE user_preferences (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    notify_budget_warning BOOLEAN NOT NULL DEFAULT true,
    notify_reminder BOOLEAN NOT NULL DEFAULT true,
    notify_weekly_report BOOLEAN NOT NULL DEFAULT false,
    theme VARCHAR(16) NOT NULL DEFAULT 'system',
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
