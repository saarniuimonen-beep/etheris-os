#!/usr/bin/env bash
# Etheris reliability gate — Must L0/L1 + rock-solid tree gates.
# Live L2/L3 / RR* still need QEMU evidence (see docs/RELIABILITY-CRITERIA.md).
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

echo "Etheris reliability-check (Must L0/L1 + rock-solid tree)"
echo "  root: $ROOT"
echo "  iso:  ${ISO:-none}"
echo "  criteria: docs/RELIABILITY-CRITERIA.md"
echo

section() { echo; echo "==> $*"; }
AI=profile/etheris/airootfs

section "R0.1 check-profile"
if ./scripts/check-profile.sh >/tmp/etheris-reliability-profile.log 2>&1; then
  pass "check-profile PASSED"
else
  bad "check-profile FAILED"
  tail -20 /tmp/etheris-reliability-profile.log | sed 's/^/  | /'
fi

section "R0.2 P0 security"
if ./scripts/test-p0-security.sh >/tmp/etheris-reliability-p0.log 2>&1; then
  if grep -qE 'Result:.*0 FAIL' /tmp/etheris-reliability-p0.log; then
    p0_ok="$(grep -Eo '[0-9]+ OK' /tmp/etheris-reliability-p0.log | tail -1 | awk '{print $1}')"
    if [[ -n "$p0_ok" && "$p0_ok" -ge 44 ]]; then
      pass "test-p0-security 0 FAIL (${p0_ok} OK ≥44)"
    else
      bad "test-p0-security OK count too low (${p0_ok:-?} < 44)"
    fi
  else
    bad "test-p0-security unexpected summary"
  fi
else
  bad "test-p0-security FAILED"
  tail -20 /tmp/etheris-reliability-p0.log | sed 's/^/  | /'
fi

section "R0.3 bash -n all etheris* shell scripts"
sh_fail=0
while IFS= read -r f; do
  if head -1 "$f" | grep -qE 'python'; then
    continue
  fi
  if ! bash -n "$f" 2>/tmp/etheris-bashn.err; then
    bad "bash -n $(basename "$f")"
    sed 's/^/  | /' /tmp/etheris-bashn.err || true
    sh_fail=1
  fi
done < <(find "$AI/usr/local/bin" -maxdepth 1 -type f -name 'etheris*' | sort)
[[ $sh_fail -eq 0 ]] && pass "bash -n all etheris shell scripts"

section "R0.4 py_compile etheris* Python scripts (no bytecode in airootfs)"
py_fail=0
if command -v python3 >/dev/null 2>&1; then
  # Never write __pycache__ under airootfs (check-profile forbids it).
  export PYTHONDONTWRITEBYTECODE=1
  while IFS= read -r f; do
    head -1 "$f" | grep -qE 'python' || continue
    if ! python3 -c "import py_compile,sys; py_compile.compile(sys.argv[1], doraise=True, cfile='/dev/null')" "$f" \
         2>/tmp/etheris-py.err; then
      # Fallback: compile to a temp cfile outside the tree
      tmpc="$(mktemp /tmp/etheris-pyc.XXXXXX)"
      if ! python3 -c "import py_compile,sys; py_compile.compile(sys.argv[1], cfile=sys.argv[2], doraise=True)" \
           "$f" "$tmpc" 2>/tmp/etheris-py.err; then
        bad "py_compile $(basename "$f")"
        sed 's/^/  | /' /tmp/etheris-py.err || true
        py_fail=1
      fi
      rm -f "$tmpc"
    fi
  done < <(find "$AI/usr/local/bin" -maxdepth 1 -type f -name 'etheris*' | sort)
  # Belt-and-suspenders cleanup if a tool still dropped cache
  find "$AI" -type d -name '__pycache__' -prune -exec rm -rf {} + 2>/dev/null || true
  find "$AI" -name '*.pyc' -delete 2>/dev/null || true
  [[ $py_fail -eq 0 ]] && pass "py_compile all etheris Python scripts"
else
  bad "python3 missing — cannot py_compile"
fi

section "R0.5 / R0.6 keybinds + no legacy regreet cache"
if grep -q 'Super+A' /tmp/etheris-reliability-profile.log \
  && grep -q 'Super+D' /tmp/etheris-reliability-profile.log \
  && grep -q 'Waybar Menu' /tmp/etheris-reliability-profile.log; then
  pass "keybinds Super+A/D + Waybar Menu present"
else
  bad "keybind Must not confirmed in check-profile log"
fi
if [[ -e "$AI/var/lib/regreet/cache.toml" || -e "$AI/var/lib/regreet/cache.json" ]]; then
  bad "legacy ReGreet cache.toml/json present in airootfs"
else
  pass "no legacy ReGreet cache in airootfs"
fi

section "R0.7 stability A-gates (host-only)"
if ETHERIS_STABILITY_HOST_ONLY=1 ./scripts/test-stability.sh ${ISO:+"$ISO"} \
     >/tmp/etheris-reliability-stability.log 2>&1; then
  pass "test-stability A-gates PASSED"
