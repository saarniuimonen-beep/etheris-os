# Verification — Stage 1 Token Bridge

**Date:** 2026-11-08  
**Scope:** Design Phase 2 Roadmap Stage 1 only (shared tokens → existing apply path)  
**OS chrome redesign:** not started  

## Tests run

| Test | Result |
|------|--------|
| `ethereal-tokens-generate` writes `tokens-dark.conf` / `tokens-light.conf` from JSON | Pass |
| `ethereal-tokens-generate --check` | Pass |
| Apply `ocean-glass` (dark) → waybar/wofi/mako/foot/sway/GTK | Pass (temp `$HOME`) |
| Apply `arctic-glow` (light) → Adwaita + Papirus, light foot, light panel rgba | Pass |
| Apply `aurora` (dark + accent override) | Pass |
| Core colours continuous with pre-Stage-1 values (`#0a1628`, panel rgba, `#38bdf8` / Arctic `#0284c7`) | Pass |
| `RADIUS_PANEL=12` preserved | Pass |
| `bash -n` theme-apply + ethereal; `py_compile` generator | Pass |

## Appearance notes

- Waybar/wofi `font-family` now prefers **Outfit** then existing JetBrainsMono. Outfit is **not** packaged on the ISO yet → runtime falls back to JetBrainsMono (no visual change until a font package is approved).
- No Sway/Quickshell/app replacements.
- No new always-on processes.

## Remaining / out of Stage 1

- Package Outfit (or Source Sans 3 fallback) — deferred (avoid new ISO dependency without approval).
- Per-Atmosphere surface tints (aurora/meadow/midnight still use dark base + accent from `.theme`) — Stage 4 territory.
- Design JSON `radius.panel` 14 vs shipped 12 — generator keeps 12 until Stage 2 panel polish.
- Live VM soft-reload not re-run this session (host Fedora; apply logic unchanged aside from token source).
