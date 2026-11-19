# Etheris OS 0.1.0-alpha — first public development release

**Date:** 2026-11-19  
**Tag:** `v0.1.0-alpha`  
**Channel:** experimental / development

This is the first **public** alpha: source, website, and release metadata are open so people outside the private build loop can try Etheris. It is **not** a stable product release.

## Highlights

- Arch-based live ISO with **Etheris (Sway)** desktop, ReGreet login, themes / Menu / launcher / power menu
- Installer (UEFI, ext4/btrfs, optional LUKS) with lean disk installs by default
- Security defaults: nftables, scoped polkit, no telemetry, live credentials stripped on install
- Update channels: stable (Archive lag) · rc · edge via `etheris-update`
- Software Center, doctor, Performance / GPU managers
- Live gaming stack path (Steam/Proton helpers, GameMode, honesty-limited game-ready seals)
- Audio / network / Bluetooth wiring: PipeWire, NetworkManager+iwd, Blueman, Waybar indicators

## How to get it

1. Release page: https://github.com/saarniuimonen-beep/etheris-os/releases/tag/v0.1.0-alpha  
2. Website: https://saarniuimonen-beep.github.io/etheris-website/pages/download.html  
3. Build from source: `./build.sh` (see [GETTING-STARTED.md](GETTING-STARTED.md))

The ISO is ~2.2 GiB and may be linked from an external mirror when available. GitHub Releases always include **SHA256SUMS** and these notes. Never skip checksum verification.

## Known limits (read before installing)

- Alpha quality — expect bugs; keep backups
- Physical GPU / Wi‑Fi / Bluetooth matrix mostly open
- No Secure Boot signing yet
- No “stable” channel promise for this tag (tag name is alpha on purpose)
- Extra desktops (Hyprland/KDE/XFCE) not shipping as defaults

## Verify

```bash
sha256sum -c SHA256SUMS --ignore-missing
```

## Feedback

- Issues: https://github.com/saarniuimonen-beep/etheris-os/issues  
- Please include `etheris doctor` / `etheris report create` output when useful (no secrets).
