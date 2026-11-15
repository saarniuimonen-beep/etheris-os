#!/usr/bin/env bash
# Dual idle-RAM measurement (IR1+IR2) — NO tree fixes in this script.
# See docs/IDLE-RAM-CRITERIA.md
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export LIBVIRT_DEFAULT_URI="${LIBVIRT_DEFAULT_URI:-qemu:///session}"
DOMAIN="${DOMAIN:-etheris-os}"
ISO="${1:-}"
RUN_LABEL="${2:-A}"
if [[ -z "$ISO" ]]; then
  ISO="$(ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1)"
fi
ISO="$(realpath "$ISO")"
OUT="${ETHERIS_IDLE_OUT:-$ROOT/out/qemu-idle-ram-$(date -u +%Y%m%dT%H%M%SZ)}"
mkdir -p "$OUT"
# shellcheck source=/dev/null
source "$ROOT/out/e2e-persist-harness/libvirt-keys.sh"
DOMAIN="$DOMAIN"

echo "Idle RAM measure run=$RUN_LABEL"
echo "  domain=$DOMAIN iso=$(basename "$ISO") out=$OUT"

IMG_ISO="$HOME/.local/share/libvirt/images/$(basename "$ISO")"
if ! cmp -s "$ISO" "$IMG_ISO" 2>/dev/null; then
  sudo ln -f "$ISO" "$IMG_ISO" 2>/dev/null || ln -f "$ISO" "$IMG_ISO" 2>/dev/null || cp -f "$ISO" "$IMG_ISO"
fi

virsh destroy "$DOMAIN" 2>/dev/null || true
sleep 1
virsh change-media "$DOMAIN" sda "$IMG_ISO" --config 2>/dev/null \
  || virsh change-media "$DOMAIN" hdc "$IMG_ISO" --config 2>/dev/null || true
virsh start "$DOMAIN"
sleep 2
virsh send-key "$DOMAIN" KEY_ENTER 2>/dev/null || true

# Wait greeter
for i in $(seq 1 60); do
  sleep 3
  shot "$OUT/boot-${RUN_LABEL}-$(printf '%02d' "$i")" || true
  sz=$(stat -c%s "$OUT/boot-${RUN_LABEL}-$(printf '%02d' "$i").png" 2>/dev/null || echo 0)
  if ((sz > 80000)); then
    echo "  greeter at ~$((i*3))s"
    break
  fi
done

# Login password-first
sleep 0.5
type_str etheris
enter
sleep 0.3
# Click Login if needed
virsh qemu-monitor-command "$DOMAIN" --hmp "mouse_move $((790*32767/1280)) $((500*32767/800))" >/dev/null
sleep 0.05
virsh qemu-monitor-command "$DOMAIN" --hmp "mouse_button 1" >/dev/null
sleep 0.1
virsh qemu-monitor-command "$DOMAIN" --hmp "mouse_button 0" >/dev/null
sleep 5
shot "$OUT/desktop-${RUN_LABEL}"

# Close any overlays / wait settle
virsh send-key "$DOMAIN" KEY_ESC; sleep 0.2
virsh send-key "$DOMAIN" KEY_ESC; sleep 0.2
echo "  settling 70s..."
sleep 70
shot "$OUT/settled-${RUN_LABEL}"

# US keymap for reliable typing
virsh send-key "$DOMAIN" KEY_LEFTMETA KEY_ENTER
sleep 1.5
type_str "sudo loadkeys us"
enter
sleep 0.8
type_str etheris
enter
sleep 0.5

# Strict idle: do NOT pkill first — warm preload must not be running at settle.
# Short commands (long one-liners drop keys under virsh send-key).
type_str "etheris-browser --status"
enter
sleep 2.5
type_str "etheris ram idle-check"
enter
sleep 3
type_str "free -m"
enter
sleep 1.5
type_str "echo IDLE_DONE"
enter
sleep 2
shot "$OUT/idle-${RUN_LABEL}"

# Key functionality probe (IR4) — after idle read
type_str "etheris-auth-check"
enter
sleep 5
type_str "systemctl is-active nftables"
enter
sleep 1.2
type_str "systemctl is-active NetworkManager"
enter
sleep 1.2
type_str "pgrep -x pipewire"
enter
sleep 1.5
type_str "echo KEY_DONE"
enter
sleep 2
shot "$OUT/keyfunc-${RUN_LABEL}"

# Super+A / Super+D
virsh send-key "$DOMAIN" KEY_LEFTCTRL KEY_C 2>/dev/null || true
sleep 0.2
type_str "exit"
enter
sleep 0.5
virsh send-key "$DOMAIN" KEY_LEFTMETA KEY_A
sleep 1.2
shot "$OUT/menu-${RUN_LABEL}"
virsh send-key "$DOMAIN" KEY_ESC
sleep 0.4
virsh send-key "$DOMAIN" KEY_LEFTMETA KEY_D
sleep 1.2
shot "$OUT/launcher-${RUN_LABEL}"
virsh send-key "$DOMAIN" KEY_ESC
sleep 0.3
shot "$OUT/final-${RUN_LABEL}"

if command -v tesseract >/dev/null; then
  tesseract "$OUT/idle-${RUN_LABEL}.png" stdout 2>/dev/null | tee "$OUT/idle-${RUN_LABEL}.ocr.txt" | head -60
fi
echo "Run $RUN_LABEL evidence: $OUT"
echo "$OUT" >"$OUT/OUTDIR.txt"
