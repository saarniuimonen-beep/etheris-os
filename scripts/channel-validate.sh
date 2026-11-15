#!/usr/bin/env bash
# Channel validation automation (Beta) — compare stable vs rc Archive snapshots.
# Does not mutate the host channel unless --apply-rc is passed.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONF="$ROOT/profile/etheris/airootfs/etc/etheris/channels.conf"
OUT="$ROOT/out/channel-validate-$(date -u +%Y%m%dT%H%M%SZ).md"

STABLE_LAG=14
RC_LAG=7
[[ -f "$CONF" ]] && STABLE_LAG="$(awk -F= '/^STABLE_LAG_DAYS=/{print $2; exit}' "$CONF")"
[[ -f "$CONF" ]] && RC_LAG="$(awk -F= '/^RC_LAG_DAYS=/{print $2; exit}' "$CONF")"

stamp_days_ago() {
  local days="$1"
  date -u -d "today - ${days} days" +%Y/%m/%d 2>/dev/null \
    || date -u -v-"${days}"d +%Y/%m/%d
}

STABLE_STAMP="$(stamp_days_ago "$STABLE_LAG")"
RC_STAMP="$(stamp_days_ago "$RC_LAG")"

echo "Etheris channel validation"
echo "  stable snapshot: $STABLE_STAMP (lag ${STABLE_LAG}d)"
echo "  rc snapshot:     $RC_STAMP (lag ${RC_LAG}d)"
echo "  report:          $OUT"

{
  echo "# Channel validation"
  echo
  echo "- When (UTC): $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- Stable Archive: \`https://archive.archlinux.org/repos/${STABLE_STAMP}/\`"
  echo "- RC Archive: \`https://archive.archlinux.org/repos/${RC_STAMP}/\`"
  echo
  echo "## Checks"
} >"$OUT"

ok=0
fail=0
check_url() {
  local label="$1" url="$2"
  if curl -fsI --max-time 20 "$url" >/dev/null 2>&1; then
    echo "- [x] $label reachable" >>"$OUT"
    echo "OK  $label"
    ok=$((ok + 1))
  else
    echo "- [ ] $label NOT reachable ($url)" >>"$OUT"
    echo "FAIL $label"
    fail=$((fail + 1))
  fi
}

check_url "stable core db" "https://archive.archlinux.org/repos/${STABLE_STAMP}/core/os/x86_64/core.db"
check_url "rc core db" "https://archive.archlinux.org/repos/${RC_STAMP}/core/os/x86_64/core.db"
check_url "stable extra db" "https://archive.archlinux.org/repos/${STABLE_STAMP}/extra/os/x86_64/extra.db"

{
  echo
  echo "## Result: $ok OK, $fail FAIL"
  echo
  echo "Promotion (manual): after rc soak + smoke, shorten STABLE_LAG or refresh mirrors via \`etheris-update channel stable\`."
  if [[ "${1:-}" == "--apply-rc" ]]; then
    echo
    echo "NOTE: --apply-rc requested — run on a disposable system:"
    echo "  sudo etheris-update channel rc && sudo etheris-update upgrade"
  fi
} >>"$OUT"

echo "Wrote $OUT"
((fail == 0))
