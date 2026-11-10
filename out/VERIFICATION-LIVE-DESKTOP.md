# Live ISO desktop verification — results

**Date:** 2026-11-08  
**ISO:** `ethereal-2026.11.07-x86_64.iso`  
**VM:** `ethereal-os` on `qemu:///session` (2 vCPU, 2 GiB RAM, UEFI, virtio GPU, SPICE)  
**Evidence:** `out/verification/*.png`

## Summary

| Check | Result |
|-------|--------|
| 1. ISO boots in QEMU/KVM | **PASS** (UEFI live boot to userspace + greeter) |
| 2. Existing login works | **PASS** (`ethereal` / `ethereal` via greetd/tuigreet) |
| 3. Login starts Sway | **PASS** (Sway 1.12 Wayland; Waybar; wallpaper) |
| 4. Keyboard / mouse / display / basics | **PASS** with notes (see below) |
| 5. Errors / missing / issues | **Recorded** (none block login/Sway) |

**Verdict:** Live login + Sway path is verified for this ISO. Do **not** start custom greeter / welcome popup / extra desktop features yet. Next work should fix recorded boot polish bugs, then rebuild and re-smoke before installer milestone.

---

## What was tested

1. **Boot** — Rebooted VM from live CD; reached graphical target.
2. **Login** — Cleared greeter; authenticated as `ethereal` / `ethereal`; default command `ethereal-session`.
3. **Sway** — Desktop with Ethereal wallpaper, Waybar (`ethereal` + workspace `1`, clock, `lan`, ~0.4–0.5G).
4. **Keyboard** — `Super+Return` opened **foot**; typed `uname -a` successfully; `Super+D` opened **wofi** launcher.
5. **Display** — 1280×800 virtio output; SPICE screenshots captured throughout.
6. **Mouse** — Not exercised beyond SPICE/session (no guest agent); keyboard path proves seat input. Manual virt-viewer mouse still recommended once.

Fastfetch/neofetch-style output in foot reported: Ethereal OS 0.1.0-alpha, Sway Wayland, ~511 MiB used / 1.91 GiB, IP `10.0.2.15`, overlay root.

---

## Issues found (do not ignore on next rebuild)

### P0 — Interactive `systemd-firstboot` on boot

- After reboot, **Initial Setup** timezone TUI appeared before greeter.
- Empty Enter can skip; wrong input (e.g. `helsinki`) errors until valid `Region/City` or skip.
- **Cause:** Shipped ISO has `LANG=en_US.UTF-8` but **no** `/etc/localtime`. Mask `systemd-firstboot.service → /dev/null` exists in the **tree** but was added **after** this ISO was built (`ISO 00:48`, mask `00:54`). Not in the squashfs of this image.
- **Fix for next ISO:** Ship `/etc/localtime` (e.g. UTC or Europe/Helsinki) **and/or** ensure firstboot stays masked; rebuild; confirm no Initial Setup on cold boot.

### P1 — Greeter UX / boot noise

- systemd status lines (e.g. **Initialize Pacman keyring**, long-running) paint under/over tuigreet on tty1.
- Wrong remembered username (`saarni`) causes “Authentication failed” — expected; live user is **`ethereal`**.

### P1 — `foot.ini` invalid for foot 1.28

On every terminal open:

- `[colors]: invalid section name: colors` (foot expects a different colors section layout)
- `[cursor].color: … not a valid option: color`

Terminal still runs; theme partially broken. Fix skel `foot.ini` before next ISO.

### P2 — Broken systemd enable symlink in profile tree

`multi-user.target.wants/ethereal-live-ready.service` → `ethereal-live-ready.service` (self loop). Should point at `/etc/systemd/system/ethereal-live-ready.service`. Other wants links for auth-setup/pacman-init look fine as paths but verify after rebuild.

### P2 — Idle RAM at edge of target

Waybar showed ~0.4–0.5G; fastfetch ~511 MiB / 1.91 GiB in VM. Acceptable for alpha smoke; re-measure on next ISO after foot/firstboot fixes (no claims until deliberate idle measurement).

### Not tested (out of scope this run)

- Audio playback, Wi‑Fi (NAT `lan` only), installer on `vda`, suspend, multi-session F3 flows, physical USB boot.

---

## Screenshots index

| File | Content |
|------|---------|
| `01-before.png` / `02-…` | Sway desktop already running (pre-reboot) |
| `03-post-reboot.png` | systemd-firstboot timezone list |
| `05-after-more-skips.png` | tuigreet + pacman-init noise |
| `08–10-state.png` | Sway after successful login |
| `11-super-return.png` | foot + fetch + foot.ini errors |
| `12-uname.png` | `uname -a` OK |
| `13-wofi.png` | wofi launcher |
| `14-final-desktop.png` | post-test desktop |

---

## Recommended next milestone (needs approval)

**Milestone: “Clean live boot polish + ISO rebuild”** (before installer or any new desktop features)

1. Eliminate firstboot prompt (locale/timezone + mask in image).  
2. Fix `foot.ini` for current foot.  
3. Fix `ethereal-live-ready` wants symlink.  
4. Rebuild ISO; re-run this verification (cold boot → greeter → login → Sway → Super+Return / Super+D) with **no** firstboot.  
5. Only then propose **installer-on-virtual-disk** as the following milestone.

Explicitly **deferred** until approved after that: custom greeter (`docs/LOGIN.md`), welcome popup, extra desktop features.
