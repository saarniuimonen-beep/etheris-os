# Etheris Atmospheres — Final Specifications (Phase 2)

Atmospheres are **appearance presets**, not separate desktop environments.

## Invariant (never change between presets)

- Geometry (radii, spacing, panel height/layout)
- Typography scale and families
- Motion timings
- Component structure and keyboard map
- Icon stroke style
- Overlay mutual-exclusion rules
- Default: no dock, no desktop icons, no widgets

## Variable (may change)

- `bg`, `bgElevated`, `bgDeep`, `fg*`, `accent*`, `border`, `panel`, `menu`, `input`, `focus`, `highlight`
- Wallpaper asset
- `variant` light|dark → GTK + Papirus light/dark
- Shadow soft/float opacity (light vs dark)

Exact values: `tokens/etheris.tokens.json` → `atmospheres.*`.

---

## 1. Ocean Glass (default)

- **Variant:** dark  
- **Accent:** `#38bdf8` / `#2dd4bf`  
- **Feel:** Clear coastal depth; default Etheris OS  
- **Wallpaper:** `ocean-glass.svg`

## 2. Aurora

- **Variant:** dark  
- **Accent:** `#2dd4bf` / `#5eead4`  
- **Feel:** Atmospheric blue–green night water  
- **Wallpaper:** `aurora.svg`

## 3. Meadow

- **Variant:** dark  
- **Accent:** `#a3e635` / `#4ade80`  
- **Feel:** Natural greens; still precise chrome  
- **Wallpaper:** `meadow.svg`

## 4. Arctic Glow

- **Variant:** light  
- **Accent:** `#0284c7` / `#0d9488`  
- **Feel:** Clean whites, cool sky glass  
- **Wallpaper:** `arctic-glow.svg`

## 5. Midnight Ocean

- **Variant:** dark  
- **Accent:** `#2dd4bf` / `#38bdf8`  
- **Feel:** Deepest ocean night; low luminance  
- **Wallpaper:** `midnight-ocean.svg`

---

## Storage (implementation later)

```text
/usr/local/share/etheris/themes/<name>.theme   # thin pack (exists)
/usr/local/share/etheris/design/tokens-*.conf # shared bases (exists)
~/.config/etheris/settings.conf               # atmosphere=, blur=, animations=
```

Apply: `etheris theme <name>` → `etheris-theme-apply` (soft reload). Phase 2 adds JSON as design source; apply scripts map JSON→conf after approval.
