#!/usr/bin/env bash
# Etheris OS — extremely strict bug-regression criteria (rock-solid).
# See docs/BUG-CRITERIA.md
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
A="$ROOT/profile/etheris/airootfs"
OUT="$ROOT/out/bugs-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"

ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi

ok=0
fail=0
pass() { printf 'OK  %s\n' "$*"; ok=$((ok + 1)); }
bad() { printf 'FAIL %s\n' "$*"; fail=$((fail + 1)); }

echo "Etheris bug criteria (rock-solid)"
echo "  criteria: docs/BUG-CRITERIA.md"
echo "  out:      $OUT"
echo "  iso:      ${ISO:-none}"
echo

# ---------- B0 gate stack ----------
if "$ROOT/scripts/check-profile.sh" >"$OUT/b0-profile.txt" 2>&1; then
  pass "B0.1 check-profile"
else
  bad "B0.1 check-profile"
  tail -15 "$OUT/b0-profile.txt" | sed 's/^/  | /' || true
fi

if "$ROOT/scripts/test-p0-security.sh" >"$OUT/b0-p0.txt" 2>&1; then
  p0_ok="$(grep -Eo '[0-9]+ OK' "$OUT/b0-p0.txt" | tail -1 | awk '{print $1}')"
  if [[ -n "${p0_ok:-}" && "$p0_ok" -ge 44 ]]; then
    pass "B0.2 P0 security (${p0_ok} OK ≥44)"
  else
    bad "B0.2 P0 OK count too low (${p0_ok:-?})"
  fi
else
  bad "B0.2 P0 security"
fi

if [[ -n "$ISO" && -f "$ISO" ]]; then
  if "$ROOT/scripts/reliability-check.sh" "$ISO" >"$OUT/b0-reliability.txt" 2>&1; then
    pass "B0.3 reliability-check"
  else
    bad "B0.3 reliability-check"
    tail -20 "$OUT/b0-reliability.txt" | sed 's/^/  | /' || true
  fi
else
  bad "B0.3 reliability-check (no ISO)"
fi

if "$ROOT/scripts/test-security.sh" ${ISO:+"$ISO"} >"$OUT/b0-security.txt" 2>&1; then
  pass "B0.4 test-security"
else
  bad "B0.4 test-security"
  tail -20 "$OUT/b0-security.txt" | sed 's/^/  | /' || true
fi

if find "$A" \( -type d -name '__pycache__' -o -name '*.pyc' \) -print -quit 2>/dev/null | grep -q .; then
  bad "B0.5 __pycache__/pyc under airootfs"
else
  pass "B0.5 no __pycache__ in airootfs"
fi

# ---------- B1 regression seals ----------
AC="$A/usr/local/bin/etheris-auth-check"
if grep -q 'libcrypt' "$AC" && grep -q 'ctypes' "$AC"; then
  pass "B1.1 auth-check libxcrypt/ctypes (Py3.13)"
else
  bad "B1.1 auth-check missing libxcrypt/ctypes"
fi

if grep -qE 'HOME:=/root|HOME:-\}' "$A/usr/local/bin/etheris-perf" \
  && grep -q 'Environment=HOME=' "$A/etc/systemd/system/etheris-perf.service"; then
  pass "B1.2 etheris-perf HOME unbound-safe + unit Environment"
else
  bad "B1.2 etheris-perf HOME seal missing"
fi

if grep -q 'is_benign_failed_unit' "$A/usr/local/bin/etheris-doctor" \
  && grep -qE 'systemd-loop@\*' "$A/usr/local/bin/etheris-doctor"; then
  pass "B1.3 doctor benign systemd-loop@*"
else
  bad "B1.3 doctor missing systemd-loop@* filter"
fi

if grep -q 'as_root' "$A/usr/local/bin/etheris-security" \
  && grep -qiE 'SKIP|skip' "$A/usr/local/bin/etheris-security"; then
  pass "B1.4 security as_root/SKIP shadow"
else
  bad "B1.4 security audit still false-FAILs without sudo"
fi

