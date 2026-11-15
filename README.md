# Etheris OS

A lightweight Arch-based Wayland distribution. The default session is **Sway** with the Etheris desktop (themes, panel, launcher, and login screen).

Version: see `VERSION` (currently **0.1.0-alpha**).

## Goals

- Keep idle memory low (about **500 MB** target for a basic Etheris/Sway session — without cutting security or useful features)
- Easy to customize (`~/.config/sway`, `etheris themes`)
- Simple USB install (`etheris-installer`)
- CPU/GPU tools: **Performance Manager** (`etheris-perf`) and **GPU Manager** (`etheris-gpu`)
- Update **channels**: `stable` (default, packages about **14 days** behind Arch Archive) · `rc` · `edge`
- Updates via `etheris-update` (no custom mirrors yet)
- Optional AUR helper (`etheris-aur`) that follows the same delayed-package rule — user-maintained, not official Etheris packages

## See also

- [SESSION-LOG.md](SESSION-LOG.md) — **start here** to see latest progress
- [docs/AUDIT-INDEX.md](docs/AUDIT-INDEX.md) — full project / security / desktop audit pack (2026-11-15)
- [docs/ROADMAP.md](docs/ROADMAP.md) — short product roadmap
- [docs/DEVELOPMENT-ROADMAP.md](docs/DEVELOPMENT-ROADMAP.md) — prioritized development plan
- [docs/RENAME-VERIFICATION.md](docs/RENAME-VERIFICATION.md) — Ethereal → Etheris rename check
- [docs/PERFORMANCE-MANAGER.md](docs/PERFORMANCE-MANAGER.md) — performance / GPU managers
- [MASTER-CHECKLIST.md](MASTER-CHECKLIST.md) — phase status
- [docs/HARDWARE.md](docs/HARDWARE.md) — CPU/GPU detection and drivers
- [docs/GAMING.md](docs/GAMING.md) — Steam / Proton / gaming
- [docs/LOGIN.md](docs/LOGIN.md) — graphical login (ReGreet)
- [docs/FLOW.md](docs/FLOW.md) — design tokens and themes
- Live login: `etheris` / `etheris`

```bash
etheris hardware          # CPU/GPU report
etheris drivers status    # driver recommendations
etheris performance       # profiles / metrics
etheris gpu               # GPU Manager summary
etheris gaming            # Steam/Proton notes
```

## Build ISO (from Fedora via Podman)

```bash
cd ~/etheris-os
chmod +x build.sh scripts/*.sh
./build.sh
```

Needs about 12–20 GB free. Output: `out/etheris-*.iso` + `SHA256SUMS`.

Write to USB:

```bash
sudo dd if=out/etheris-*.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Security & privacy

Safe defaults (firewall on, no telemetry, SSH off unless you enable it). See [docs/SECURITY.md](docs/SECURITY.md).

```bash
etheris-security status
sudo etheris-security firewall
etheris-security audit
```

## Update channels

See [docs/CHANNELS.md](docs/CHANNELS.md). Long-term 4-year support is **not planned yet**: [docs/RELEASE-POLICY.md](docs/RELEASE-POLICY.md).

```bash
etheris-update status
sudo etheris-update channel stable|rc|edge
sudo etheris-update upgrade
```

## First boot

1. Graphical login via **greetd + ReGreet** (text login available as fallback)
2. Live user `etheris` / password `etheris`
3. Session: **Etheris (Sway)**
4. Install: `sudo etheris-installer`

Shortcuts: **Super+Return** terminal · **Super+D** / **Super+Space** launcher · **Super+A** Control Center · **Super+,** Settings · **Super+Shift+E** power menu

## Current status

**Latest local ISO:** `etheris-2026.11.15-x86_64.iso`  
SHA256: `eb677f92d3d6a336b1eca3f6b8f64de4e649badabf22c17366468c3a4b05dfd6`  
(see `SESSION-LOG.md` / `out/SHA256SUMS`).

**Verified in QEMU (2026-11-15):** stability · reliability · maturity STRICT · security (22 OK) · bug criteria (menu clip fixed) · idle RAM rock-solid (~169 MiB with browser preload off) · optional LUKS install + unlock E2E.

Performance Manager is in the tree; real GPU testing still needs physical hardware.  
Track progress in `MASTER-CHECKLIST.md` and [docs/IMPLEMENTATION-STATUS.md](docs/IMPLEMENTATION-STATUS.md).  
Release checklist: [docs/RELEASE-CHECKLIST.md](docs/RELEASE-CHECKLIST.md).

**Included today:** Sway desktop + themed login (ReGreet), Menu / launcher polish, installer (ext4/btrfs + optional LUKS), first-boot setup (text UI), Software Center, doctor, update channels, security defaults.  
**Not ready yet:** extra desktops (Hyprland/KDE/XFCE), Secure Boot, read-only “immutable” installs, public ISO hosting / signed releases.

## Quick checks (no ISO needed)

```bash
./scripts/check-profile.sh
./scripts/test-p0-security.sh
```

## Immutable installs

Planned only — see [docs/IMMUTABLE.md](docs/IMMUTABLE.md). Current installs can be changed like a normal Linux install.
