#!/usr/bin/env bash
# Sync web i18n JSON (excluding landing) into Flutter assets.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/frontend/src/i18n/locales"
DST="$ROOT/mobile/assets/i18n"

NAMESPACES=(common auth nav dashboard stats transactions budget goals wallets profile)

for locale in id en; do
  mkdir -p "$DST/$locale"
  for ns in "${NAMESPACES[@]}"; do
    cp "$SRC/$locale/$ns.json" "$DST/$locale/$ns.json"
  done
done

echo "Synced ${#NAMESPACES[@]} namespaces × 2 locales → $DST"
