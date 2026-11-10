# Milestone 1 results — 2026-11-08

## Build
- **Status:** SUCCESS (verified)
- **ISO:** `out/ethereal-2026.11.07-x86_64.iso` (1.6 GiB)
- **SHA256:** `a72bd3c67be157c15566499a1f7eb734e3a66cb958aa0b78974a5df34663cabb`
- **Log:** `out/build-20261107T223740Z.log`
- **Method:** Podman Arch container + mkarchiso + rootless mount-wrapper

## QEMU smoke test (no real disks)
- **Status:** SUCCESS (verified via serial console)
- **Method:** KVM QEMU, direct kernel+initrd from ISO + `-cdrom` ISO, `console=ttyS0`
- **Params:** `archisobasedir=ethereal archisosearchuuid=2026-11-07-22-37-40-00`
- **Evidence in** `out/qemu-smoke/serial-direct2.log`:
  - `Welcome to Ethereal OS 0.1.0-alpha`
  - archiso mounted `/dev/sr0` and airootfs loop
  - NetworkManager started
  - `Ethereal OS authentication setup` finished OK
- **Note:** live session hit interactive `systemd-firstboot` timezone prompt (masked in profile for next ISO rebuild). Graphical greetd/Sway not yet verified in this headless run.

## Not verified yet
- Full UEFI firmware menu boot path (systemd-boot) in GUI QEMU
- greetd / tuigreet / Sway graphical session
- Installer end-to-end
- Idle RAM measurement
- Audio

## Fedora host
- No Fedora packages/bootloader/partitions modified
- No physical disks written
