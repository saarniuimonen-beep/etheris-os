#!/usr/bin/env bash
# Boot Etheris ISO under OVMF Secure Boot firmware; capture unsigned-boot behavior.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/secure-boot-spike"
ISO="${1:-$ROOT/out/etheris-2026.11.15-x86_64.iso}"
CODE=/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd
VARS_TMPL=/usr/share/edk2/x64/OVMF_VARS.4m.fd
VARS="$OUT/OVMF_VARS.secboot-test.fd"

mkdir -p "$OUT"
[[ -f "$CODE" ]] || { echo "Missing $CODE"; exit 1; }
[[ -f "$ISO" ]] || { echo "Missing ISO $ISO"; exit 1; }
cp -f "$VARS_TMPL" "$VARS"

SERIAL="$OUT/serial.log"
QEMU_LOG="$OUT/qemu.log"
rm -f "$SERIAL" "$QEMU_LOG"

echo "Secure Boot QEMU probe (90s headless)…"
echo "  CODE=$CODE"
echo "  ISO=$ISO"

set +e
timeout --signal=TERM --kill-after=10 90 \
  qemu-system-x86_64 \
    -enable-kvm \
    -machine q35,accel=kvm,smm=on \
    -cpu host \
    -m 2048 \
    -smp 2 \
    -drive if=pflash,format=raw,readonly=on,file="$CODE" \
    -drive if=pflash,format=raw,file="$VARS" \
    -cdrom "$ISO" \
    -boot order=d \
    -display none \
    -serial file:"$SERIAL" \
    -device virtio-vga \
    >"$QEMU_LOG" 2>&1
rc=$?
set -e

{
  echo "# Secure Boot QEMU probe result"
  echo
  echo "- When: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- Firmware: \`$CODE\`"
  echo "- ISO: \`$ISO\`"
  echo "- QEMU exit: $rc (124 = timeout window ended)"
  echo
  echo "## Observation"
  if grep -qiE 'Secure Boot|Security Violation|Access Denied|failed to load|Verification failed|image failed' "$SERIAL" "$QEMU_LOG" 2>/dev/null; then
    echo "- Firmware/security messages seen (unsigned boot likely blocked or warned)."
  elif grep -qiE 'Linux version|Welcome to|systemd' "$SERIAL" 2>/dev/null; then
    echo "- Guest Linux messages appeared — SB may be off/unenforced with these vars, or ISO path bypassed."
  else
    echo "- No clear kernel serial; typical for unsigned images under SB without console=."
  fi
  echo
  echo "## Stance"
  echo "- Etheris does **not** ship enrolled MOK/db keys."
  echo "- Product claim remains: Secure Boot **unsupported** until signed artifacts + hardware matrix."
  echo
  echo "## Serial tail"
  echo '```'
  tail -40 "$SERIAL" 2>/dev/null || echo "(empty)"
  echo '```'
} | tee "$OUT/RESULT.md"

echo "Wrote $OUT/RESULT.md"
