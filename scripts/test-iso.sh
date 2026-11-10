#!/usr/bin/env bash
# UEFI QEMU smoke-boot of Etheris ISO. Does NOT touch real disks.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi
[[ -n "$ISO" && -f "$ISO" ]] || { echo "No ISO found. Pass path or build first."; exit 1; }

CODE=/usr/share/edk2/ovmf/OVMF_CODE.fd
VARS_SRC=/usr/share/OVMF/OVMF_VARS.fd
[[ -f "$CODE" ]] || CODE=/usr/share/OVMF/OVMF_CODE.fd
[[ -f "$VARS_SRC" ]] || { echo "OVMF vars missing"; exit 1; }

WORKDIR="$ROOT/out/qemu-smoke"
mkdir -p "$WORKDIR"
VARS="$WORKDIR/OVMF_VARS.fd"
cp -f "$VARS_SRC" "$VARS"

echo "ISO: $ISO"
echo "UEFI CODE: $CODE"
echo "Starting QEMU (gtk). Close window or Ctrl-C to stop."
echo "This uses only the ISO + ephemeral OVMF vars under out/qemu-smoke/."

exec qemu-system-x86_64 \
  -enable-kvm \
  -machine q35,accel=kvm \
  -cpu host \
  -m 2048 \
  -smp 2 \
  -drive if=pflash,format=raw,readonly=on,file="$CODE" \
  -drive if=pflash,format=raw,file="$VARS" \
  -cdrom "$ISO" \
  -boot d \
  -device virtio-vga \
  -device qemu-xhci \
  -device usb-tablet \
  -netdev user,id=net0 \
  -device virtio-net-pci,netdev=net0 \
  -display gtk
