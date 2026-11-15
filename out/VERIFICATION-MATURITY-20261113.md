# Verification — maturity rebake (2026-11-13 evening)

## Artifact

| Item | Value |
|------|--------|
| File | `out/etheris-2026.11.13-x86_64.iso` (~2.1 GiB) |
| SHA256 | `3e5d1fc5a503e48fe0da3b9ba38cfe4a9552c0c22ae90dd43632426071c127b9` |
| Console log | `out/build-maturity-*.console.log` / `out/build-20261113T170804Z.log` |
| Replaces | Earlier same-day P0 ISO (`4f674282…`) |

## Pre-bake gates

- `./scripts/check-profile.sh` — PASS
- `./scripts/test-p0-security.sh` — 30 OK

## Squashfs spot-check (extracted from ISO)

| Check | Result |
|-------|--------|
| MOTD Sway-only (no Hyprland/KDE/XFCE picker) | PASS |
| `PRETTY_NAME=Etheris OS 0.1.0-alpha` | PASS |
| `BUILD_ID=rolling-lag14` | PASS |
| `IMAGE_VERSION=2026.11.13` (archiso stamps ISO date; product semver remains in PRETTY_NAME / VERSION file) | PASS / expected |
| `etheris-rgb` + `etheris-rgb-manager` mode 755 | PASS |
| No `/etc/systemd/system/avahi-daemon.service` → `/dev/null` mask | PASS |
| `multi-user.target.wants/avahi-daemon.service` present in image | PASS (listed in squashfs) |

## Not claimed

- Live QEMU boot of this exact rebake
- Install cold-reboot persistence E2E
- Physical GPU matrix
