package token

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"finku/backend/internal/cache"

	"github.com/google/uuid"
	"github.com/redis/go-redis/v9"
)

type RefreshMeta struct {
	UserID uuid.UUID
	Family uuid.UUID
}

type RefreshStore struct {
	cache *cache.Client
	ttl   time.Duration
}

func NewRefreshStore(c *cache.Client, ttl time.Duration) *RefreshStore {
	return &RefreshStore{cache: c, ttl: ttl}
}

func (s *RefreshStore) Issue(ctx context.Context, userID uuid.UUID, family uuid.UUID) (string, error) {
	jti := uuid.NewString()
	payload, _ := json.Marshal(map[string]string{
		"user_id": userID.String(),
		"family":  family.String(),
	})
	if err := s.cache.RefreshSet(ctx, jti, string(payload), s.ttl); err != nil {
		return "", err
	}
	return jti, nil
}

func (s *RefreshStore) Get(ctx context.Context, jti string) (RefreshMeta, error) {
	raw, err := s.cache.RefreshGet(ctx, jti)
	if err != nil {
		if err == redis.Nil {
			return RefreshMeta{}, redis.Nil
		}
		return RefreshMeta{}, err
	}
	var parsed struct {
		UserID string `json:"user_id"`
		Family string `json:"family"`
	}
	if err := json.Unmarshal([]byte(raw), &parsed); err != nil {
		return RefreshMeta{}, err
	}
	uid, err := uuid.Parse(parsed.UserID)
	if err != nil {
		return RefreshMeta{}, errors.New("invalid refresh user id")
	}
	fid, err := uuid.Parse(parsed.Family)
	if err != nil {
		return RefreshMeta{}, errors.New("invalid refresh family id")
	}
	return RefreshMeta{UserID: uid, Family: fid}, nil
}

func (s *RefreshStore) Revoke(ctx context.Context, jti string) error {
	return s.cache.RefreshDel(ctx, jti)
}
