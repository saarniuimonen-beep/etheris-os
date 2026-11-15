# Etheris Flow — Design System

**Flow** is the shared design system for Etheris: colors, fonts, spacing, and UI styles used by the panel, menus, and Etheris apps.

The default look is the **Ocean Glass** theme (cool blues, soft transparency). Other themes (Atmospheres) reuse the same tokens.

All shell chrome and Etheris GTK apps should use Flow tokens — not one-off color palettes.

## Where things live

| Layer | Path |
|-------|------|
| Spec + HTML previews | `design/phase-2/` |
| Runtime JSON (source of truth) | `/usr/local/share/etheris/design/etheris.tokens.json` |
| Generated conf | `tokens-dark.conf` / `tokens-light.conf` |
| Templates | `design/templates/*.tmpl` |
| Apply | `etheris-theme-apply` ← `etheris theme …` / session start |
| Agent 1 M1 plan | [AGENT1-M1-FLOW-HANDOFF.md](AGENT1-M1-FLOW-HANDOFF.md) |

Regenerate confs after editing JSON:

```bash
ETHERIS_SHARE=/usr/local/share/etheris etheris-tokens-generate
# or from the tree:
ETHERIS_SHARE=$PWD/profile/etheris/airootfs/usr/local/share/etheris \
  profile/etheris/airootfs/usr/local/bin/etheris-tokens-generate
```

## How apps use Flow

1. **Do not hard-code hex** in new Etheris UI when a token exists.
2. Call `etheris-theme-apply` (or `etheris theme <atmosphere>`) after changing theme-related settings.
3. GTK 3/4: rely on generated `~/.config/gtk-3.0/gtk.css` (+ gtk-4). Prefer shared classes:
   - `.etheris-card` · `.etheris-title` · `.etheris-caption` · `.etheris-muted`
   - `button.etheris-primary` · `button.etheris-ghost` · `button.etheris-danger`
   - `.etheris-focus-ring`
4. Shell surfaces (Waybar, Rofi, mako, foot, Sway colours) are written only by `etheris-theme-apply`.
5. Honour `~/.config/etheris/settings.conf`:
   - `animations=off|on|reduced` — GTK animations + `etheris-motion` + reduced-motion CSS
   - `blur=off` (default) — translucent panels via rgba; no compositor blur claim
   - `theme=` / Atmosphere packs under `share/etheris/themes/`

## Typography (honest)

| Role | Shipped on ISO | Notes |
|------|----------------|-------|
| UI | **Noto Sans** | Default Flow `fontUi`. Outfit is preferred when packaged; apply resolves via fontconfig. |
| Mono | JetBrainsMono Nerd Font | Terminal / code |
| Icons | Papirus / Papirus-Dark | Per Atmosphere |

## Motion contract

| Setting | Behaviour |
|---------|-----------|
| `animations=on` | GTK toolkit animations on; `etheris-motion` may run (opacity fade on map) |
| `animations=off` / `reduced` | GTK animations off; no motion helper; CSS transitions forced to 0 |

Motion must never block input or leave windows stuck. Sway remains the compositor; Flow does not replace it.

## Architecture

- **Compositor:** Sway  
- **Shell:** Waybar + Etheris scripts/GTK (Path A)  
- **Quickshell:** evaluate later; never dual-panel with Waybar  

See [ADR-ETHERIS-DESKTOP.md](ADR-ETHERIS-DESKTOP.md), [WINDOW-DECORATIONS.md](WINDOW-DECORATIONS.md), [DESIGN.md](DESIGN.md).
