package wallet

import (
	"errors"
	"testing"

	"finku/backend/internal/httpx"
)

func TestValidateAdjustRecordAs(t *testing.T) {
	cases := []struct {
		delta    int64
		recordAs string
		ok       bool
	}{
		{1000, "income", true},
		{1000, "modified", true},
		{1000, "expense", false},
		{-500, "expense", true},
		{-500, "modified", true},
		{-500, "income", false},
		{0, "modified", false},
	}
	for _, tc := range cases {
		err := validateAdjustRecordAs(tc.delta, tc.recordAs)
		if tc.ok && err != nil {
			t.Fatalf("delta=%d recordAs=%q: unexpected error %v", tc.delta, tc.recordAs, err)
		}
		if !tc.ok && err == nil {
			t.Fatalf("delta=%d recordAs=%q: expected error", tc.delta, tc.recordAs)
		}
		if err != nil {
			var svcErr *httpx.ServiceError
			if !errors.As(err, &svcErr) {
				t.Fatalf("expected *httpx.ServiceError, got %T", err)
			}
		}
	}
}
