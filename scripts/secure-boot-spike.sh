#!/usr/bin/env bash
# Secure Boot QEMU spike helper (Alpha 0.3 R2) — does NOT sign production ISOs.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/secure-boot-spike"
ISO="${1:-}"
[[ -z "$ISO" ]] && ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
mkdir -p "$OUT"

cat >"$OUT/README.md" <<EOF
# Secure Boot spike notes

Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Goal

Boot Etheris ISO (or installed disk) under OVMF with Secure Boot **enabled**,
document failures, optionally enroll test keys with \`sbctl\`.

## Host prerequisites

- \`edk2-ovmf\` / \`OVMF_CODE.secboot.fd\` (or equivalent SB-capable firmware)
- Optional: \`sbctl\`, \`sbsigntools\` inside a disposable guest

## Manual steps

1. Locate SB-capable firmware, e.g.:
   - \`/usr/share/edk2/x64/OVMF_CODE.secboot.fd\`
   - \`/usr/share/OVMF/OVMF_CODE.secboot.fd\`
2. Create fresh vars store from \`OVMF_VARS.secboot.fd\` / \`OVMF_VARS.fd\`.
3. QEMU:
   \`\`\`bash
   qemu-system-x86_64 -enable-kvm -m 2048 \\
     -drive if=pflash,format=raw,readonly=on,file=OVMF_CODE.secboot.fd \\
     -drive if=pflash,format=raw,file=OVMF_VARS_TEST.fd \\
     -cdrom ${ISO:-etheris.iso} -boot d
   \`\`\`
4. Expect: unsigned systemd-boot/kernel **rejected** until keys enrolled.
5. Record outcome in this directory as \`RESULT.md\`.

## Current product stance

See \`docs/SECURE-BOOT-PLAN.md\`: Alpha does **not** claim SB support.
EOF

# Probe firmware presence
{
  echo "# Probe $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo
  for f in \
    /usr/share/edk2/x64/OVMF_CODE.secboot.fd \
    /usr/share/edk2/ovmf/OVMF_CODE.secboot.fd \
    /usr/share/OVMF/OVMF_CODE.secboot.fd \
    /usr/share/edk2-ovmf/x64/OVMF_CODE.secboot.fd
  do
    if [[ -f "$f" ]]; then
      echo "- FOUND: \`$f\`"
    fi
  done
  echo
  echo "ISO under test: \`${ISO:-none}\`"
} | tee "$OUT/PROBE.md"

echo "Wrote $OUT/README.md and PROBE.md"
echo "Next: follow README manual QEMU steps; fill RESULT.md"
