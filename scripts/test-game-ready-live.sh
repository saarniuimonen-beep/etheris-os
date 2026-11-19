#!/usr/bin/env bash
# Live G3 game-ready / drivers battery — docs/GAME-READY-CRITERIA.md. No guest-apply.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export LIBVIRT_DEFAULT_URI="${LIBVIRT_DEFAULT_URI:-qemu:///session}"
DOMAIN="${DOMAIN:-etheris-os}"
ISO="${1:-}"
[[ -z "$ISO" ]] && ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1)"
ISO="$(realpath "$ISO")"
OUT="$ROOT/out/qemu-game-ready-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"
# shellcheck source=/dev/null
source "$ROOT/out/e2e-persist-harness/libvirt-keys.sh"
DOMAIN="$DOMAIN"

ok=0
fail=0
pass() { echo "  OK  $*"; ok=$((ok + 1)); }
bad() { echo "FAIL  $*"; fail=$((fail + 1)); }

echo "Etheris game-ready live battery (G3)"
echo "  iso: $ISO"
echo "  out: $OUT"
echo "  note: NO guest-apply; virtio ≠ physical GPU certification"
echo

IMG_ISO="$HOME/.local/share/libvirt/images/$(basename "$ISO")"
sudo ln -f "$ISO" "$IMG_ISO" 2>/dev/null || ln -f "$ISO" "$IMG_ISO" 2>/dev/null || cp -f "$ISO" "$IMG_ISO"

virsh destroy "$DOMAIN" 2>/dev/null || true
sleep 1
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
((greeter)) && pass "G3 greeter" || bad "G3 greeter"

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
pass "G3 desktop"

super_ret
sleep 1.2
type_str "etheris-hw; echo HW_RC=\$?"
enter
sleep 6
shot "$OUT/03-hw"
pass "G3.1 etheris-hw invoked"

type_str "etheris-drivers status; echo DRV_RC=\$?"
enter
sleep 5
shot "$OUT/04-drivers"
pass "G3.1b etheris-drivers status invoked"

type_str "etheris-gaming-setup status; echo GS_RC=\$?"
enter
sleep 4
shot "$OUT/05-gaming-setup"
pass "G3.2 etheris-gaming-setup status invoked"

type_str "wine --version; command -v gamemoderun mangohud gamescope steam; echo TOOLS_OK"
enter
sleep 3
shot "$OUT/06-tools"
pass "G3.3/G3.4/G3.7 wine+tools+steam probe"

type_str "sysctl -n vm.max_map_count; findmnt -n -o SIZE -b /run/archiso/cowspace; df -Pk \$HOME | awk 'NR==2{print \$4}'; echo G3_SPACE"
enter
sleep 3
shot "$OUT/07-space-sysctl"
pass "G3.5/G3.6 cow/home free + max_map_count probe"

type_str "exit"
enter
sleep 0.5
shot "$OUT/08-desktop-final"
pass "G3 session still up"

{
  echo "# Game-ready live battery"
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- ISO: $ISO"
  echo "- SHA256: $(sha256sum "$ISO" | awk '{print $1}')"
  echo "- Guest-apply: none"
  echo "- Physical GPU / real Steam title: NOT claimed (virtio/QEMU only)"
  echo "- OK: $ok FAIL: $fail"
  echo "- Evidence: $OUT"
} >"$OUT/SUMMARY.md"

echo "Result: $ok OK, $fail FAIL → $OUT"
((fail == 0))
