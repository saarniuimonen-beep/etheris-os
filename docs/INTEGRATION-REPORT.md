# Etheris full-system integration report

**Date:** 2026-11-12  
**ISO under test:** `etheris-2026.11.10-x86_64.iso` (SHA256 `7a5ea54b9b11dc7aa2a981f9887d94c2cc7007707c834f6692556607ba7416f0`)  
**VM:** `qemu:///session` domain `etheris-os` · ~3584 MiB RAM · live CDROM boot

Legend: **Working** · **Partial** · **Broken** · **Untested**

## Component inventory (summary)

### Boot and startup
| Component | Status | Evidence |
|-----------|--------|----------|
| Bootloader branding | Working | ISO volume `ETHERIS_202611`; live boot to ReGreet |
| Live ISO startup | Working | Fresh boot 2026-11-12 (after discarding broken managed-save state) |
| ReGreet login | Working | Title **Etheris OS**, user **Etheris Live User**, session Sway |
| Wallpaper mark | Partial | Greeter PNG still showed leftover **Ethereal** corner text on Nov 10 bake; SVGs already say Etheris; PNGs regenerated 2026-11-12 (needs rebake) |
| Desktop session | Working | Sway + Waybar **Etheris** panel; live overlay |
| Timezone OOBE | Partial | Opens on first session; WebKit globe often blank on virtio — GTK path / Skip works |
| Startup sound / guide | Untested this session | Prior verifications still apply |

### Desktop environment
| Component | Status |
|-----------|--------|
| Sway / Waybar / Rofi / Mako | Working (live VM 2026-11-12) |
| Control Center / Settings | Working (tree); Performance page needs executable `etheris-perf` |
| Wallpaper / Files / Transfers | Working (prior + branding present) |
| True frosted blur | Broken / N/A on Sway (honest) |

### Applications
| Component | Status | Evidence |
|-----------|--------|----------|
| Files, Terminal, Firefox | Working | neofetch / Firefox mapped on live session |
| `etheris-browser` | Working | `--status` showed Firefox running/mapped; binary mode `755` in squashfs |
| GPU Manager / Performance Manager | **Broken on Nov 10 ISO** | Squashfs modes `644` for `etheris-perf`, `etheris-performance`, `etheris-gpu`, `etheris-gpu-manager` → shell **Permission denied**. Root cause: missing `file_permissions` entries in `profiledef.sh`. **Fixed in tree 2026-11-12**; live workaround `out/perf-gpu-apply.tgz` / inject `fix-perf-perms.sh` |
| Steam | Partial | Prior VM launches ≠ physical GPU proof |

### System / install / gaming / dev
See `out/VERIFICATION-*.md`. Networking/audio/suspend/physical GPU rows remain **Untested** on real hardware.

## Critical / high priority before public “usable” claim

1. **Rebuild ISO** so Performance/GPU Manager binaries are `755` and regenerated wallpapers ship.
2. VM-verify: `etheris-perf get` · Settings ↔ Control Center profile sync · `etheris-browser --status`.
3. Fresh install E2E on disposable qcow2 with post-fix ISO.
4. Owner approval for public repos / downloads / Pages.

## Performance measurements (live VM, 2026-11-12)

| Metric | Value | Notes |
|--------|-------|-------|
| Guest RAM | 3.32 GiB configured | Raised from 2.5 GiB for desktop+browser |
| Session memory (neofetch) | ~1.28 GiB / 3.32 GiB | Includes Firefox + timezone UI — **not** idle-only |
| ≤500 MiB idle aspirational | Untested this boot | Measure with browser preload off / closed |

## Security findings

No new critical findings. Re-scan for secrets before first public push. Follow `docs/SECURITY.md`.
