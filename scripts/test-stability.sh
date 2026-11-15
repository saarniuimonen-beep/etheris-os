#!/usr/bin/env bash
# Etheris OS — Stability criteria runner (Beta 0.5).
# Enforces docs/STABILITY-CRITERIA.md section A (host). Optionally validates
# an existing live evidence report when ETHERIS_STABILITY_EVIDENCE is set.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/stability-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"

ok=0
fail=0
pass() { printf 'OK  %s\n' "$*"; ok=$((ok + 1)); }
bad() { printf 'FAIL %s\n' "$*"; fail=$((fail + 1)); }

echo "Etheris stability criteria"
echo "  criteria: docs/STABILITY-CRITERIA.md"
echo "  out:      $OUT"
echo

# --- A1 profile ---
if "$ROOT/scripts/check-profile.sh" >"$OUT/a1-check-profile.txt" 2>&1; then
  pass "A1 check-profile"
else
  bad "A1 check-profile"
  tail -20 "$OUT/a1-check-profile.txt" || true
fi

# --- A2 P0 ---
if "$ROOT/scripts/test-p0-security.sh" >"$OUT/a2-p0.txt" 2>&1; then
  if grep -qE 'Result:.*0 FAIL' "$OUT/a2-p0.txt"; then
    pass "A2 P0 security (0 FAIL)"
  else
    bad "A2 P0 security (unexpected summary)"
  fi
else
  bad "A2 P0 security"
  tail -20 "$OUT/a2-p0.txt" || true
fi

# --- A8 channel ---
if "$ROOT/scripts/channel-validate.sh" >"$OUT/a8-channel.txt" 2>&1; then
  pass "A8 channel Archive DBs"
else
  bad "A8 channel Archive DBs"
  tail -20 "$OUT/a8-channel.txt" || true
fi

# --- A9 ISO (optional if missing) ---
ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi
if [[ -n "$ISO" && -f "$ISO" ]]; then
  if "$ROOT/scripts/validate-iso.sh" "$ISO" >"$OUT/a9-validate-iso.txt" 2>&1; then
    pass "A9 validate-iso ($(basename "$ISO"))"
  else
    bad "A9 validate-iso"
    tail -30 "$OUT/a9-validate-iso.txt" || true
  fi
else
  echo "SKIP A9 validate-iso (no ISO — pass path or build)"
fi

# --- A10 maturity tree fixes (rock-solid dependency) ---
AI="$ROOT/profile/etheris/airootfs"
a10=0
grep -qE 'HOME:-\}|HOME:=/root' "$AI/usr/local/bin/etheris-perf" || a10=1
grep -q 'Environment=HOME=' "$AI/etc/systemd/system/etheris-perf.service" || a10=1
grep -q 'as_root' "$AI/usr/local/bin/etheris-security" || a10=1
grep -q 'is_benign_failed_unit' "$AI/usr/local/bin/etheris-doctor" || a10=1
grep -q 'firefox_visible_on_ws' "$AI/usr/local/bin/etheris-browser" || a10=1
if ((a10 == 0)); then
  pass "A10 maturity/rock-solid tree fixes present"
else
  bad "A10 missing perf/security/doctor/browser rock-solid fixes"
fi

# --- B / R evidence (skip with ETHERIS_STABILITY_HOST_ONLY=1) ---
MODE="${ETHERIS_STABILITY_MODE:-baseline}" # baseline | rocksolid
if [[ "${ETHERIS_STABILITY_HOST_ONLY:-0}" == "1" ]]; then
  echo "SKIP B/R-evidence (ETHERIS_STABILITY_HOST_ONLY=1)"
else
  EVIDENCE="${ETHERIS_STABILITY_EVIDENCE:-}"
  if [[ -z "$EVIDENCE" ]]; then
    if [[ "$MODE" == rocksolid ]]; then
      EVIDENCE="$(/bin/ls -1t "$ROOT"/out/VERIFICATION-STABILITY-ROCKSOLID-*.md 2>/dev/null | head -1 || true)"
    fi
    [[ -z "$EVIDENCE" ]] && EVIDENCE="$(/bin/ls -1t "$ROOT"/out/VERIFICATION-STABILITY-*.md 2>/dev/null | head -1 || true)"
  fi
  if [[ -n "$EVIDENCE" && -f "$EVIDENCE" && "$EVIDENCE" != /dev/null ]]; then
    need=(
      'Password-first'
      'etheris-auth-check'
      '12 OK'
      'nftables'
      'Super\+A'
      'Super\+D'
      'soak|open/close|×5|×8|×15|x5|x8|x15'
    )
    if [[ "$MODE" == rocksolid ]] || grep -qiE 'rock-solid|ROCK-SOLID|ROCKSOLID' "$EVIDENCE"; then
      need+=(
        'doctor'
        '15'
        'swap'
        'etheris-perf'
        'menu-hover'
        'second cold|cold boot|R11|2nd boot'
      )
    fi
    missing=0
    for pat in "${need[@]}"; do
      if ! grep -qiE "$pat" "$EVIDENCE"; then
        bad "B/R-evidence missing /$pat/ in $(basename "$EVIDENCE")"
        missing=1
      fi
    done
    # Fail only if evidence claims inject was used — allow "none" / "no …" denials.
    if grep -qiE '(used|via|with|applied)[[:space:]]+guest-apply|guest-apply[[:space:]]+(used|via|applied)' "$EVIDENCE" \
      || grep -qiE '10\.0\.2\.2:87' "$EVIDENCE" \
      || grep -qiE 'HTTP inject (used|applied|via)' "$EVIDENCE"; then
      if [[ "$MODE" == rocksolid ]] || grep -qiE 'rock-solid|ROCK-SOLID' "$EVIDENCE"; then
        bad "rock-solid evidence must not rely on guest-apply"
        missing=1
      else
        echo "NOTE: evidence mentions guest-apply (OK for baseline PASS; not rock-solid)"
      fi
    fi
    if grep -qiE 'Stability battery PASS|rock-solid PASS|Rock-solid PASS|ROCK-SOLID PASS|\*\*PASS\*\*' "$EVIDENCE" \
      && ! grep -qiE 'Stability battery FAIL|rock-solid FAIL|Verdict.*\*\*FAIL\*\*' "$EVIDENCE"; then
      if ((missing == 0)); then
        pass "B/R-evidence report present ($(basename "$EVIDENCE"))"
      fi
    else
      bad "B/R-evidence verdict not PASS in $(basename "$EVIDENCE")"
    fi
  else
    echo "SKIP B/R-evidence (no VERIFICATION-STABILITY*.md — run live rock-solid then re-run)"
  fi
fi

{
  echo "# Stability criteria run"
  echo
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- OK: $ok"
  echo "- FAIL: $fail"
  echo "- ISO: ${ISO:-none}"
  echo "- Evidence: ${EVIDENCE:-none}"
  echo
  echo "See docs/STABILITY-CRITERIA.md."
} >"$OUT/SUMMARY.md"

echo
echo "Result: $ok OK, $fail FAIL"
echo "Summary: $OUT/SUMMARY.md"
if ((fail)); then
  echo "Stability criteria FAILED"
  exit 1
fi
echo "Stability criteria PASSED"
exit 0
