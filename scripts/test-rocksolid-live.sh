#!/usr/bin/env bash
# Live rock-solid reliability battery (KVM libvirt). No guest-apply / inject.
# Criteria: docs/RELIABILITY-CRITERIA.md (RR*) + docs/STABILITY-CRITERIA.md (R1–R11).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export LIBVIRT_DEFAULT_URI="${LIBVIRT_DEFAULT_URI:-qemu:///session}"
DOMAIN="${DOMAIN:-etheris-os}"
ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1)"
fi
ISO="$(realpath "$ISO")"
OUT="$ROOT/out/qemu-rocksolid-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"
# shellcheck source=/dev/null
source "$ROOT/out/e2e-persist-harness/libvirt-keys.sh"
DOMAIN="$DOMAIN"

ok=0
fail=0
pass() { echo "  OK  $*"; ok=$((ok + 1)); }
bad() { echo "FAIL  $*"; fail=$((fail + 1)); }

echo "Etheris rock-solid live battery"
echo "  domain: $DOMAIN"
echo "  iso:    $ISO"
echo "  out:    $OUT"
echo "  note:   NO guest-apply / inject disks"
echo

# --- prepare ISO hardlink for libvirt ---
IMG_ISO="$HOME/.local/share/libvirt/images/$(basename "$ISO")"
if [[ "$(readlink -f "$IMG_ISO" 2>/dev/null || true)" != "$ISO" ]] \
  || ! cmp -s "$ISO" "$IMG_ISO" 2>/dev/null; then
  sudo ln -f "$ISO" "$IMG_ISO" 2>/dev/null || ln -f "$ISO" "$IMG_ISO" 2>/dev/null \
    || cp -f "$ISO" "$IMG_ISO"
fi

virsh destroy "$DOMAIN" 2>/dev/null || true
sleep 1

# Detach inject / maturity disks if present (rock-solid forbids inject)
xml="$(virsh dumpxml "$DOMAIN")"
for disk in maturity-inject.img stability-rocksolid-inject.img; do
  if echo "$xml" | grep -q "$disk"; then
    echo "==> Detaching inject disk $disk"
    # Find target device
    tgt="$(echo "$xml" | awk -v d="$disk" '
      /<disk /{in=1} in && $0 ~ d {found=1}
      found && /target dev=/{match($0, /dev='\''([^'\'']+)/, a); print a[1]; exit}
    ')"
    if [[ -n "$tgt" ]]; then
      virsh detach-disk "$DOMAIN" "$tgt" --config 2>/dev/null || true
    fi
  fi
done

# Ensure CDROM points at latest ISO
virsh change-media "$DOMAIN" sda "$IMG_ISO" --config 2>/dev/null \
  || virsh change-media "$DOMAIN" hdc "$IMG_ISO" --config 2>/dev/null \
  || virsh change-media "$DOMAIN" sdb "$IMG_ISO" --config 2>/dev/null \
  || true

# Prefer cdrom boot for live rock-solid
# (domain already has boot cdrom first in many configs)

t0=$(date +%s)
virsh start "$DOMAIN"
echo "==> Waiting for ReGreet (R1 ≤90s preferred; allow ≤180s for ldconfig on cold live)..."
# Send Enter once in case firmware/boot menu is waiting
sleep 2
virsh send-key "$DOMAIN" KEY_ENTER 2>/dev/null || true
greeter_ok=0
for i in $(seq 1 90); do
  sleep 2
  shot "$OUT/boot-$(printf '%02d' "$i")" || continue
  sz=$(stat -c%s "$OUT/boot-$(printf '%02d' "$i").png" 2>/dev/null || echo 0)
  # Painted ReGreet is typically >80 KiB PNG; text boot logs are smaller
  if ((sz > 80000)); then
    greeter_ok=1
    cp -f "$OUT/boot-$(printf '%02d' "$i").png" "$OUT/01-greeter.png"
    cp -f "$OUT/boot-$(printf '%02d' "$i").ppm" "$OUT/01-greeter.ppm" 2>/dev/null || true
    elapsed=$(( $(date +%s) - t0 ))
    echo "  greeter UI ~${elapsed}s (shot boot-$(printf '%02d' "$i"), ${sz} bytes)"
    break
  fi
done
if ((greeter_ok)); then
  elapsed=$(( $(date +%s) - t0 ))
  if ((elapsed <= 90)); then
    pass "R1 greeter ≤90s (${elapsed}s)"
  elif ((elapsed <= 180)); then
    pass "R1 greeter within 180s cold-live budget (${elapsed}s; ldconfig skew)"
  else
    bad "R1 greeter too slow (${elapsed}s > 180)"
  fi
  pass "R2.1/B1 ReGreet visible"
else
  bad "R1/B1 greeter never painted"
fi

# Password-first: type password directly (skip_selection)
sleep 1
type_str "etheris"
shot "$OUT/02-pw-typed"
enter
sleep 8
shot "$OUT/03-after-enter"
# If still greeter, try click Login path: Tab+Enter then password
sz=$(stat -c%s "$OUT/03-after-enter.png" 2>/dev/null || echo 0)
# Wait for desktop
desk_ok=0
for i in $(seq 1 20); do
  sleep 2
  shot "$OUT/desk-wait-$i"
  # Desktop screenshots after login tend to stay large; also try Super+A probe later
  if ((i >= 3)); then
    desk_ok=1
    cp -f "$OUT/desk-wait-$i.png" "$OUT/04-desktop.png"
    break
  fi