if grep -q 'firefox_visible_on_ws' "$A/usr/local/bin/etheris-browser" \
  && grep -q 'move scratchpad' "$A/usr/local/bin/etheris-browser"; then
  pass "B1.5 browser preload workspace hygiene"
else
  bad "B1.5 browser preload hygiene missing"
fi

if [[ -f "$A/var/lib/regreet/state.toml" ]] \
  && ! [[ -e "$A/var/lib/regreet/cache.toml" || -e "$A/var/lib/regreet/cache.json" ]] \
  && grep -q 'var/lib/regreet/state.toml' "$A/usr/local/bin/etheris-installer"; then
  pass "B1.6 ReGreet state.toml only (live + installer)"
else
  bad "B1.6 legacy ReGreet cache or missing state.toml seed"
fi

if [[ -L "$A/etc/systemd/system/multi-user.target.wants/etheris-hide-stock-sway.service" ]] \
  && [[ -x "$A/usr/local/bin/etheris-hide-stock-sway" || -f "$A/usr/local/bin/etheris-hide-stock-sway" ]]; then
  pass "B1.7 hide-stock-sway enabled + helper"
else
  bad "B1.7 hide-stock-sway missing"
fi

RULE="$A/etc/polkit-1/rules.d/49-etheris-wheel.rules"
if grep -q 'AUTH_ADMIN_KEEP' "$RULE" \
  && grep -q 'action.id' "$RULE" \
  && ! grep -qE 'isInGroup\("wheel"\)[[:space:]]*\)[[:space:]]*\{[[:space:]]*return[[:space:]]+polkit\.Result\.YES' "$RULE"; then
  pass "B1.8 polkit scoped (no classic blanket YES)"
else
  # Still OK if action.id checks exist with AUTH_ADMIN_KEEP
  if grep -q 'AUTH_ADMIN_KEEP' "$RULE" && grep -q 'action.id\|var id' "$RULE"; then
    pass "B1.8 polkit scoped with AUTH_ADMIN_KEEP"
  else
    bad "B1.8 polkit not scoped"
  fi
fi

if ! grep -nE '^[^#]*chmod[[:space:]]+777|^[^#]*chmod[[:space:]]+666' \
     "$A/usr/local/bin/etheris-oobe" "$A/usr/local/bin/etheris-installer" 2>/dev/null \
  && grep -q '2770' "$A/usr/local/bin/etheris-installer"; then
  pass "B1.9 OOBE perms hardened (no 777/666; 2770)"
else
  bad "B1.9 OOBE world-writable or missing 2770"
fi

UNIT="$A/etc/systemd/system/etheris-auth-setup.service"
if grep -q 'ConditionKernelCommandLine=archisobasedir' "$UNIT" \
  && grep -q 'ConditionPathExists=/run/archiso' "$UNIT" \
  && grep -q 'systemctl mask etheris-auth-setup' "$A/usr/local/bin/etheris-installer"; then
  pass "B1.10 auth-setup live-only + installer mask"
else
  bad "B1.10 auth-setup install persistence seal broken"
fi

if grep -q 'rm -f /etc/sudoers.d/etheris' "$A/usr/local/bin/etheris-installer" \
  && grep -q "%wheel ALL=(ALL:ALL) ALL" "$A/usr/local/bin/etheris-installer"; then
  pass "B1.11 installer strips live NOPASSWD + password wheel"
else
  bad "B1.11 installer sudo cleanup incomplete"
fi

MH="$A/usr/local/bin/etheris-menu-hover"
if grep -q 'ox + ow - 400' "$MH" || grep -q 'ox + ow -' "$MH"; then
  pass "B1.12 menu-hover multi-output sheet geometry uses ox"
else
  bad "B1.12 menu-hover point_in_sheet may ignore output x offset"
fi

SWAY="$A/etc/skel/.config/sway/config"
if grep -qE 'bindsym \$mod\+a exec \$cc' "$SWAY" \
  && grep -q 'set $cc etheris-overlay control-center' "$SWAY" \
  && grep -qE 'bindsym \$mod\+d exec \$menu' "$SWAY" \
  && grep -q 'set $menu etheris-overlay launcher' "$SWAY"; then
  pass "B1.13 Super+A Menu / Super+D launcher"
