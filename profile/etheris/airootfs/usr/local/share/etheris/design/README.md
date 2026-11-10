# Etheris design tokens (Stage 1 bridge)

| File | Role |
|------|------|
| `etheris.tokens.json` | **Source of truth** (Phase 2 Neo-Aero tokens) |
| `tokens-dark.conf` | Generated — loaded by `etheris-theme-apply` (Ocean Glass / dark) |
| `tokens-light.conf` | Generated — Arctic Glow / light |
| `templates/` | waybar / wofi / mako placeholders `@TOKEN@` |

Regenerate confs after editing JSON:

```bash
etheris-tokens-generate
# or during profile prep:
ETHERIS_SHARE=…/usr/local/share/etheris etheris-tokens-generate
```

Stage 1 keeps `RADIUS_PANEL=12` in generated confs (shipped UI) even if JSON geometry lists 14.
