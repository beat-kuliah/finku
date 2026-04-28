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

type Config struct {
	Port              string
	CORSOrigin        string
	DatabaseURL       string
	DBMaxConns        int32
	DBMinConns        int32
	RedisURL          string
	RedisUsername     string
	RedisPassword     string
	RedisPoolSize     int
	JWTSecret         []byte
	AccessTokenTTL    time.Duration
	RefreshTokenTTL   time.Duration
	Argon2Params      argon2id.Params
	AuthRateLimitMax  int
	AuthRateLimitWin  time.Duration
	LockoutMax        int
	LockoutWindow     time.Duration
	UserCacheTTL      time.Duration
	CookieSecure      bool
	CookieDomain      string
	RefreshCookieName string
}

func Load() (*Config, error) {
	_ = godotenv.Load()

	c := &Config{
		Port:              getEnv("PORT", "8080"),
		CORSOrigin:        getEnv("CORS_ORIGIN", "http://localhost:5173"),
		DatabaseURL:       os.Getenv("DATABASE_URL"),
		DBMaxConns:        int32(mustParseInt(getEnv("DB_MAX_CONNS", "20"), 20)),
		DBMinConns:        int32(mustParseInt(getEnv("DB_MIN_CONNS", "2"), 2)),
		RedisURL:          os.Getenv("REDIS_URL"),
		RedisUsername:     os.Getenv("REDIS_USERNAME"),
		RedisPassword:     os.Getenv("REDIS_PASSWORD"),
		RedisPoolSize:     mustParseInt(getEnv("REDIS_POOL_SIZE", "20"), 20),
		AccessTokenTTL:    mustParseDur(getEnv("ACCESS_TOKEN_TTL", "15m"), 15*time.Minute),
		RefreshTokenTTL:   mustParseDur(getEnv("REFRESH_TOKEN_TTL", "168h"), 168*time.Hour),
		AuthRateLimitMax:  mustParseInt(getEnv("AUTH_RATE_LIMIT_REQUESTS", "5"), 5),
		AuthRateLimitWin:  mustParseDur(getEnv("AUTH_RATE_LIMIT_WINDOW", "1m"), time.Minute),
		LockoutMax:        mustParseInt(getEnv("LOCKOUT_MAX_ATTEMPTS", "5"), 5),
		LockoutWindow:     mustParseDur(getEnv("LOCKOUT_WINDOW", "15m"), 15*time.Minute),
		UserCacheTTL:      mustParseDur(getEnv("USER_CACHE_TTL", "5m"), 5*time.Minute),
		CookieSecure:      strings.EqualFold(getEnv("COOKIE_SECURE", "false"), "true"),
		CookieDomain:      os.Getenv("COOKIE_DOMAIN"),
		RefreshCookieName: getEnv("REFRESH_COOKIE_NAME", "refresh_token"),
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
