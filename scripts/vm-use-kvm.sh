#!/usr/bin/env bash
# Switch etheris-os libvirt domain to KVM when /dev/kvm is available.
# Requires AMD SVM / Intel VT-x enabled in BIOS (else exits 1 with guidance).
set -euo pipefail

URI="${LIBVIRT_DEFAULT_URI:-qemu:///session}"
DOMAIN="${1:-etheris-os}"

if [[ ! -e /dev/kvm ]]; then
  echo "vm-use-kvm: /dev/kvm missing."
  echo "  Kernel previously reported: SVM disabled (by BIOS) in MSR_VM_CR"
  echo "  Enable AMD SVM / CPU Virtualization in firmware, reboot host, then re-run."
  exit 1
fi

tmp="$(mktemp)"
virsh -c "$URI" dumpxml "$DOMAIN" >"$tmp"
# Prefer KVM domain type + host CPU
sed -i "s/<domain type='qemu'>/<domain type='kvm'>/" "$tmp"
sed -i "s/<domain type=\"qemu\">/<domain type=\"kvm\">/" "$tmp"
# Replace custom qemu64 CPU with host-passthrough when present
python3 - "$tmp" <<'PY'
import re, sys
path = sys.argv[1]
xml = open(path, encoding="utf-8").read()
xml2 = re.sub(
    r"<cpu\b[^>]*>.*?</cpu>",
    "<cpu mode='host-passthrough' check='none'/>",
    xml,
    count=1,
    flags=re.S,
)
open(path, "w", encoding="utf-8").write(xml2)
PY

was_running=0
if virsh -c "$URI" list --name --state-running | grep -qx "$DOMAIN"; then
  was_running=1
  virsh -c "$URI" destroy "$DOMAIN" >/dev/null
fi
virsh -c "$URI" define "$tmp"
rm -f "$tmp"
echo "vm-use-kvm: domain '$DOMAIN' redefined for KVM (host-passthrough)."
if [[ "$was_running" -eq 1 ]]; then
  virsh -c "$URI" start "$DOMAIN"
  echo "vm-use-kvm: restarted $DOMAIN"
fi
