# Exact Colour & Design Tokens (Phase 2)

**Source of truth:** [`tokens/etheris.tokens.json`](tokens/etheris.tokens.json)  
**Preview binding:** [`tokens/etheris-tokens.css`](tokens/etheris-tokens.css)

---

## Geometry (invariant)

| Token | Value |
|-------|-------|
| Space unit | 4px |
| Radius control / panel / menu / dialog / window | 8 / 14 / 14 / 16 / 12 |
| Panel height / top offset | 28 / 0 (edge bar) |
| Control Center max width | 360 |
| Launcher max width | 640 |
| Border | 1px |
| Focus ring | 3px `accentSoft` |

## Type (invariant)

| Role | Size | Weight |
|------|------|--------|
| Display | 40 | 700 |
| Title | 22 | 600 |
| Heading | 18 | 600 |
| Body | 14 | 400 |
| Caption | 12 | 500 |
| Micro | 11 | 500 |

UI face: **Outfit**. Mono: **JetBrains Mono** (terminal/code only).

## Motion (invariant)

Hover 80ms · Open 180ms · Close 140ms · Page 220ms · Ease `cubic-bezier(0.22, 1, 0.36, 1)`

## Status colours

| | Dark | Light |
|--|------|-------|
| Success | `#4ade80` | `#16a34a` |
| Warning | `#fbbf24` | `#d97706` |
| Danger | `#fb7185` | `#e11d48` |

## Default Atmosphere — Ocean Glass

| Token | Value |
|-------|-------|
| bg | `#0a1628` |
| bgElevated | `#122338` |
| fg | `#e8f4fc` |
| fgMuted | `#a8c4d8` |
| accent | `#38bdf8` |
| accent2 | `#2dd4bf` |
| panel | `rgba(10,22,40,0.72)` |
| menu | `rgba(10,22,40,0.94)` |
| border | `rgba(56,189,248,0.28)` |

Full five Atmosphere tables: [ATMOSPHERES.md](ATMOSPHERES.md).

## OS mapping (post-approval)

| JSON | `tokens-*.conf` / apply |
|------|-------------------------|
| `bg` | `BG` |
| `bgElevated` | `BG_ELEVATED` |
| `panel` | `BG_PANEL_RGBA` |
| `menu` | `BG_MENU_RGBA` |
| `accent` | `ACCENT` |
| `accent2` | `ACCENT_2` |
| `border` | `BORDER_RGBA` |
| `radius.*` | `RADIUS_*` |
