# Etheris OS — Visual Identity Guide (Design Phase 1)

**Status:** Design proposal — **not implemented** in the live OS.  
**Direction:** Neo-Aero / Neo-Frutiger Aero (original Etheris identity — not a Vista or Windows 7 clone).

---

## Brand essence

Etheris OS feels like **clear air over water at dawn**: luminous, calm, precise, and optimistic. Interfaces use soft glass, cool aqua–turquoise light, and nature atmospheres without nostalgia cosplay or heavy chrome ornament.

| Attribute | Expression |
|-----------|------------|
| Futuristic | Clean geometry, soft glow accents, restrained gloss |
| Clean | Generous whitespace, 4px grid, one job per surface |
| Bright | Sky/ocean accents; light mode is first-class (Arctic Glow) |
| Atmospheric | Wallpaper + accent packs (“Atmospheres”), not random themes |
| Polished | Shared tokens, visible focus, quiet motion |

**Name in UI**

- Panel / chrome: short mark **etheris** (lowercase wordmark optional)
- Login, splash, OOBE, guide: full **Etheris OS**

---

## What we are not

- Not Aero Glass Vista/7 recreation (no pearl buttons, no orb Start, no stacked bevels)
- Not purple-gradient “AI default” UI
- Not cream / terracotta editorial
- Not dense broadsheet / hairline newspaper layouts
- Not blur-everywhere / particle wallpaper loops

---

## Visual pillars

1. **Selective glass** — Translucent rgba panels and menus; compositor blur **off by default**. One-shot blur only on premium ephemeral surfaces (e.g. power menu).
2. **Layered depth** — Wallpaper → desktop → floating panel → windows → overlays. Single soft shadow; hairline aqua borders; optional top gloss highlight.
3. **Accent language** — Primary sky blue, secondary teal/aqua, atmosphere-specific greens. Accents colour borders, focus, and primary actions — not entire backgrounds.
4. **Nature atmospheres** — Five presets remap wallpaper + accent + surface tint while keeping identical component geometry.
5. **Modern type** — Outfit for UI; JetBrains Mono only for terminal/code.
6. **Rounded controls** — 8px controls, 14px menus, pill panels — careful, not toy-like.

---

## Logo / mark

Preview mark: concentric luminous circles (`preview/assets/mark.svg`) — sky → cyan → teal gradient stroke with solid core. Use sparingly as a hero on login/splash; panel uses a 16–18px mark + word.

---

## Voice of motion

Menus and overlays **arrive** (opacity + slight scale, ≤180ms). Hovers are nearly instant. No bounce, parallax, or delayed focus. See [MOTION.md](MOTION.md).

---

## Efficiency is part of the identity

Etheris looks premium because it is **light**: translucent solids instead of permanent blur farms, static atmospheric wallpapers, and components that stay readable on modest GPUs. See [ACCESSIBILITY-PERF.md](ACCESSIBILITY-PERF.md).
