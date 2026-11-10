# Etheris OS — Colour & Design Tokens

Canonical preview source: [`tokens/etheris-tokens.css`](tokens/etheris-tokens.css)  
Maps to future OS files: `tokens-dark.conf` / `tokens-light.conf` + Atmosphere packs.

---

## Semantic roles

| Token | Role |
|-------|------|
| `--eth-bg` | Shell / desktop underlay |
| `--eth-bg-elevated` | Cards, titlebars, raised chrome |
| `--eth-bg-deep` | Login/splash void |
| `--eth-fg` / `--eth-fg-muted` / `--eth-fg-subtle` | Text hierarchy |
| `--eth-accent` / `--eth-accent-2` | Brand primary / secondary |
| `--eth-accent-soft` | Focus ring fill, soft fills |
| `--eth-border` | Hairline chrome |
| `--eth-panel` / `--eth-menu` / `--eth-input` | Glass surfaces (rgba) |
| `--eth-success` / `--eth-warning` / `--eth-danger` | Semantic |
| `--eth-focus` | Keyboard focus accent |
| `--eth-highlight` / `--eth-gloss` | Soft fills and top-edge gloss |

---

## Dark base (Ocean Glass)

| Token | Value |
|-------|-------|
| BG | `#0a1628` |
| BG elevated | `#122338` |
| FG | `#e8f4fc` |
| FG muted | `#a8c4d8` |
| Accent | `#38bdf8` |
| Accent 2 | `#2dd4bf` |
| Border | `rgba(56, 189, 248, 0.28)` |
| Panel | `rgba(10, 22, 40, 0.72)` |
| Menu | `rgba(10, 22, 40, 0.94)` |
| Success / Warning / Danger | `#4ade80` / `#fbbf24` / `#fb7185` |

## Light base (Arctic Glow)

| Token | Value |
|-------|-------|
| BG | `#f0f7fc` |
| BG elevated | `#ffffff` |
| FG | `#0c2740` |
| FG muted | `#3d5a73` |
| Accent | `#0284c7` |
| Accent 2 | `#0d9488` |
| Panel | `rgba(255, 255, 255, 0.78)` |
| Menu | `rgba(255, 255, 255, 0.96)` |

---

## Atmosphere accent map

| Atmosphere | Variant | Accent | Accent 2 | Wallpaper asset |
|-----------|---------|--------|----------|-----------------|
| Ocean Glass | dark | `#38bdf8` | `#2dd4bf` | `ocean-glass.svg` |
| Aurora | dark | `#2dd4bf` | `#5eead4` | `aurora.svg` |
| Meadow | dark | `#a3e635` | `#4ade80` | `meadow.svg` |
| Arctic Glow | light | `#0284c7` | `#0d9488` | `arctic-glow.svg` |
| Midnight Ocean | dark | `#2dd4bf` | `#38bdf8` | `midnight-ocean.svg` |

Atmospheres **must not** change radii, spacing, or type scale — only colour + wallpaper + surface tint.

---

## Geometry tokens

| Token | Value |
|-------|-------|
| Spacing unit | 4px (`--eth-space-1` … `--eth-space-12`) |
| Radius control | 8px |
| Radius panel / menu | 14px |
| Radius dialog | 16px |
| Radius window | 12px |
| Border width | 1px |
| Shadow | Single soft layer (`--eth-shadow-soft` / `--eth-shadow-float`) |

---

## Glass & transparency

| Mode | Behaviour |
|------|-----------|
| Default | RGBA panel/menu; `--eth-blur: 0` |
| Reduced transparency | Solid `--eth-bg-elevated` surfaces |
| Premium one-shot | Optional temporary blur capture (power menu) — not permanent compositor blur |

---

## CSS ↔ OS conf mapping (post-approval)

| CSS | `tokens-*.conf` |
|-----|-----------------|
| `--eth-bg` | `BG` |
| `--eth-bg-elevated` | `BG_ELEVATED` |
| `--eth-panel` | `BG_PANEL_RGBA` |
| `--eth-menu` | `BG_MENU_RGBA` |
| `--eth-accent` | `ACCENT` |
| `--eth-accent-2` | `ACCENT_2` |
| `--eth-border` | `BORDER_RGBA` |
| `--eth-radius-control` | `RADIUS_CONTROL` |