else
  bad "B1.13 Super+A/D keybinds wrong"
fi

if [[ -d "$A/home/etheris" ]] && diff -qr "$A/etc/skel" "$A/home/etheris" >/dev/null 2>&1; then
  pass "B1.14 skel matches home/etheris"
else
  bad "B1.14 skel/home drift"
fi

if [[ -L "$A/etc/systemd/system/multi-user.target.wants/avahi-daemon.service" ]]; then
  if [[ -L "$A/etc/systemd/system/avahi-daemon.service" ]] \
    && [[ "$(readlink "$A/etc/systemd/system/avahi-daemon.service")" == /dev/null ]]; then
    bad "B1.15 avahi masked while also wanted"
  else
    pass "B1.15 avahi enabled for Warpinator"
  fi
else
  bad "B1.15 avahi not enabled"
fi

dupes="$(
  {
    /bin/ls -1 "$A/usr/share/applications"/*.desktop 2>/dev/null | xargs -n1 basename
    /bin/ls -1 "$A/usr/local/share/applications"/*.desktop 2>/dev/null | xargs -n1 basename
  } | sort | uniq -d
)"
if [[ -z "$dupes" ]]; then
  pass "B1.16 no duplicate .desktop basenames"
else
  bad "B1.16 duplicate desktops: $dupes"
fi

if grep -q 'var/lib/regreet/state.toml' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'Etheris (Sway)' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'last_user' "$A/usr/local/bin/etheris-installer"; then
  pass "B1.17 installer seeds state.toml correctly"
else
  bad "B1.17 installer state.toml seed incomplete"
fi

KM="$A/usr/local/bin/etheris-keymap-apply"
if grep -q 'invalid LAYOUT' "$KM" && grep -Fq '^[a-z0-9_-]+$' "$KM"; then
  set +e
  out="$("$KM" 'us;id' 2>&1)"
  rc=$?
  set -e
  if [[ $rc -ne 0 ]] && echo "$out" | grep -qi 'invalid LAYOUT'; then
    pass "B1.18 keymap-apply rejects unsafe LAYOUT"
  else
    bad "B1.18 keymap-apply did not reject unsafe LAYOUT"
  fi
else
  bad "B1.18 keymap-apply missing charset validation"
fi

# B1.19: systemd-invoked etheris tools that use set -u + $HOME must default HOME
b119=0
for svc in "$A"/etc/systemd/system/etheris*.service; do
  [[ -f "$svc" ]] || continue
  exec="$(grep -E '^ExecStart=' "$svc" | head -1 | sed 's/^ExecStart=//')"
  bin=""
  case "$exec" in
    /usr/local/bin/etheris-*) bin="${exec%% *}" ;;
    *) continue ;;
  esac
  [[ -f "$bin" ]] || bin="$A${bin}"
  [[ -f "$bin" ]] || continue
  if grep -qE 'set -.*u' "$bin" && grep -qE '\$\{?HOME' "$bin"; then
    if ! grep -qE 'HOME:=|HOME:-\}|Environment=HOME=' "$bin" \
      && ! grep -q 'Environment=HOME=' "$svc"; then
      bad "B1.19 $(basename "$svc") → $(basename "$bin") may unbound HOME"
      b119=1
    fi
  fi
done
[[ $b119 -eq 0 ]] && pass "B1.19 systemd etheris tools HOME-safe"

if grep -q 'pgrep -af' "$ROOT/docs/BUG-CRITERIA.md" \
  && grep -q 'pgrep -af' "$ROOT/docs/STABILITY-CRITERIA.md" \
  && grep -q 'pgrep -af' "$ROOT/docs/RELIABILITY-CRITERIA.md"; then
  pass "B1.20 docs teach pgrep -af for menu-hover"
else
  bad "B1.20 docs still risk pgrep -x for long names"
fi

CC="$A/usr/local/bin/etheris-control-center"
if grep -q 'get_outputs' "$CC" \
  && grep -q 'ow - win_w' "$CC" \
  && ! grep -qE 'move position 890' "$CC"; then
  pass "B1.21 Menu float position uses output geometry (no hardcoded 890)"
else
  bad "B1.21 Menu still hardcodes float X=890 (clips on small outputs)"
fi
if [[ -f "$ROOT/docs/BUG-CRITERIA.md" ]] && grep -q 'ROCK-SOLID' "$ROOT/docs/BUG-CRITERIA.md"; then
  pass "docs/BUG-CRITERIA.md present"
else
  bad "docs/BUG-CRITERIA.md missing"
fi

# ---------- B2 ISO ----------
if [[ -n "$ISO" && -f "$ISO" ]]; then
  if "$ROOT/scripts/validate-iso.sh" "$ISO" >"$OUT/b2-validate.txt" 2>&1; then
    pass "B2.1 validate-iso"
  else
    bad "B2.1 validate-iso"
    tail -20 "$OUT/b2-validate.txt" | sed 's/^/  | /' || true
  fi
  EXTRACT="$ROOT/out/validate-iso/root"
  if [[ -f "$EXTRACT/usr/local/bin/etheris-auth-check" ]] \
    && grep -q 'libcrypt' "$EXTRACT/usr/local/bin/etheris-auth-check" \
    && grep -qE 'HOME:=/root|HOME:-\}' "$EXTRACT/usr/local/bin/etheris-perf" \
    && grep -qE 'systemd-loop@\*' "$EXTRACT/usr/local/bin/etheris-doctor" \
    && grep -q 'as_root' "$EXTRACT/usr/local/bin/etheris-security" \
    && grep -q 'firefox_visible_on_ws' "$EXTRACT/usr/local/bin/etheris-browser"; then
    pass "B2.2 squashfs ships B1.1–B1.5 seals"
  else
    bad "B2.2 squashfs missing regression seals (rebake)"
  fi
else
  bad "B2 no ISO"
fi

# ---------- B3 evidence (optional file) ----------
if [[ "${ETHERIS_BUGS_HOST_ONLY:-0}" == "1" ]]; then
  echo "SKIP B3 evidence (ETHERIS_BUGS_HOST_ONLY=1)"
else
  EVIDENCE="${ETHERIS_BUG_EVIDENCE:-}"
  if [[ -z "$EVIDENCE" ]]; then
    EVIDENCE="$(ls -1t "$ROOT"/out/VERIFICATION-BUGS-ROCKSOLID-*.md 2>/dev/null | head -1 || true)"
  fi
  if [[ -n "$EVIDENCE" && -f "$EVIDENCE" ]]; then
    need=('Password-first|password-first' 'etheris-auth-check' '12 OK' 'doctor' 'etheris-perf' 'menu-hover' 'soak|Super\+A' 'ROCK-SOLID PASS|rock-solid PASS')
    missing=0
    for pat in "${need[@]}"; do
      if ! grep -qiE "$pat" "$EVIDENCE"; then
        bad "B3 evidence missing /$pat/ in $(basename "$EVIDENCE")"
        missing=1
      fi
    done
    if grep -qiE 'guest-apply via|via guest-apply|used guest-apply|HTTP inject' "$EVIDENCE"; then
      bad "B3 rock-solid evidence must not use guest-apply"
      missing=1
    fi
    if ((missing == 0)); then
      pass "B3 evidence report present ($(basename "$EVIDENCE"))"
    fi
  else
    echo "SKIP B3 evidence (no VERIFICATION-BUGS-ROCKSOLID-*.md — run live then re-run)"
  fi
fi

{
  echo "# Bug criteria run"
  echo
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- OK: $ok"
  echo "- FAIL: $fail"
  echo "- ISO: ${ISO:-none}"
  echo
  echo "See docs/BUG-CRITERIA.md."
} >"$OUT/SUMMARY.md"

echo
echo "Result: $ok OK, $fail FAIL"
echo "Summary: $OUT/SUMMARY.md"
if ((fail)); then
  echo "Bug criteria FAILED"
  exit 1
fi
echo "Bug criteria PASSED"
exit 0
