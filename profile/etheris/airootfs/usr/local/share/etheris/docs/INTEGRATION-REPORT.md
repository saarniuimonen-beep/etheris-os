# Etheris full-system integration report (draft)

**Date:** 2026-11-10  
**ISO under test:** `etheris-2026.11.09-x86_64.iso` (SHA256 `6fb625b0…`)  
**Note:** Performance Manager lands via `out/perf-gpu-apply.tgz` or next rebake — not yet in the 23:17 ISO binary.

Legend: **Working** · **Partial** · **Broken** · **Untested**

## Component inventory (summary)

### Boot and startup
| Component | Status | Evidence |
|-----------|--------|----------|
| Bootloader branding | Working (tree) | syslinux/GRUB/EFI titles Etheris |
| Live ISO startup | Partial | Prior QEMU live verifications; soak fresh ISO still queued |
| ReGreet login | Working (tree + prior) | Neo-Aero greeter |
| Desktop session | Working (prior) | Sway session verified historically |
| Startup sound | Working (prior) | guide/shortcuts/sound verification |
| First-boot OOBE | Partial | M6 OOBE pass; fresh bake E2E without inject still open |

### Desktop environment
| Component | Status |
|-----------|--------|
| Sway / Waybar / Rofi / Mako | Working (prior VM) |
| Control Center / Settings | Working (tree); Performance page new — needs VM |
| Wallpaper / Files / Transfers | Working (prior) |
| True frosted blur | Broken / N/A on Sway (honest) |

### Applications
| Component | Status |
|-----------|--------|
| Files, Terminal, Firefox, Settings | Working (shipped) |
| GPU Manager / Performance Manager | In tree; **Untested on ISO** until inject/rebake |
| Steam | Partial — launches in VM ≠ GPU proof |

### System / install / gaming / dev
See prior milestone docs under `out/VERIFICATION-*.md`. Many networking/audio/suspend/physical GPU rows remain **Untested** on real hardware.

## Critical / high priority before public “usable” claim

1. Bake or inject Performance Manager; verify Settings ↔ Quick Settings ↔ `etheris-perf get` sync in VM.
2. Fresh install E2E on disposable qcow2 with latest ISO.
3. Document known issues; no stable branding.
4. Owner approval for public repos / downloads.

## Performance measurements

Not re-measured this session. Use `etheris ram` / `etheris-perf monitor` after guest boot. 500 MB idle remains aspirational.

## Security findings

No new critical findings this session. Follow `docs/SECURITY.md`. Re-scan for secrets before first public push.
