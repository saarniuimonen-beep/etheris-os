# Getting started with Etheris OS

**Audience:** anyone trying the public **0.1.0-alpha** build (VM or spare disk).  
**Honesty:** this is an experimental alpha. Do **not** wipe your only computer without a backup.

## 1. Get the image

1. Open the latest [GitHub Release](https://github.com/saarniuimonen-beep/etheris-os/releases).
2. Download `SHA256SUMS` and the ISO when a download mirror is linked (ISO is ~2.2 GiB — larger than GitHub’s file limit, so the release always ships checksums + build instructions).
3. Or build locally:

```bash
git clone https://github.com/saarniuimonen-beep/etheris-os.git
cd etheris-os
./build.sh    # needs Podman, ~12–20 GB free, ~8–15 minutes
```

Output: `out/etheris-YYYY.MM.DD-x86_64.iso` + `out/SHA256SUMS`.

Verify:

```bash
sha256sum -c SHA256SUMS --ignore-missing
```

## 2. Try in a VM first (recommended)

- **Virt-manager / QEMU:** UEFI or BIOS, ≥4 GiB RAM, virtio disk + virtio GPU is fine for desktop smoke.
- Boot the ISO. Login: user `etheris` / password `etheris`.
- Session: **Etheris (Sway)**.

Quick checks after login:

```bash
etheris doctor
etheris status
nmcli device status    # network
wpctl status           # audio (PipeWire)
```

## 3. Install to disk (optional)

```bash
sudo etheris-installer
```

- UEFI + systemd-boot, ext4 or btrfs.
- Optional LUKS: see installer help / `ETHERIS_INSTALL_*` flags.
- Gaming stack is **opt-in** on disk (`ETHERIS_INSTALL_GAMING=1`); the live ISO may already include Steam for try-before-install.

After reboot, create your user password carefully and run `etheris doctor` again.

## 4. Day-one tips

| Task | How |
|------|-----|
| Menu / Control Center | Super+A |
| Launcher | Super+D or Super+Space |
| Network | Waybar · Menu → Network · nm-applet · `nmtui` |
| Bluetooth | Waybar **bt** · Menu → Bluetooth · Blueman |
| Sound | Waybar volume · `pavucontrol` · media keys |
| Updates | `sudo etheris-update channel stable` then `sudo etheris-update upgrade` |
| Themes | `etheris themes` |

## 5. What we claim vs what we don’t

**Claimed (QEMU / tree seals):** live boot, greeter, desktop, installer path, security defaults, bug/game-ready *stack* seals.  

**Not claimed yet:** physical GPU certification, every Wi‑Fi/BT adapter, Secure Boot, stable “production” support.

Report issues: [GitHub Issues](https://github.com/saarniuimonen-beep/etheris-os/issues).  
Site: https://saarniuimonen-beep.github.io/etheris-website/

## Related

- [GAMING.md](GAMING.md) · [HARDWARE.md](HARDWARE.md) · [SECURITY.md](SECURITY.md)
- [RELEASE-CHECKLIST.md](RELEASE-CHECKLIST.md) · [GAME-READY-CRITERIA.md](GAME-READY-CRITERIA.md)
