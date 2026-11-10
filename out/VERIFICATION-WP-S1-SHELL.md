# WP-S1 checkpoint — Neo-Aero shell foundation (Path A)

**Date:** 2026-11-08  
**Status:** **PASS** (baked ISO + disposable live VM)  
**ISO:** `out/ethereal-2026.11.08-x86_64.iso`  
**SHA256:** `aa1c8b301a70ac29e413da072fea749e7c3bf190244ac832216b6d4d51cf9860`  
**Evidence:** `out/verification-wps1/`

## Features verified (no inject)

| Feature | Result | Evidence |
|---------|--------|----------|
| Squashfs contains overlay/launcher/CC | **PASS** | `squashfs/` extract |
| Floating panel + workspace dots | **PASS** | `desktop-10.png` |
| Super+A Control Center stub | **PASS** | `cc-01.png` |
| Super+D launcher (wofi) | **PASS** | `launcher-01.png` |
| Binaries on live PATH | **PASS** | `smoke-cmds.png` |
| Idle RAM (live, Steam installed not running) | **PASS** · **487 MiB** ≤500 | `smoke-cmds.png` |

## Build / test

| Item | Result |
|------|--------|
| `./build.sh` | **PASS** |
| ISO size | ~1.8 GiB |
| Disposable disk | `ethereal-wps1-live.qcow2` · CDROM boot · no inject |

## Known issues

- Memory module shows used GiB (0.5G class) — expected.
- Tray empty until StatusNotifier apps run — expected.
- This ISO is **WP-S1 only**; WP-S2/S3/S4 landed in tree after profile copy for this bake.

## Remaining

- Bake+verify WP-S2 (notifications/tray policy), WP-S3 (decorations), WP-S4 (motion) on a follow-up ISO.
