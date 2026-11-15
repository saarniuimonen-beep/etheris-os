# Etheris Flow — design tokens (Stage 1 bridge)

**Flow** = shared colors, fonts, and UI styles for Etheris.  
Default theme: **Ocean Glass**. Developer entry: `/usr/local/share/etheris/docs/FLOW.md` (tree: `docs/FLOW.md`).

| File | Role |
|------|------|
| `etheris.tokens.json` | **Source of truth** (Flow / Phase 2 tokens) |
| `tokens-dark.conf` | Generated — loaded by `etheris-theme-apply` (Ocean Glass / dark) |
| `tokens-light.conf` | Generated — Arctic Glow / light |
| `templates/` | waybar / wofi / mako / gtk / rofi `@TOKEN@` |

Regenerate confs after editing JSON:

```bash
etheris-tokens-generate
# or during profile prep:
ETHERIS_SHARE=…/usr/local/share/etheris etheris-tokens-generate
```

Stage 1 keeps `RADIUS_PANEL=12` in generated confs (shipped UI) even if JSON geometry lists 14.

`etheris-theme-apply` resolves `FONT_UI` through fontconfig (ISO default: Noto Sans) and maps `animations=` to GTK + reduced-motion CSS.