else
  bad "test-stability FAILED"
  tail -30 /tmp/etheris-reliability-stability.log | sed 's/^/  | /'
fi

section "R1.1 validate-iso"
if [[ -n "$ISO" && -f "$ISO" ]]; then
  if ./scripts/validate-iso.sh "$ISO" >/tmp/etheris-reliability-validate.log 2>&1; then
    pass "validate-iso PASSED ($ISO)"
  else
    bad "validate-iso FAILED"
    tail -25 /tmp/etheris-reliability-validate.log | sed 's/^/  | /'
  fi
else
  bad "no ISO to validate (pass path as \$1)"
fi

section "Tree: rock-solid reliability fixes"
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
  && grep -qE 'SKIP|skip' "$AI/usr/local/bin/etheris-security"; then
  pass "etheris-security audit elevates/skips shadow"
else
  bad "etheris-security audit still false-FAILs without sudo"
fi
if grep -q 'is_benign_failed_unit' "$AI/usr/local/bin/etheris-doctor" \
  && grep -qE 'systemd-loop@\*' "$AI/usr/local/bin/etheris-doctor"; then
  pass "etheris-doctor ignores benign systemd-loop@* units"
else
  bad "etheris-doctor missing broad systemd-loop@* filter"
fi
if grep -q 'firefox_visible_on_ws' "$AI/usr/local/bin/etheris-browser"; then
  pass "etheris-browser preload workspace hygiene (RR6)"
else
  bad "etheris-browser missing firefox_visible_on_ws"
fi
if grep -q 'etheris-menu-hover' "$AI/etc/skel/.config/sway/config"; then
  pass "skel starts etheris-menu-hover (RR1)"
else
  bad "skel missing etheris-menu-hover exec"
fi
if grep -q 'var/lib/regreet/state.toml' "$AI/usr/local/bin/etheris-installer" \
  && grep -q 'Etheris (Sway)' "$AI/usr/local/bin/etheris-installer"; then
  pass "installer seeds ReGreet state.toml"
else
  bad "installer missing state.toml seed"
fi
if [[ -f docs/RELIABILITY-CRITERIA.md ]] \
  && grep -q 'ROCK-SOLID' docs/RELIABILITY-CRITERIA.md; then
  pass "docs/RELIABILITY-CRITERIA.md rock-solid criteria present"
else
  bad "docs/RELIABILITY-CRITERIA.md missing rock-solid section"
fi
if [[ -f docs/STABILITY-CRITERIA.md ]] \
  && grep -qE '^\| R2 \|' docs/STABILITY-CRITERIA.md; then
  pass "docs/STABILITY-CRITERIA.md rock-solid R-table present"
else
  bad "docs/STABILITY-CRITERIA.md missing rock-solid R-table"
fi

section "R1.2 ISO squashfs rock-solid markers"
EXTRACT=out/validate-iso/root
if [[ -f "$EXTRACT/usr/local/bin/etheris-doctor" ]]; then
  if grep -qE 'systemd-loop@\*' "$EXTRACT/usr/local/bin/etheris-doctor"; then
    pass "ISO squashfs doctor has systemd-loop@* filter"
  else
    bad "ISO squashfs doctor missing systemd-loop@* filter (rebake required)"
  fi
else
  bad "ISO extract missing etheris-doctor"
fi
if [[ -f "$EXTRACT/usr/local/bin/etheris-perf" ]]; then
  if grep -qE 'HOME:=/root|HOME:-\}' "$EXTRACT/usr/local/bin/etheris-perf"; then
    pass "ISO squashfs etheris-perf HOME-safe"
  else
    bad "ISO squashfs etheris-perf not HOME-safe (rebake required)"
  fi
else
  bad "ISO extract missing etheris-perf (validate-iso must extract it)"
fi
if [[ -f "$EXTRACT/usr/local/bin/etheris-security" ]]; then
  if grep -q 'as_root' "$EXTRACT/usr/local/bin/etheris-security"; then
    pass "ISO squashfs etheris-security as_root"
  else
    bad "ISO squashfs etheris-security missing as_root (rebake)"
  fi
else
  bad "ISO extract missing etheris-security"
fi
if [[ -f "$EXTRACT/usr/local/bin/etheris-browser" ]]; then
  if grep -q 'firefox_visible_on_ws' "$EXTRACT/usr/local/bin/etheris-browser"; then
    pass "ISO squashfs etheris-browser preload hygiene"
  else
    bad "ISO squashfs etheris-browser missing firefox_visible_on_ws (rebake)"
  fi
else
  bad "ISO extract missing etheris-browser"
fi

echo
echo "Summary: $ok OK, $fail FAIL"
echo "Live Must R2.*/R3.* and Rock-solid RR*/R* still require QEMU evidence."
echo "Rock-solid PASS requires bake that ships R1.2 markers + no guest-apply."
if ((fail)); then
  echo "reliability-check: FAILED"
  exit 1
fi
echo "reliability-check: PASSED (L0/L1 + rock-solid tree)"
exit 0
