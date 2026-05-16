package transaction

import "testing"

func TestModifiedBalanceDelta(t *testing.T) {
	if got := modifiedBalanceDelta(500, true); got != 500 {
		t.Fatalf("increase: got %d want 500", got)
	}
	if got := modifiedBalanceDelta(500, false); got != -500 {
		t.Fatalf("decrease: got %d want -500", got)
	}
}