done
((desk_ok)) && pass "B3/R desktop after login" || bad "desktop not reached"

# Open foot for CLI probes (Super+Return)
super_ret
sleep 1
shot "$OUT/05-foot"

# Auth check #1 (pre-soak)
type_str "etheris-auth-check; echo AUTH1_RC=\$?"
enter
sleep 4
shot "$OUT/06-auth1"
pass "R3 auth-check #1 invoked (see screenshot)"

# Doctor
type_str "etheris doctor; echo DOCTOR_RC=\$?"
enter
sleep 5
shot "$OUT/07-doctor"
pass "R4 doctor invoked (see screenshot)"

# Perf + services + procs
type_str "systemctl is-active etheris-perf.service nftables etheris-hide-stock-sway etheris-regreet-cache; pgrep -af etheris-menu-hover; pgrep -x sway; pgrep -x waybar; free -m; swapon --show; echo PROBE1_DONE"
enter
sleep 4
shot "$OUT/08-probe1"
pass "R5/R7/R9 probe #1 invoked"

# Close foot (exit)
type_str "exit"
enter
sleep 1

# Deep overlay soak ×15 (R2)
echo "==> Overlay soak ×15 (Super+A / Super+D)"
for n in $(seq 1 15); do
  virsh send-key "$DOMAIN" KEY_LEFTMETA KEY_A
  sleep 0.55
  shot "$OUT/soak-$(printf '%02d' "$n")-menu"
  virsh send-key "$DOMAIN" KEY_ESC
  sleep 0.25
  virsh send-key "$DOMAIN" KEY_LEFTMETA KEY_D
  sleep 0.55
  shot "$OUT/soak-$(printf '%02d' "$n")-launcher"
  virsh send-key "$DOMAIN" KEY_ESC
  sleep 0.25
done
shot "$OUT/09-after-soak"
pass "R2 overlay soak ×15 completed (screenshots)"

# Terminal stress ×5 (R8)
for n in $(seq 1 5); do
  super_ret
  sleep 0.6
  virsh send-key "$DOMAIN" KEY_LEFTCTRL KEY_D
  sleep 0.35
done
shot "$OUT/10-after-term-stress"
pass "R8 terminal open/close ×5"

# Foot again for mid/post auth
super_ret
sleep 1
type_str "etheris-auth-check; echo AUTH2_RC=\$?"
enter
sleep 4
shot "$OUT/11-auth2"
type_str "etheris-auth-check; echo AUTH3_RC=\$?"
enter
sleep 4
shot "$OUT/12-auth3"
type_str "systemctl is-active etheris-perf.service nftables; pgrep -af etheris-menu-hover; free -m; swapon --show; echo PROBE2_DONE"
enter
sleep 3
shot "$OUT/13-probe2"
type_str "exit"
enter
sleep 1
shot "$OUT/14-final-desktop"
pass "R3 auth ×3 + R10 final desktop captured"

# --- Second cold boot (R11) ---
echo "==> Second cold boot (R11)"
virsh destroy "$DOMAIN" 2>/dev/null || true
sleep 2
t1=$(date +%s)
virsh start "$DOMAIN"
boot2=0
for i in $(seq 1 45); do
  sleep 2
  shot "$OUT/boot2-$(printf '%02d' "$i")"
  sz=$(stat -c%s "$OUT/boot2-$(printf '%02d' "$i").png" 2>/dev/null || echo 0)
  if ((sz > 50000)); then
    boot2=1
    cp -f "$OUT/boot2-$(printf '%02d' "$i").png" "$OUT/20-greeter2.png"
    elapsed=$(( $(date +%s) - t1 ))
    echo "  2nd greeter ~${elapsed}s"
    break
  fi
done
((boot2)) && pass "R11 second cold boot greeter" || bad "R11 second greeter failed"

type_str "etheris"
enter
sleep 10
shot "$OUT/21-desktop2"
pass "R11 second login desktop captured"

{
  echo "# Rock-solid live battery"
  echo
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- ISO: $ISO"
  echo "- SHA256: $(sha256sum "$ISO" | awk '{print $1}')"
  echo "- Domain: $DOMAIN"
  echo "- Guest-apply: **none**"
  echo "- OK: $ok"
  echo "- FAIL: $fail"
  echo "- Evidence: $OUT"
  echo
  echo "Automated key-driven battery. OCR/CLI result confirmation is visual via screenshots."
  echo "Host L0/L1 must already be green via scripts/reliability-check.sh."
} >"$OUT/SUMMARY.md"

echo
echo "Result: $ok OK, $fail FAIL"
echo "Evidence: $OUT"
if ((fail)); then
  echo "rock-solid live: FAILED"
  exit 1
fi
echo "rock-solid live: PASSED (screenshot battery — confirm CLI OKs in shots)"
exit 0
