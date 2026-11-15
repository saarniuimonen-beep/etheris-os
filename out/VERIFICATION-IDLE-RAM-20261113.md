# Idle RAM verification — 2026-11-13

**ISO:** `out/etheris-2026.11.13-x86_64.iso`  
**SHA256:** `fb2f8ebe508910e1357e3ffb2a6c4baaa50b8108c54e801a2cd3d99291a9c2dd`  
**VM:** `qemu:///session` domain `etheris-os` · 3584 MiB · live CDROM · **TCG** (BIOS SVM disabled)  
**Host:** Omarchy  

## Static bake checks

| Check | Result |
|-------|--------|
| Budget-aware preload (`session_pss` / `ETHERIS_BROWSER_FORCE_WARM`) in `etheris-browser` | PASS (squashfs) |
| Pss-based `etheris ram` / `idle-check` | PASS (squashfs) |
| Perf/GPU/immutable bins mode 755 | PASS |

## Live session

| Check | Result |
|-------|--------|
| ReGreet branding | PASS — Etheris OS · Etheris Live User · Etheris (Sway) |
| Desktop / Waybar | PASS — Etheris wordmark + wallpaper watermark |
| `etheris-immutable status` (live) | PASS — `mutable-classic` (expected) |
| `etheris-browser --status` after kill | `firefox_running=no`, lean profile ready, preload_enabled=yes |
| `etheris ram idle-check` (no Firefox) | **PASS — session_pss ≈ 124 MiB** (target ≤500) |

Evidence screenshots: `out/qemu-live-20261113/boot-8.png` (ReGreet), `boot-10.png` (desktop), `idle-check2.png` (PASS).

## Notes

- Prior ISO (`2513da38`, VmRSS metric) measured shell ≈505 MiB session_rss. Pss metric on this bake reports ≈124 MiB for the same class of idle session (shared libs no longer double-counted).
- Warm resident Firefox still expected to blow the 500 MiB gate; budget-aware preload should skip warm start when session is already heavy.
- Guest accel is TCG until AMD **SVM** is enabled in BIOS (`SVM disabled (by BIOS) in MSR_VM_CR`).
