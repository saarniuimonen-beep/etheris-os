# Verification — maturity ISO live smoke (2026-11-13 evening)

TCG QEMU (`domain type=qemu`, no `/dev/kvm`). Screenshots under `out/qemu-maturity-smoke-20261113/`.

## Artifact under test

| Item | Value |
|------|--------|
| ISO | `out/etheris-2026.11.13-x86_64.iso` |
| SHA256 | `3e5d1fc5a503e48fe0da3b9ba38cfe4a9552c0c22ae90dd43632426071c127b9` |
| Domain | `etheris-os` @ `qemu:///session` |
| Boot to desktop | ~210 s (TCG) |

## Maturity rebake targets

| Check | Result | Evidence |
|-------|--------|----------|
| Live boot → Etheris/Sway Waybar desktop | **PASS** | `boot-8.png`, `desktop-now.png` (Firefox + panel) |
| Foot terminal (Super+Return) | **PASS** | `term-1.png` |
| `PRETTY_NAME=Etheris OS 0.1.0-alpha` | **PASS** | `os-release.png` |
| `BUILD_ID=rolling-lag14` | **PASS** | `os-release.png` |
| `VARIANT=Stable (Archive lag)` | **PASS** | `os-release.png` |
| MOTD `Sway · Etheris` (no Hyprland/KDE/XFCE) | **PASS** | `motd.png` |
| `avahi-daemon` enabled + active | **PASS** | `smoke-clean.png` |
| No avahi `/dev/null` mask | **PASS** | earlier status + wants present |
| `etheris-rgb` / `etheris-rgb-manager` mode 755 | **PASS** | `nft-rgb.png` |
| greetd + ReGreet available | **PASS** | `auth-check.png` |
| `etheris.desktop` Sway session | **PASS** | `auth-check.png` |
| NetworkManager active | **PASS** | `smoke-clean.png` |
| `etheris-auth-setup` ran (active/exited) | **PASS** | `smoke-clean.png` |
| `nftables` enabled | **PASS** | `nft-rgb.png` |
| `nftables` is-active | **NOTE** | `inactive (dead)` after oneshot start — `sudo visudo` OK; treat as “load then exit” unless `nft list ruleset` empty (not re-checked) |

## `etheris-auth-check` as live user (this ISO)

Ran without sudo first: **7 OK, 3 FAIL** — but follow-up proved two FAILs were **false negatives**:

| Reported FAIL | Reality |
|---------------|---------|
| no password hash | `/etc/shadow` unreadable as user (`Permission denied`); auth-setup already set passwords |
| visudo INVALID | `sudo visudo -cf /etc/sudoers` → **parsed OK** (`diag.png`) |
| polkit rule missing | Rule lives under `/etc/polkit-1/rules.d` (root-only dir); user `ls` got permission denied |

**Follow-up in tree (not in this ISO):** `etheris-auth-check` now uses `sudo -n` for privileged probes, and the scoped rule is also installed at `usr/share/polkit-1/rules.d/49-etheris-wheel.rules`.

## Not claimed

- Install / cold-reboot persistence E2E
- KVM (SVM still unavailable — `/dev/kvm` missing)
- Physical GPU matrix
- Fresh greeter password typing path (session reached desktop; exact greeter interaction not separately gated)
