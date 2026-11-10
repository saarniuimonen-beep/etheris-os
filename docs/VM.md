# Etheris OS — virt-manager test VM (Fedora host)

**VM name:** `etheris-os`  
**Hypervisor:** `qemu:///session` (user session — no system libvirt / no host package changes)  
**ISO:** live CD attached (do not auto-install)  
**Disk:** 30 GiB sparse qcow2 (for later installer tests only)

## What was configured

| Setting | Value |
|---------|--------|
| vCPUs | 2 |
| RAM | 2048 MiB |
| Disk | `~/.local/share/libvirt/images/etheris-os.qcow2` (30 G sparse) |
| Firmware | UEFI (OVMF) |
| Video | virtio |
| Display | SPICE |
| Network | user NAT (SLIRP) |
| CD/DVD | Etheris ISO (hardlinked into libvirt images) |
| GPU passthrough | none |
| Shared Fedora home | none |

## Start / open the graphical window

```bash
# Start the VM if it is shut off
virsh -c qemu:///session start etheris-os

# SPICE window (keyboard/mouse; Alt+Tab back to Fedora)
virt-viewer --connect qemu:///session --attach etheris-os &

# Or use the virt-manager GUI
virt-manager --connect qemu:///session &
```

In virt-manager: double-click **etheris-os** → Open.

## Stop

```bash
# Graceful ACPI poweroff (if the guest responds)
virsh -c qemu:///session shutdown etheris-os

# Force stop
virsh -c qemu:///session destroy etheris-os
```

Closing the virt-viewer window does **not** stop the VM.

## Reopen later

```bash
virsh -c qemu:///session start etheris-os
virt-viewer --connect qemu:///session --attach etheris-os &
```

## Status

```bash
virsh -c qemu:///session list --all
```

## Notes

- Host free space is tight; the 30 G disk is **sparse** (not fully allocated).
- Live ISO may show `systemd-firstboot` on this build — explore past it or skip if possible.
- Installer testing on `vda` only after you approve; the disk is empty until then.
