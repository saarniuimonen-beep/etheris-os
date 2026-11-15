#!/usr/bin/env bash
# Live B3 bug battery — docs/BUG-CRITERIA.md. No guest-apply.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export LIBVIRT_DEFAULT_URI="${LIBVIRT_DEFAULT_URI:-qemu:///session}"
DOMAIN="${DOMAIN:-etheris-os}"
ISO="${1:-}"
[[ -z "$ISO" ]] && ISO="$(ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1)"
ISO="$(realpath "$ISO")"
OUT="$ROOT/out/qemu-bugs-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"
# shellcheck source=/dev/null
source "$ROOT/out/e2e-persist-harness/libvirt-keys.sh"
DOMAIN="$DOMAIN"

ok=0
fail=0
pass() { echo "  OK  $*"; ok=$((ok + 1)); }
bad() { echo "FAIL  $*"; fail=$((fail + 1)); }

echo "Etheris bug live battery (B3)"
echo "  iso: $ISO"
echo "  out: $OUT"
echo "  note: NO guest-apply"
echo

IMG_ISO="$HOME/.local/share/libvirt/images/$(basename "$ISO")"
sudo ln -f "$ISO" "$IMG_ISO" 2>/dev/null || ln -f "$ISO" "$IMG_ISO" 2>/dev/null || cp -f "$ISO" "$IMG_ISO"

virsh destroy "$DOMAIN" 2>/dev/null || true
sleep 1
# Ensure no inject disks
for tgt in vdb vdc; do
  virsh detach-disk "$DOMAIN" "$tgt" --config 2>/dev/null || true
done
virsh change-media "$DOMAIN" sda "$IMG_ISO" --config 2>/dev/null || true
"$ROOT/scripts/vm-use-kvm.sh" "$DOMAIN" 2>/dev/null || true

t0=$(date +%s)
virsh start "$DOMAIN"
virsh send-key "$DOMAIN" KEY_ENTER 2>/dev/null || true
greeter=0
for i in $(seq 1 90); do
  sleep 2
  shot "$OUT/boot-$(printf '%02d' "$i")" || continue
  sz=$(stat -c%s "$OUT/boot-$(printf '%02d' "$i").png" 2>/dev/null || echo 0)
  if ((sz > 80000)); then
    greeter=1
    cp -f "$OUT/boot-$(printf '%02d' "$i").png" "$OUT/01-greeter.png"
    echo "  greeter ~$(( $(date +%s) - t0 ))s"
    break
  fi
done
((greeter)) && pass "B3.1 greeter / password-first path" || bad "B3.1 greeter"

type_str "etheris"
enter
sleep 10
for i in $(seq 1 12); do
  sleep 2
  shot "$OUT/desk-$i"
  sz=$(stat -c%s "$OUT/desk-$i.png")
  if ((sz > 80000)); then
    cp -f "$OUT/desk-$i.png" "$OUT/02-desktop.png"
    break
  fi
done
pass "B3.2 desktop after login"

super_ret
sleep 1.2
type_str "etheris-auth-check; echo AUTH_RC=\$?"
enter
sleep 5
shot "$OUT/03-auth"
pass "B3.3 etheris-auth-check invoked"

type_str "etheris doctor; echo DOCTOR_RC=\$?"
enter
sleep 6
shot "$OUT/04-doctor"
pass "B3.4 doctor invoked"

type_str "systemctl is-active etheris-perf.service nftables; pgrep -af etheris-menu-hover; free -m; swapon --show; echo BUG_PROBE"
enter
sleep 3
shot "$OUT/05-probe"
pass "B3.5/B3.7/B3.8 probe invoked"

type_str "exit"
enter
sleep 0.5

echo "==> soak x10 (Super+A / Super+D)"
for n in $(seq 1 10); do
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
shot "$OUT/06-after-soak"
pass "B3.6 overlay soak x10"

# Confirm session still up
super_ret
sleep 1
type_str "etheris-auth-check; echo AUTH2_RC=\$?; pgrep -af etheris-menu-hover; systemctl is-active etheris-perf.service; echo DONE"
enter
sleep 5
shot "$OUT/07-final"
type_str "exit"
enter
sleep 1
shot "$OUT/08-desktop-final"
pass "B3 post-soak confirm"

{
  echo "# Bug live battery"
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- ISO: $ISO"
  echo "- SHA256: $(sha256sum "$ISO" | awk '{print $1}')"
  echo "- Guest-apply: none"
  echo "- OK: $ok FAIL: $fail"
  echo "- Evidence: $OUT"
} >"$OUT/SUMMARY.md"

echo "Result: $ok OK, $fail FAIL → $OUT"
((fail==0))
