package cache

import (
	"context"
	"fmt"
	"strings"
	"time"

	"finku/backend/internal/config"

	"github.com/redis/go-redis/v9"
)

type Client struct {
	rdb *redis.Client
	cfg *config.Config
}

func New(ctx context.Context, cfg *config.Config) (*Client, error) {
	opt, err := redis.ParseURL(cfg.RedisURL)
	if err != nil {
		return nil, fmt.Errorf("parse redis url: %w", err)
	}
	if cfg.RedisUsername != "" {
		opt.Username = cfg.RedisUsername
	}
	if cfg.RedisPassword != "" {
		opt.Password = cfg.RedisPassword
	}
	opt.PoolSize = cfg.RedisPoolSize
	rdb := redis.NewClient(opt)
	if err := rdb.Ping(ctx).Err(); err != nil {
		return nil, fmt.Errorf("ping redis: %w", err)
	}
	return &Client{rdb: rdb, cfg: cfg}, nil
}

func (c *Client) Close() error {
	return c.rdb.Close()
}

func (c *Client) RDB() *redis.Client {
	return c.rdb
}

// RateLimitAllow returns false if IP exceeded max requests in window.
func (c *Client) RateLimitAllow(ctx context.Context, ip string) (bool, error) {
	key := "auth:rl:" + ip
	pipe := c.rdb.Pipeline()
	incr := pipe.Incr(ctx, key)
	pipe.Expire(ctx, key, c.cfg.AuthRateLimitWin)
	if _, err := pipe.Exec(ctx); err != nil {
		return false, err
	}
	n, err := incr.Result()
	if err != nil {
		return false, err
	}
	return int(n) <= c.cfg.AuthRateLimitMax, nil
}

// LockoutActive returns true if email is locked (failed attempts >= max).
func (c *Client) LockoutActive(ctx context.Context, email string) (bool, error) {
	key := "lockout:" + strings.ToLower(email)
	n, err := c.rdb.Get(ctx, key).Int()
	if err == redis.Nil {
		return false, nil
	}
	if err != nil {
		return false, err
	}
	return n >= c.cfg.LockoutMax, nil
}

// LockoutIncr increments failed login counter; sets TTL on first increment.
func (c *Client) LockoutIncr(ctx context.Context, email string) (int, error) {
	key := "lockout:" + strings.ToLower(email)
	n, err := c.rdb.Incr(ctx, key).Result()
	if err != nil {
		return 0, err
	}
	if n == 1 {
		if err := c.rdb.Expire(ctx, key, c.cfg.LockoutWindow).Err(); err != nil {
			return int(n), err
		}
	}
	return int(n), nil
}

func (c *Client) LockoutReset(ctx context.Context, email string) error {
	key := "lockout:" + strings.ToLower(email)
	return c.rdb.Del(ctx, key).Err()
}

const refreshPrefix = "refresh:"

type RefreshPayload struct {
	UserID  string `json:"user_id"`
	Family  string `json:"family"`
}

func refreshKey(jti string) string {
	return refreshPrefix + jti
}

func (c *Client) RefreshSet(ctx context.Context, jti string, payload string, ttl time.Duration) error {
	return c.rdb.Set(ctx, refreshKey(jti), payload, ttl).Err()
}

func (c *Client) RefreshGet(ctx context.Context, jti string) (string, error) {
	s, err := c.rdb.Get(ctx, refreshKey(jti)).Result()
	if err == redis.Nil {
		return "", redis.Nil
	}
	return s, err
}

func (c *Client) RefreshDel(ctx context.Context, jti string) error {
	return c.rdb.Del(ctx, refreshKey(jti)).Err()
}

func (c *Client) BlacklistAdd(ctx context.Context, jti string, ttl time.Duration) error {
	return c.rdb.Set(ctx, "bl:"+jti, "1", ttl).Err()
}

func (c *Client) BlacklistHas(ctx context.Context, jti string) (bool, error) {
	n, err := c.rdb.Exists(ctx, "bl:"+jti).Result()
	if err != nil {
		return false, err
	}
	return n > 0, nil
}

func (c *Client) UserCacheGet(ctx context.Context, userID string) (string, error) {
	s, err := c.rdb.Get(ctx, "user:"+userID).Result()
	if err == redis.Nil {
		return "", redis.Nil
	}
	return s, err
}

func (c *Client) UserCacheSet(ctx context.Context, userID string, json string, ttl time.Duration) error {
	return c.rdb.Set(ctx, "user:"+userID, json, ttl).Err()
}

func (c *Client) UserCacheDel(ctx context.Context, userID string) error {
	return c.rdb.Del(ctx, "user:"+userID).Err()
}
