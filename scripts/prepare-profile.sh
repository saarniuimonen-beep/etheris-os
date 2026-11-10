#!/usr/bin/env bash
# Sync /etc/skel into live user home before building
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="$ROOT/profile/etheris/airootfs"
rm -rf "$BASE/home/etheris"
mkdir -p "$BASE/home"
cp -a "$BASE/etc/skel" "$BASE/home/etheris"
chmod 755 "$BASE/usr/local/bin/"* 2>/dev/null || true
# Copy VERSION into image
mkdir -p "$BASE/usr/local/share/etheris"
cp -f "$ROOT/VERSION" "$BASE/usr/local/share/etheris/VERSION"
cp -f "$ROOT/VERSION" "$BASE/etc/etheris-version"
# Stage 1 — refresh tokens-*.conf from etheris.tokens.json when generator is present
if [[ -x "$BASE/usr/local/bin/etheris-tokens-generate" ]]; then
  ETHERIS_SHARE="$BASE/usr/local/share/etheris" \
    "$BASE/usr/local/bin/etheris-tokens-generate" \
    --design-dir "$BASE/usr/local/share/etheris/design" || true
fi
echo "Live user home synced from skel."
