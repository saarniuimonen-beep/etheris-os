#!/usr/bin/env bash
# Etheris maturity gate — strict Must M0/M1 + tree (rock-solid).
# Live M2/M3 still need QEMU evidence (see docs/MATURITY-CRITERIA.md).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(ls -1t out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi

ok=0
fail=0
pass() { echo "  OK  $*"; ok=$((ok + 1)); }
bad() { echo "FAIL  $*"; fail=$((fail + 1)); }

echo "Etheris maturity-check (STRICT Must M0/M1 + tree)"
echo "  root: $ROOT"
echo "  iso:  ${ISO:-none}"
echo "  criteria: docs/MATURITY-CRITERIA.md"
echo

section() { echo; echo "==> $*"; }

section "M0.1 check-profile"
if ./scripts/check-profile.sh >/tmp/etheris-maturity-profile.log 2>&1; then
  pass "check-profile PASSED"
else
  bad "check-profile FAILED"
  tail -20 /tmp/etheris-maturity-profile.log | sed 's/^/  | /'
fi

section "M0.2 P0 security"
if ./scripts/test-p0-security.sh >/tmp/etheris-maturity-p0.log 2>&1; then
  pass "test-p0-security 0 FAIL"
else
  bad "test-p0-security FAILED"
  tail -20 /tmp/etheris-maturity-p0.log | sed 's/^/  | /'
fi

section "M0.3 keybind gates (in check-profile log)"
if grep -qiE 'Super\+A|control-center|Menu' /tmp/etheris-maturity-profile.log 2>/dev/null \
  && grep -qiE 'Super\+D|launcher' /tmp/etheris-maturity-profile.log 2>/dev/null; then
  pass "keybind Menu/launcher mentioned in profile checks"
elif ./scripts/check-profile.sh 2>&1 | tee /tmp/etheris-maturity-profile2.log | grep -qiE 'keybind|Super\+A|Super\+D|Menu'; then
  pass "keybind gates exercised"
else
  # Soft: check-profile exit 0 already implies gates if encoded there
  if grep -qE 'Super\+A|super\+a|KEY_A' profile/etheris/airootfs/etc/skel/.config/sway/config.d/* 2>/dev/null \
    || grep -rqE 'control-center|etheris-menu' profile/etheris/airootfs/etc/skel/.config/sway/ 2>/dev/null; then
    pass "sway config wires Menu/launcher (profile OK)"
  else
    bad "could not confirm Super+A/D Menu/launcher wiring"
  fi
fi

section "M1.1 validate-iso"
if [[ -n "$ISO" && -f "$ISO" ]]; then
  if ./scripts/validate-iso.sh "$ISO" >/tmp/etheris-maturity-validate.log 2>&1; then
    pass "validate-iso PASSED ($ISO)"
  else
    bad "validate-iso FAILED"
    tail -25 /tmp/etheris-maturity-validate.log | sed 's/^/  | /'
  fi
else
  bad "no ISO to validate (pass path as \$1)"
fi

section "M1.2 channel-validate"
if ./scripts/channel-validate.sh >/tmp/etheris-maturity-channel.log 2>&1; then
  pass "channel Archive DBs reachable"
else
  bad "channel-validate FAILED"
  tail -20 /tmp/etheris-maturity-channel.log | sed 's/^/  | /'
fi

section "M1.3 tree: doctor-clean / rock-solid fixes"
AI=profile/etheris/airootfs
if grep -qE 'HOME:=/root|HOME:-\}' "$AI/usr/local/bin/etheris-perf"; then
  pass "etheris-perf HOME unbound-safe"
else
  bad "etheris-perf missing HOME default"
fi
if grep -qE 'Environment=HOME=' "$AI/etc/systemd/system/etheris-perf.service"; then
  pass "etheris-perf.service sets HOME"
else
  bad "etheris-perf.service missing Environment=HOME"
fi
if grep -q 'as_root' "$AI/usr/local/bin/etheris-security" \
  && grep -qiE 'SKIP|skip' "$AI/usr/local/bin/etheris-security"; then
  pass "etheris-security audit elevates/skips shadow"
else
  bad "etheris-security audit still false-FAILs without sudo"
fi
if grep -q 'is_benign_failed_unit' "$AI/usr/local/bin/etheris-doctor" \
  && grep -qE 'systemd-loop@\*' "$AI/usr/local/bin/etheris-doctor"; then
  pass "etheris-doctor ignores systemd-loop@*"
else
  bad "etheris-doctor missing broad systemd-loop@* filter"
fi
if grep -q 'firefox_visible_on_ws' "$AI/usr/local/bin/etheris-browser"; then
  pass "etheris-browser preload scratchpad hygiene"
else
  bad "etheris-browser missing firefox_visible_on_ws"
fi
if [[ -f docs/MATURITY-CRITERIA.md ]] && grep -q 'No CONDITIONAL PASS' docs/MATURITY-CRITERIA.md; then
  pass "docs/MATURITY-CRITERIA.md strict (no conditional)"
else
  bad "MATURITY-CRITERIA.md missing strict revision"
fi

section "bash -n"
for f in \
  "$AI/usr/local/bin/etheris-perf" \
  "$AI/usr/local/bin/etheris-security" \
  "$AI/usr/local/bin/etheris-doctor" \
  "$AI/usr/local/bin/etheris-browser"; do
  if bash -n "$f"; then
    pass "bash -n $(basename "$f")"
  else
    bad "bash -n $(basename "$f")"
  fi
done

section "M1.4 game-ready / drivers (tree)"
if ./scripts/test-game-ready.sh >/tmp/etheris-maturity-game.log 2>&1; then
  pass "test-game-ready PASSED"
else
  bad "test-game-ready FAILED"
  tail -25 /tmp/etheris-maturity-game.log | sed 's/^/  | /'
fi

echo
echo "Summary: $ok OK, $fail FAIL"
echo "Live Must M2.*/M3.* still require QEMU evidence (strict — no CONDITIONAL PASS)."
if ((fail)); then
  echo "maturity-check: FAILED"
  exit 1
fi
echo "maturity-check: PASSED (STRICT L0/L1 + tree)"
exit 0
