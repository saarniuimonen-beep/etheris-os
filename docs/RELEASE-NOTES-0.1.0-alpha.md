# Etheris OS 0.1.0-alpha (pre-release)

**Status:** Experimental development build — not a stable release.

## Highlights

- Neo-Aero / Ocean Glass desktop on Sway (Waybar, Rofi, ReGreet)
- Etheris Settings, Control Center, wallpaper and transfer tools
- CPU & GPU Performance Manager (`etheris-perf`) with four profiles
- GPU Manager (`etheris-gpu`) linked to driver helpers
- Gaming stack (Steam / Proton helpers) without anti-cheat bypasses
- Privacy defaults: no telemetry, nftables on, SSH off by default

## Artifacts

See GitHub Release assets for the ISO and `SHA256SUMS`.

## Known limitations

- Alpha quality; expect bugs
- True frosted blur is not available on Sway
- Hardware support rows require evidence — see `docs/HARDWARE-TEST-MATRIX.md`
- ~500 MB idle RAM is aspirational, not guaranteed

## Verify

```bash
sha256sum -c SHA256SUMS
```
