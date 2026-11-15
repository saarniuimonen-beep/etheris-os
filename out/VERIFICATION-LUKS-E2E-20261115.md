# Verification — LUKS install + unlock E2E

**Date:** 2026-11-15  
**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `79106f8b47177585a113075d79153141e13ccbfd97363911768318e1ecb8b105`  
**Domain:** `etheris-e2e` (`qemu:///session`) — **never** `etheris-os`  
**Evidence dir:** `out/e2e-install-20261115T183311Z/`

## Results

| Gate | Result | Evidence |
|------|--------|----------|
| Install with `--luks` | **PASS** | `progress-1.png`, install log SUCCESS |
| Disk is LUKS2 | **PASS** | `luks-status.txt` → `LUKS_YES` / `UNLOCK_OK`; `luksDump.txt` LUKS2 aes-xts |
| Boot entry `cryptdevice=` | **PASS** | `boot-entry.txt` |
| Cold boot → cryptsetup prompt | **PASS** | `luks-prompt.png` |
| Correct passphrase → greeter | **PASS** | `after-unlock.png` (demo + Etheris (Sway)) |
| Login → first-setup / session | **PASS** | `installed-desktop.png` (OOBE TUI) |
| Wrong passphrase rejected | **PASS** | `luks-wrong-reject.png` (“No key available…”) |
| Retry correct → greeter | **PASS** | `luks-wrong-then-ok.png` (password-first) |
| Offline cryptsetup unlock | **PASS** | `UNLOCK_OK` via nbd/cryptsetup on host |

## Stance

- Optional LUKS via installer is **verified on QEMU** for install + unlock + wrong-pass path.
- Default install remains **unencrypted**.
- Physical DUT / suspend-with-encrypted-swap still **out of scope** for this claim.

## Bonus — installed session after LUKS

- `neo-desktop.png` / `neo-lock.png`: post-login Waybar + Getting started on LUKS disk (lock inject inconclusive without rebake).
