# Performance Requirements (Phase 2)

## Goals

- **Aspirational** idle RAM ≈ **500 MiB** for Etheris/Sway session (`etheris ram` = MemTotal − MemAvailable) **before** browser warm-preload.
- Browser open (Super+B) after login: typically **&lt;1 s** via Firefox scratchpad preload (`etheris-browser --preload`). Virgin process cold start cannot hit &lt;1 s; preload is required.
- Preload skips when `MemAvailable` &lt; ~640 MiB or `browser_preload=off` so small VMs stay lean.
- Lean Firefox defaults: `about:blank` start, 2 content processes, no telemetry/pocket/onboarding, capped memory caches.
- Do **not** strip reliability or core functionality solely to hit 500 MiB.
- Desktop must feel responsive on modest hardware and QEMU virtio-gpu class devices.

## Design rules that protect performance

| Do | Don’t |
|----|-------|
| RGBA glass | Full-screen permanent blur |
| Static wallpapers | Looping animated backgrounds by default |
| Lazy-load overlays | Keep Launcher/CC trees warm always if costly |
| Opt-in widgets (≤3) | Dashboard of always-on rich widgets |
| Soft-reload CSS | Extra cosmetic daemons |
| One soft shadow | Glow farms / multi-shadow stacks |
| Single shell panel stack | Waybar **and** Quickshell panel together |

## Budgets (implementation gates)

| Check | Gate |
|-------|------|
| Idle RSS after settle | Record baseline; reject Stage 2+ if +80 MiB with no feature gain |
| Super+D open | First frame ≤150ms feel on mid hardware (best-effort measure) |
| Atmosphere switch | Soft reload; no session restart |
| Hidden overlays | Destroy or unload heavy trees when closed |
| SVG wallpaper | Watch `glycin-svg` RSS; prefer raster if needed |

## Reduced modes

Reduced transparency and reduced motion are first-class — not afterthoughts — and must be faster/cheaper than default glass motion.
