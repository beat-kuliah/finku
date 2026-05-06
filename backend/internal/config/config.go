package config

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/alexedwards/argon2id"
	"github.com/joho/godotenv"
)

// Environment names accepted by APP_ENV. Anything else fails fast at startup so
// a typo never silently downgrades production-only protections (e.g. HSTS).
const (
	EnvDevelopment = "development"
	EnvProduction  = "production"
)

type Config struct {
	Port               string
	AppEnv             string
	CORSOrigins        []string
	DatabaseURL        string
	DBMaxConns         int32
	DBMinConns         int32
	RedisURL           string
	RedisUsername      string
	RedisPassword      string
	RedisPoolSize      int
	JWTSecret          []byte
	AccessTokenTTL     time.Duration
	RefreshTokenTTL    time.Duration
	Argon2Params       argon2id.Params
	AuthRateLimitMax   int
	AuthRateLimitWin   time.Duration
	GlobalRateLimitMax int
	GlobalRateLimitWin time.Duration
	LockoutMax         int
	LockoutWindow      time.Duration
	UserCacheTTL       time.Duration
	CookieSecure       bool
	CookieDomain       string
	RefreshCookieName  string
	GoogleClientID     string
}

func Load() (*Config, error) {
	_ = godotenv.Load()

	appEnv := strings.ToLower(strings.TrimSpace(getEnv("APP_ENV", EnvDevelopment)))
	if appEnv != EnvDevelopment && appEnv != EnvProduction {
		return nil, fmt.Errorf("APP_ENV must be %q or %q, got %q", EnvDevelopment, EnvProduction, appEnv)
	}

	origins := parseCSV(getEnv("CORS_ORIGIN", "http://localhost:5173"))
	if len(origins) == 0 {
		return nil, fmt.Errorf("CORS_ORIGIN must list at least one origin")
	}

	c := &Config{
		Port:               getEnv("PORT", "8080"),
		AppEnv:             appEnv,
		CORSOrigins:        origins,
		DatabaseURL:        os.Getenv("DATABASE_URL"),
		DBMaxConns:         int32(mustParseInt(getEnv("DB_MAX_CONNS", "20"), 20)),
		DBMinConns:         int32(mustParseInt(getEnv("DB_MIN_CONNS", "2"), 2)),
		RedisURL:           os.Getenv("REDIS_URL"),
		RedisUsername:      os.Getenv("REDIS_USERNAME"),
		RedisPassword:      os.Getenv("REDIS_PASSWORD"),
		RedisPoolSize:      mustParseInt(getEnv("REDIS_POOL_SIZE", "20"), 20),
		AccessTokenTTL:     mustParseDur(getEnv("ACCESS_TOKEN_TTL", "15m"), 15*time.Minute),
		RefreshTokenTTL:    mustParseDur(getEnv("REFRESH_TOKEN_TTL", "168h"), 168*time.Hour),
		AuthRateLimitMax:   mustParseInt(getEnv("AUTH_RATE_LIMIT_REQUESTS", "5"), 5),
		AuthRateLimitWin:   mustParseDur(getEnv("AUTH_RATE_LIMIT_WINDOW", "1m"), time.Minute),
		GlobalRateLimitMax: mustParseInt(getEnv("GLOBAL_RATE_LIMIT_REQUESTS", "120"), 120),
		GlobalRateLimitWin: mustParseDur(getEnv("GLOBAL_RATE_LIMIT_WINDOW", "1m"), time.Minute),
		LockoutMax:         mustParseInt(getEnv("LOCKOUT_MAX_ATTEMPTS", "5"), 5),
		LockoutWindow:      mustParseDur(getEnv("LOCKOUT_WINDOW", "15m"), 15*time.Minute),
		UserCacheTTL:       mustParseDur(getEnv("USER_CACHE_TTL", "5m"), 5*time.Minute),
		CookieSecure:       strings.EqualFold(getEnv("COOKIE_SECURE", "false"), "true"),
		CookieDomain:       os.Getenv("COOKIE_DOMAIN"),
		RefreshCookieName:  getEnv("REFRESH_COOKIE_NAME", "refresh_token"),
		GoogleClientID:     os.Getenv("GOOGLE_CLIENT_ID"),
	}

	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		return nil, fmt.Errorf("JWT_SECRET is required")
	}
	if len(secret) < 32 {
		return nil, fmt.Errorf("JWT_SECRET must be at least 32 bytes")
	}
	c.JWTSecret = []byte(secret)

	if c.DatabaseURL == "" {
		return nil, fmt.Errorf("DATABASE_URL is required")
	}
	if c.RedisURL == "" {
		return nil, fmt.Errorf("REDIS_URL is required")
	}

	memKB := uint32(mustParseInt(getEnv("ARGON2_MEMORY_KB", "19456"), 19456))
	iter := uint32(mustParseInt(getEnv("ARGON2_ITERATIONS", "2"), 2))
	par := uint8(mustParseInt(getEnv("ARGON2_PARALLELISM", "1"), 1))
	saltLen := uint32(mustParseInt(getEnv("ARGON2_SALT_LENGTH", "16"), 16))
	keyLen := uint32(mustParseInt(getEnv("ARGON2_KEY_LENGTH", "32"), 32))
	c.Argon2Params = argon2id.Params{
		Memory:      memKB,
		Iterations:  iter,
		Parallelism: par,
		SaltLength:  saltLen,
		KeyLength:   keyLen,
	}

	return c, nil
}

func getEnv(k, def string) string {
	if v := os.Getenv(k); v != "" {
		return v
	}
	return def
}

func mustParseInt(s string, def int) int {
	n, err := strconv.Atoi(strings.TrimSpace(s))
	if err != nil {
		return def
	}
	return n
}

func mustParseDur(s string, def time.Duration) time.Duration {
	d, err := time.ParseDuration(strings.TrimSpace(s))
	if err != nil {
		return def
	}
	return d
}

// IsProduction reports whether the process is running with APP_ENV=production.
// Used to gate prod-only behaviour (HSTS, stricter cookies, etc.) so dev
// machines never accidentally enable headers that would lock out localhost.
func (c *Config) IsProduction() bool { return c.AppEnv == EnvProduction }

// parseCSV splits a comma-separated env value into trimmed, non-empty entries.
// Lets CORS_ORIGIN list multiple frontends (dev + staging + prod) without
// needing per-environment env files.
func parseCSV(s string) []string {
	parts := strings.Split(s, ",")
	out := make([]string, 0, len(parts))
	for _, p := range parts {
		if v := strings.TrimSpace(p); v != "" {
			out = append(out, v)
		}
	}
	return out
}
