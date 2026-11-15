#!/usr/bin/env bash
# Automated live install E2E via qemu:///session (no virt-install required).
# Default: lean install. Pass --luks for encrypted root E2E.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export LIBVIRT_DEFAULT_URI=qemu:///session
# shellcheck source=/dev/null
# Import helpers but NEVER inherit DOMAIN=etheris-os from the harness.
DOMAIN_SAVE="${DOMAIN:-}"
# shellcheck disable=SC2034
DOMAIN=etheris-e2e
source "$ROOT/out/e2e-persist-harness/libvirt-keys.sh"
DOMAIN="etheris-e2e"
[[ -n "$DOMAIN_SAVE" && "$DOMAIN_SAVE" != "etheris-os" ]] && DOMAIN="$DOMAIN_SAVE"

LUKS=0
[[ "${1:-}" == "--luks" ]] && LUKS=1
ISO="${ISO:-$HOME/.local/share/libvirt/images/etheris-2026.11.15-x86_64.iso}"
DISK="${DISK:-$HOME/.local/share/libvirt/images/etheris-e2e-20261115.qcow2}"
OUT="$ROOT/out/e2e-install-$(date -u +%Y%m%dT%H%M%SZ)"
NVRAM="$HOME/.config/libvirt/qemu/nvram/${DOMAIN}_VARS.fd"
CODE=/usr/share/edk2/x64/OVMF_CODE.4m.fd
VARS_TMPL=/usr/share/edk2/x64/OVMF_VARS.4m.fd

if [[ "$DOMAIN" == "etheris-os" ]]; then
  echo "Refusing to use DOMAIN=etheris-os (would destroy the main guest)." >&2
  exit 2
fi

mkdir -p "$OUT" "$(dirname "$NVRAM")" "$HOME/.local/share/libvirt/images"
[[ -f "$ISO" ]] || { echo "ISO missing: $ISO"; exit 1; }
# Fresh disk
qemu-img create -f qcow2 "$DISK" 25G >/dev/null
cp -f "$VARS_TMPL" "$NVRAM"

# Destroy previous e2e domain only
virsh destroy "$DOMAIN" 2>/dev/null || true
virsh undefine "$DOMAIN" --nvram 2>/dev/null || true

cat >"$OUT/domain.xml" <<EOF
<domain type='kvm'>
  <name>$DOMAIN</name>
  <memory unit='MiB'>3072</memory>
  <vcpu>2</vcpu>
  <os firmware='efi'>
    <type arch='x86_64' machine='q35'>hvm</type>
    <loader readonly='yes' type='pflash' format='raw'>$CODE</loader>
    <nvram template='$VARS_TMPL' templateFormat='raw' format='raw'>$NVRAM</nvram>
    <boot dev='cdrom'/>
    <boot dev='hd'/>
  </os>
  <features><acpi/><apic/></features>
  <cpu mode='host-passthrough'/>
  <clock offset='utc'/>
  <devices>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='$DISK'/>
      <target dev='vda' bus='virtio'/>
    </disk>
    <disk type='file' device='cdrom'>
      <driver name='qemu' type='raw'/>
      <source file='$ISO'/>
      <target dev='sda' bus='sata'/>
      <readonly/>
    </disk>
    <interface type='user'>
      <model type='virtio'/>
    </interface>
    <graphics type='spice' autoport='yes'/>
    <video><model type='virtio' heads='1'/></video>
    <controller type='usb' model='qemu-xhci'/>
    <input type='tablet' bus='usb'/>
    <console type='pty'/>
  </devices>
</domain>
EOF

virsh define "$OUT/domain.xml"
virsh start "$DOMAIN"
echo "Domain $DOMAIN started. Evidence → $OUT"
sleep 55
DOMAIN="$DOMAIN" shot "$OUT/01-greeter"

# Password-first: type live password
DOMAIN="$DOMAIN" type_str "etheris"
DOMAIN="$DOMAIN" enter
sleep 25
DOMAIN="$DOMAIN" shot "$OUT/02-desktop"

# Open terminal
DOMAIN="$DOMAIN" super_ret
sleep 2

INSTALL_CMD="sudo -n etheris-installer --auto --disk /dev/vda --confirm YES --user demo --password demo --hostname etheris --locale en_US.UTF-8 --timezone UTC --keymap us --fs ext4 --no-reboot"
if [[ "$LUKS" == "1" ]]; then
  INSTALL_CMD+=" --luks --luks-passphrase demo"
fi
# Log to home for later collect
INSTALL_CMD+=" | tee /home/etheris/e2e-install.log; echo E2E_INSTALL_DONE"

DOMAIN="$DOMAIN" type_str "$INSTALL_CMD"
DOMAIN="$DOMAIN" enter

echo "Install started (pacstrap may take 15–40 min). Polling…"
# Poll screenshots every 3 min up to ~50 min
for i in $(seq 1 18); do
  sleep 180
  DOMAIN="$DOMAIN" shot "$OUT/progress-$i"
  # Heuristic: look for done marker via qemu guest - unavailable; use screenshot size growth + time
  echo "  tick $i/18 $(date -u +%H:%M:%SZ)"
done

DOMAIN="$DOMAIN" shot "$OUT/03-after-install"
# Reboot to installed system (HD boot) — change boot order by ejecting? Prefer reset with boot hd
# Cold reset; with empty ESP until install finishes this may still be live
virsh reset "$DOMAIN"
sleep 50
DOMAIN="$DOMAIN" shot "$OUT/04-post-reboot"

# If LUKS, type passphrase at cryptsetup prompt
if [[ "$LUKS" == "1" ]]; then
  sleep 10
  DOMAIN="$DOMAIN" type_str "demo"
  DOMAIN="$DOMAIN" enter
  sleep 40
  DOMAIN="$DOMAIN" shot "$OUT/05-after-luks-unlock"
  # Login as demo/demo
  DOMAIN="$DOMAIN" type_str "demo"
  DOMAIN="$DOMAIN" enter
  sleep 2
  DOMAIN="$DOMAIN" type_str "demo"
  DOMAIN="$DOMAIN" enter
  sleep 25
  DOMAIN="$DOMAIN" shot "$OUT/06-installed-desktop"
fi

cat >"$OUT/README.md" <<EOF
# Install E2E evidence

- Domain: \`$DOMAIN\`
- ISO: \`$ISO\`
- Disk: \`$DISK\`
- LUKS: $LUKS
- Started: $(date -u +%Y-%m-%dT%H:%M:%SZ)

Inspect screenshots progress-* and 03-after-install. Confirm \`E2E_INSTALL_DONE\` in guest \`~/e2e-install.log\` if reachable.
EOF

echo "Done scaffolding. Review $OUT"
