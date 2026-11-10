# WP-S5 checkpoint — Settings / overview / widgets (+ S3 polish)

**Date:** 2026-11-08  
**Status:** **PASS** (baked ISO + disposable live VM)  
**ISO:** `out/ethereal-2026.11.08-x86_64.iso`  
**SHA256:** `3ce76275c7978edae208e0cd0697ae1b732dcb2b7571f7db9e4d6149773d14d0`  
**Evidence:** `out/verification-wps5/`  
**Compositor:** Sway (Path A). Quickshell not shipped.

## Features verified (no inject)

| Feature | Result | Evidence |
|---------|--------|----------|
| Live boot + Sway desktop | **PASS** | `desktop-02.png` |
| Panel overview + winctl ✕ − ▭ ⛶ | **PASS** | `desktop-02.png` |
| Super+W workspace overview | **PASS** | `overview-01.png` |
| Super+, Ethereal Settings (GTK) | **PASS** | `settings-01.png` / `smoke-cmds.png` |
| Super+A Control Center | **PASS** | `cc-01.png` |
| Binaries on PATH | **PASS** | `smoke-cmds.png` |
| Widgets default off / motion off | **PASS** | settings defaults + no motion process expected |
| Near-idle RAM (foot open only) | **577 MiB** · aspirational ≤500 · `idle-ram.png` | waybar=1 · motion/widgets not running |

## Build / test

| Item | Result |
|------|--------|
| `./build.sh` | **PASS** (~13 min) |
| ISO size | ~1.8 GiB |
| Disposable disk | `ethereal-wps5-live.qcow2` · CDROM boot · no inject |

## Known issues / honesty

- Sway still has **no** SSD close/min/max buttons — panel + GTK CSD + keybinds only.
- Overview lists workspaces (incl. `__i3_scratch`); not a GNOME overview clone.
- Widgets Path A = optional clock only (off by default).
- Full glass/refraction window animations still blocked on stock Sway (WP-S4 = IPC opacity when enabled).
- Shortcut catalog TSV updated in profile after this bake — will land on next ISO.

## Remaining (next checkpoints)

1. WP-S6: idle RSS/CPU with apps closed; shell-only profile.
2. Optional Quickshell spike behind feature flag (RSS gates in ADR).
3. Richer CC sheet (GTK) if wofi limits UX.
4. Signature motion only after more decoration UX soak — keep reduced-motion default.
