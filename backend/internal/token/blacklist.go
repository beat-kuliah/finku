package token

import (
	"context"
	"time"

	"finku/backend/internal/cache"
)

type Blacklist struct {
	cache *cache.Client
}

func NewBlacklist(c *cache.Client) *Blacklist {
	return &Blacklist{cache: c}
}

func (b *Blacklist) Add(ctx context.Context, jti string, ttl time.Duration) error {
	return b.cache.BlacklistAdd(ctx, jti, ttl)
}

func (b *Blacklist) Has(ctx context.Context, jti string) (bool, error) {
	return b.cache.BlacklistHas(ctx, jti)
}
