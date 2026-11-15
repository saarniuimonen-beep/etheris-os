# Verification — Etheris P0 foundations

**Date:** 2026-11-08  
**VM:** `qemu:///session` / `ethereal-os` (installed `demo`)  
**Delivery:** tree + virtio FAT inject (`p0/install-p0.sh`)  
**Evidence:** `out/verification-etheris-desktop-p0/`, `out/BASELINE-ETHERIS-DESKTOP-P0.md`

## Results

| # | Check | Result |
|---|--------|--------|
| 1 | Tokens dark/light present | **PASS** |
| 2 | Theme packs + wallpapers installed | **PASS** |
| 3 | `ethereal-theme-apply` runs | **PASS** (`ocean-glass` / `#38bdf8`) |
| 4 | `ethereal theme` soft-applies without restart | **PASS** |
| 5 | Light pack `arctic-glow` | **PASS** (accent `#0284c7`) |
| 6 | Idle RAM ≤500 MiB (Sway + foot) | **PASS** (**421 MiB**) |
| 7 | No new theme daemon | **PASS** |
| 8 | Sway fallback preserved | **PASS** (still default session) |

## Out of scope (not tested / not claimed)

Atmospheres product UX, widgets, Control Center GUI, Quickshell, full Settings app, ISO bake of P0.

## Verdict

**PASS** for Etheris **P0** foundations on the installed VM path. Bake into next ISO via `./build.sh`.
