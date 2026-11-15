#!/usr/bin/env bash
# Headless UEFI smoke-boot of Etheris ISO. No real disks. No Fedora changes.
# Boots ISO for a limited time and records whether the guest kernel starts.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi
[[ -n "$ISO" && -f "$ISO" ]] || { echo "ISO missing: ${ISO:-<none>}. Pass path or build first."; exit 1; }

WORKDIR="$ROOT/out/qemu-smoke"
mkdir -p "$WORKDIR"
# Prefer edk2 4m paths (current Arch/Omarchy); fall back to legacy OVMF layout.
CODE=/usr/share/edk2/x64/OVMF_CODE.4m.fd
VARS_SRC=/usr/share/edk2/x64/OVMF_VARS.4m.fd
[[ -f "$CODE" ]] || CODE=/usr/share/edk2/ovmf/OVMF_CODE.fd
[[ -f "$VARS_SRC" ]] || VARS_SRC=/usr/share/OVMF/OVMF_VARS.fd
[[ -f "$CODE" ]] || CODE=/usr/share/OVMF/OVMF_CODE.fd
[[ -f "$VARS_SRC" ]] || { echo "OVMF VARS missing (tried edk2 4m + OVMF paths)"; exit 1; }
[[ -f "$CODE" ]] || { echo "OVMF CODE missing"; exit 1; }
cp -f "$VARS_SRC" "$WORKDIR/OVMF_VARS.fd"
OVMF_LOG="$WORKDIR/ovmf-debug.log"
SERIAL_LOG="$WORKDIR/serial.log"
QEMU_LOG="$WORKDIR/qemu.log"
rm -f "$OVMF_LOG" "$SERIAL_LOG" "$QEMU_LOG"

echo "Smoke-booting (UEFI, ~90s, headless)…"
echo "  ISO: $ISO"

# Direct kernel boot from ISO contents would need loop mount; instead boot the ISO
# and pass console via QEMU fw_cfg is unreliable. Use OVMF debugcon + guest serial.
set +e
timeout --signal=TERM --kill-after=15 90 \
  qemu-system-x86_64 \
    -enable-kvm \
    -machine q35,accel=kvm \
    -cpu host \
    -m 2048 \
    -smp 2 \
    -drive if=pflash,format=raw,readonly=on,file="$CODE" \
    -drive if=pflash,format=raw,file="$WORKDIR/OVMF_VARS.fd" \
    -cdrom "$ISO" \
    -boot order=d \
    -display none \
    -serial file:"$SERIAL_LOG" \
    -debugcon file:"$OVMF_LOG" -global isa-debugcon.iobase=0x402 \
    -device virtio-vga \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0 \
    -device qemu-xhci -device usb-tablet \
    >"$QEMU_LOG" 2>&1
rc=$?
set -e

echo "QEMU exit/timeout code: $rc (124 = timeout/smoke window ended — expected)"
echo "--- serial log (tail) ---"
tail -80 "$SERIAL_LOG" 2>/dev/null || echo "(empty)"
echo "--- ovmf debug (grep boot) ---"
grep -E 'BdsDxe|Image|Linux|EFI|Error|error' "$OVMF_LOG" 2>/dev/null | tail -40 || echo "(no matches)"

# Heuristics
pass=0
fail=0
if grep -qiE 'Linux version|archiso|INITRD|Run /init|Welcome to|systemd' "$SERIAL_LOG" 2>/dev/null; then
  echo "PASS: guest kernel/userspace messages seen on serial"
  pass=1
elif grep -qiE 'vmlinuz|systemd-boot|Eth?ereal|Arch Linux' "$OVMF_LOG" 2>/dev/null; then
  echo "PARTIAL: firmware loaded a boot entry (kernel serial may be quiet without console=)"
  pass=1
else
  echo "UNCLEAR/FAIL: no clear boot evidence in logs"
  fail=1
fi

# Secondary: try extracting kernel and booting it with ISO as CD for archiso
# (more reliable signal)
echo
echo "==> Secondary: direct UEFI-less kernel boot from ISO (archiso params)"
MNT="$WORKDIR/isomnt"
mkdir -p "$MNT"
if command -v fuseiso >/dev/null 2>&1; then
  fuseiso "$ISO" "$MNT"
elif command -v udisksctl >/dev/null; then
  echo "(skipping loop mount without privileges)"
else
  # try isoinfo extract
  :
fi

if [[ -f "$MNT/etheris/boot/x86_64/vmlinuz-linux" ]]; then
  timeout --signal=TERM --kill-after=10 60 \
    qemu-system-x86_64 \
      -enable-kvm -machine q35,accel=kvm -cpu host -m 2048 -smp 2 \
      -kernel "$MNT/etheris/boot/x86_64/vmlinuz-linux" \
      -initrd "$MNT/etheris/boot/x86_64/initramfs-linux.img" \
      -append "archisobasedir=etheris archisolabel=ETHERIS_202611 console=ttyS0,115200 quiet" \
      -cdrom "$ISO" \
      -boot d \
      -display none \
      -serial file:"$WORKDIR/serial-direct.log" \
      -netdev user,id=net0 -device virtio-net-pci,netdev=net0 \
      >"$WORKDIR/qemu-direct.log" 2>&1 || true
  echo "--- direct serial (tail) ---"
  tail -60 "$WORKDIR/serial-direct.log" 2>/dev/null || true
  if grep -qiE 'Linux version|systemd|etheris|Welcome|login|greetd|Reached target' "$WORKDIR/serial-direct.log" 2>/dev/null; then
    echo "PASS: direct kernel boot shows userspace progress"
    pass=1
    fail=0
  fi
  fusermount -u "$MNT" 2>/dev/null || umount "$MNT" 2>/dev/null || true
fi

echo
if [[ "$pass" -eq 1 && "$fail" -eq 0 ]]; then
  echo "SMOKE RESULT: evidence of successful boot progress (see logs in $WORKDIR)"
  exit 0
fi
echo "SMOKE RESULT: incomplete evidence — open GUI test: ./scripts/test-iso.sh"
exit 1
