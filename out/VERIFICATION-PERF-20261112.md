# Verification — Performance Manager on Nov 10 ISO (2026-11-12)

**ISO:** `etheris-2026.11.10-x86_64.iso`  
**SHA256:** `7a5ea54b9b11dc7aa2a981f9887d94c2cc7007707c834f6692556607ba7416f0`  
**VM:** `etheris-os` · 3584 MiB · live CDROM boot

## Results

| Check | Result |
|-------|--------|
| Live boot to ReGreet | PASS — **Etheris OS** title, Etheris Live User |
| Sway desktop + Waybar | PASS — panel brand **Etheris** |
| `etheris-browser` / Firefox | PASS — process mapped; binary mode `755` in squashfs |
| `etheris-perf` / `etheris-gpu` | **FAIL** on this ISO — binaries present but mode **644** → `Permission denied` |
| Wallpaper corner mark | PARTIAL — greeter PNG still showed Ethereal remnant (SVGs already Etheris; PNGs regenerated in tree) |

## Root cause

`profiledef.sh` `file_permissions` omitted:

- `/usr/local/bin/etheris-perf`
- `/usr/local/bin/etheris-performance`
- `/usr/local/bin/etheris-gpu`
- `/usr/local/bin/etheris-gpu-manager`

Confirmed via squashfs listing (`-rw-r--r--` vs `etheris-browser` `-rwxr-xr-x`).

## Fix

1. Entries added to `profiledef.sh` (2026-11-12).
2. Live workaround on inject: `fix-perf-perms.sh` and refreshed `perf-gpu-apply.tgz`.
3. ISO rebake started to ship `755` + regenerated wallpapers.

## Follow-up on next ISO

```bash
etheris-perf get
etheris-perf capabilities
etheris-performance   # GTK
etheris-gpu
# Settings → Performance · Control Center → Performance profile
```
