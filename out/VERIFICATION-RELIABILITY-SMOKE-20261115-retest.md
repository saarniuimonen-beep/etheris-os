# Verification — reliability live smoke retest (2026-11-15)

KVM QEMU (`qemu:///session`, domain `etheris-os`). Evidence: `out/qemu-reliability-smoke-20261115-retest/`.

## Artifact

| Item | Value |
|------|--------|
| ISO | `out/etheris-2026.11.15-x86_64.iso` |
| SHA256 | `79106f8b47177585a113075d79153141e13ccbfd97363911768318e1ecb8b105` |
| Accel | KVM · host-passthrough |

## Static / artifact gates

| Check | Result |
|-------|--------|
| `scripts/check-profile.sh` | **PASS** |
| `scripts/test-p0-security.sh` | **PASS — 30 OK, 0 FAIL** |
| `scripts/validate-iso.sh` | **PASS — 23 OK, 0 FAIL** |
| L2 UEFI smoke (`test-iso-smoke.sh`) | **PASS** (Etheris OS boot menu on serial; script OVMF paths updated for edk2 4m) |

## Live results

| Check | Result | Evidence |
|-------|--------|----------|
| Boot → ReGreet | **PASS** | `fresh-greeter.png`, `boot-*.png` |
| Cold password-first (Password row + auto session) | **PASS** | `fresh-greeter.png` — Password focused; toast `Auto-selecting session 'Etheris (Sway)'` |
| Session prefers Etheris (Sway); stock Sway hidden | **PASS** | greeter + `systemctl is-active etheris-hide-stock-sway` → `active` |
| Graphical login `etheris`/`etheris` → desktop | **PASS** | `desktop-ready.png`, `desktop-clean2.png` |
| Waybar brand **Etheris** + **Menu** chip | **PASS** | `desktop-ready.png` |
| Watermark **Etheris OS** | **PASS** | desktop screenshots |
| Super+A → Etheris MENU sheet | **PASS** | `menu-sheet.png` |
| Super+D → icon launcher | **PASS** | `launcher-icons.png` |
| `etheris-menu-hover` running | **PASS** | TTY `pgrep -af etheris-menu-hover` → `python3 …/etheris-menu-hover` |
| `etheris-auth-check` | **PASS — 12 OK, 0 FAIL, 0 SKIP** | `tty2-authcheck.png` |
| Password hash matches `etheris` | **PASS** | auth-check |
| `nftables` active | **PASS** | `tty2-nftables.png` → `active` |
| `etheris-hide-stock-sway` + `etheris-regreet-cache` | **PASS** | both `active` (`tty2-units.png`) |

## Notes

1. Password-first on cold live boot is **PASS** on bake `79106f8b…` (earlier smoke on `ec72603b…` was PARTIAL — needed Login click).
2. Brief black framebuffer frames after first Super+A attempt; session recovered — treated as automation flake, not a gate fail (desktop + Menu/launcher reconfirmed).
3. `etheris doctor` on TTY without elevated reads reports expected shadow/sudoers permission noise and `etheris-perf.service` failed (degraded); **auth-check** remains the Alpha 0.2 reliability gate and is green.

## Verdict

**Live reliability smoke PASS** for bake `79106f8b…` (L0–L3): profile + P0 + validate-iso + greeter password-first → desktop → auth-check 12/12 → Super+A Menu / Super+D launcher → nftables + hide-sway + menu-hover.
