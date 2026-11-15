# Etheris OS 0.1.0-alpha (pre-release)

**Status:** Experimental development build — not a stable release.  
**Latest development bake:** 2026-11-15 (`etheris-2026.11.15-x86_64.iso`).

## Highlights

- Ocean Glass themed desktop on Sway (Waybar, Rofi, ReGreet login)
- Menu (Super+A), icon launcher (Super+D), Settings, wallpaper and transfer tools
- CPU & GPU Performance Manager (`etheris-perf`) with four profiles
- GPU Manager (`etheris-gpu`) linked to driver helpers
- Gaming stack (Steam / Proton helpers) without anti-cheat bypasses
- Privacy defaults: no telemetry, firewall on, SSH off by default
- Installer with optional LUKS (QEMU E2E verified); Software Center; `etheris doctor`

## Progress since 2026-11-10

- Desktop polish (thin panel, Menu hover, frost power menu, Flow tokens)
- Rock-solid QEMU gates: stability, reliability, maturity STRICT, security, bugs, idle RAM (~169 MiB)
- Install persistence + optional LUKS unlock E2E
- Source CI workflow and maturity/security/bug test harnesses

## Artifacts

ISOs are built locally with `./build.sh` — public GitHub Release hosting is not published yet.  
Checksums: `out/SHA256SUMS` (latest Nov 15: `eb677f92d3d6a336b1eca3f6b8f64de4e649badabf22c17366468c3a4b05dfd6`).

## Known limitations

- Alpha quality; expect bugs
- Full frosted-glass blur is not available on Sway
- Hardware support rows require evidence — see `docs/HARDWARE-TEST-MATRIX.md`
- Secure Boot is unsupported; immutable installs are planned only
- Idle RAM ~169 MiB verified in QEMU with browser preload off (target remains ≤500 MiB)

## Verify

```bash
sha256sum -c SHA256SUMS
```
