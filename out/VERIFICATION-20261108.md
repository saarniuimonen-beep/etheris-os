# Verification — ethereal-2026.11.08 (QEMU)

**Date:** 2026-11-08  
**ISO:** `out/ethereal-2026.11.08-x86_64.iso` (~1.8 GiB)  
**SHA256:** `2a42e2fa7b929ef143bd0776870460a4af7df14598deb7430a0a0132aa466249`  
**VM:** `qemu:///session` / `ethereal-os` (2 vCPU, 2 GiB, UEFI, virtio, SPICE)  
**Disk:** live only (`ethereal-usability-test.qcow2` attached, unused for this pass)  
**Evidence:** `out/verification-20261108/`

## Milestone mapping

| Milestone | Result |
|-----------|--------|
| M1 Build + bootable ISO | **PASS** (prior build + this cold boot) |
| M2 Live login / session | **PASS** |
| M3 Core desktop / WM | **PASS** (see notes) |
| M4 Welcome (live) | **PASS** on live; installed-user still open |

## Checklist

| # | Check | Result |
|---|--------|--------|
| 1 | Cold boot from 11.08 ISO | **PASS** (`01–12-boot.png`) |
| 2 | Greeter (tuigreet, Ethereal OS — login, CMD ethereal-session) | **PASS** |
| 3 | Login `ethereal` / `ethereal` | **PASS** (`15-now.png`) |
| 4 | Sway + Waybar + wallpaper | **PASS** |
| 5 | First-login welcome once | **PASS** |
| 6 | Welcome dismiss (Enter) | **PASS** (`16-…`) |
| 7 | Super+Return → foot | **PASS** |
| 8 | Super+D → wofi | **PASS** (`23-wofi.png`) |
| 9 | Alt+F4 closes window | **PASS** (two terms → one) |
| 10 | Super+Q closes window | **PASS** |
| 11 | Super+H scratchpad hide | **PASS** (`25`) |
| 12 | Super+Shift+H restore | **PASS** (`26`) |
| 13 | `steam` present (`/usr/bin/steam`) | **PASS** |
| 14 | `ethereal-hw` / `ethereal-drivers` present | **PASS** |
| 15 | `ethereal-hw cpu` runs | **PASS** (`24-steam-hw.png`) |
| 16 | Logout → greeter | **PASS** (`28-greeter-again.png`) |
| 17 | Idle RAM (Steam installed, not running) | **~445 MiB** / bar **0.4G** — under 500 MB target |
| 18 | Non-fatal boot note | `systemd-loop@…sr0` **FAILED** once during boot; greeter still reached |

## Not claimed

- Steam GUI launch / Proton / physical GPU
- Installer E2E / installed-system boot (Milestone 5)
- Reboot/shutdown ACPI full cycle (logout proven; shutdown deferred to quick ACPI later)
- Audio beyond “services present”

## Verdict

**Milestones 1–3 (and live M4) pass on ISO 2026.11.08.**  
Proceed to **Milestone 5 — installer on disposable qcow2**.
