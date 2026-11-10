# Neo-Aero P0 — Idle resource baseline

**Date:** 2026-11-08  
**VM:** `qemu:///session` / `ethereal-os`  
**Hardware (guest):** 2 vCPU, 2.4 GiB RAM, virtio-gpu, 1280×800, UEFI  
**Session:** Sway (`ethereal-session`), Wayland  
**Theme under test:** `ocean-glass` (Neo-Aero dark tokens, blur=off)  
**Method:** `MemTotal − MemAvailable` from `/proc/meminfo` (same as `ethereal ram`)  
**Settle:** ~20 s after theme apply; one `foot` window open for measurement commands  
**Evidence:** `out/verification-neo-aero-p0/`

## Results

| Config | Used RAM (MiB) | Notes |
|--------|----------------:|-------|
| 1. Default Neo-Aero desktop + foot | **421** | ocean-glass; blur off; under ≤500 target |
| 2. After `arctic-glow` apply + foot | **450** | light tokens + SVG wallpaper decode spike |
| 3. TTY2 only (no GUI) | 428 | install path; not a desktop baseline |

### Top RSS (config 1, KiB)

| RSS | Process |
|----:|---------|
| 101360 | sway |
| 32416 | glycin-svg (SVG wallpaper helper) |
| 26584 | NetworkManager |
| 26108 | polkit-gnome-authentication-agent |
| 20776 | wireplumber |
| 18120 | systemd-journal |
| 17980 | foot |
| 16360 | swaybg |

Idle CPU: not continuously polled; session remained responsive during theme switches (no desktop restart).

## Interpretation

- P0 theme apply adds **no extra daemon**; footprint stays in the same band as pre–Neo-Aero Sway Light.
- SVG wallpapers briefly engage `glycin-svg`; acceptable for curated SVG set; prefer pre-sized assets if RAM regresses later.
- Aspirational ≤500 MiB remains achievable with blur off and no optional widgets.
- True “no terminal” idle would be slightly below 421 MiB (subtract ~18 MiB foot).

## Budgets (provisional after this baseline)

| Metric | Budget |
|--------|--------|
| Idle RAM (default, blur off, no widgets) | ≤ 500 MiB |
| Theme apply | No session restart; soft reload only |
| Extra resident processes from theming | 0 |
