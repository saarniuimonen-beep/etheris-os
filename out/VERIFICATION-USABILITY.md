# Usability fix verification (QEMU)

**Date:** 2026-11-08  
**ISO:** rebuilt `out/ethereal-2026.11.07-x86_64.iso` (artifact timestamp ~01:48 local; SHA256 in `out/SHA256SUMS`)  
**VM:** `qemu:///session` domain `ethereal-os`  
**Disk:** disposable `~/.local/share/libvirt/images/ethereal-usability-test.qcow2` (8 GiB) — **not** Fedora host / physical disks  
**Evidence:** `out/verification-usability/`

## Why `foot.ini` was P0 (but did not block WM/welcome)

foot 1.28 rejected legacy `[colors]` / `[cursor] color=` (errors on every terminal). That looked like a broken session when opening Super+Return, so it was fixed **in the same change set** as WM/welcome. It did **not** delay those fixes: keys, welcome, and firstboot shipped together; foot is independent of greetd/PAM.

## Pre-rebuild checks

- `bash -n` on `ethereal`, `ethereal-welcome`, `ethereal-focus-cycle`
- `foot --check-config` on new `foot.ini` (exit 0)
- Bindings present: Alt+F4, Super+Q, Alt+Tab cycle, Super+H / Super+Shift+H, `exec ethereal-welcome`
- `/etc/localtime` → UTC; `systemd-firstboot.service` masked

## QEMU results

| # | Check | Result |
|---|--------|--------|
| 1 | Boot live ISO | **PASS** |
| 2 | Login screen (no systemd-firstboot timezone TUI) | **PASS** |
| 3 | Login `ethereal` / `ethereal` | **PASS** |
| 4 | First-login welcome once (keys listed; scratchpad wording) | **PASS** |
| 5 | Welcome dismiss → flag; second login **no** welcome | **PASS** (`19-relogin.png`) |
| 6 | Manual reopen `ethereal-welcome -f` / `--force` | **PASS** (`21-welcome-f.png`; note `--force` required on this ISO, `-force` invalid — tree now also accepts `-force`) |
| 7 | Open multiple foot windows | **PASS** |
| 8 | Alt+Tab focus cycle | **PASS** (focus border moved; `--inhibited` binding) |
| 9 | Alt+F4 closes window | **PASS** (via QEMU `sendkey alt-f4`; size drop 292→195 KB) |
| 10 | Super+Q closes window | **PASS** (`sendkey meta_l-q`) |
| 11 | Super+H → scratchpad hide | **PASS** (2→1 window) |
| 12 | Super+Shift+H restore | **Partial** under automated key injection; binding present; document restore in KEYBOARD.md |
| 13 | foot 1.28 no config errors in terminal | **PASS** |
| 14 | Greeter still greetd/tuigreet+PAM | **PASS** (cosmetic greeting only) |

## Remaining / not in scope

- Greeter still TUI + boot journal bleed (LOGIN.md)
- Scratchpad restore automation flaky with virt send-key chords; manual virt-viewer check recommended
- Installer-on-disk not re-tested this round (disposable disk attached empty; live session only)
- No Fedora host package or physical disk changes

## Restore note for operators

VM `ethereal-os` currently uses `ethereal-usability-test.qcow2`. To return to the previous empty install disk:

`virsh -c qemu:///session` edit domain disk back to `ethereal-os.qcow2` if desired.
