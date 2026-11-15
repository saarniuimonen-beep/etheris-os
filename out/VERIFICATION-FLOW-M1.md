# Verification — Etheris Flow M1 (partial, 2026-11-13)

Host-side / disposable HOME checks. Full ISO/VM gallery still pending rebake.

## Changes under test

- `docs/FLOW.md` (+ airootfs docs copy)
- `etheris-theme-apply`: fontconfig UI font; `animations=` → `gtk-enable-animations` + reduced-motion CSS
- `etheris-settings` / `etheris-control-center`: force theme re-apply on animation toggle
- Tokens: `FONT_UI=Noto Sans` (Outfit preferred when installed)
- `gtk.css.tmpl`: `.etheris-*` Flow helper classes
- Static Rofi themes: Noto Sans (match ISO packages)

## Checks run

| Check | Result |
|-------|--------|
| `etheris-tokens-generate` writes FONT_UI=Noto Sans | **PASS** |
| `animations=off` → `gtk-enable-animations=0` + reduced-motion CSS appended | **PASS** (temp HOME) |
| `animations=on` → `gtk-enable-animations=1`, reduced block absent | **PASS** (temp HOME) |
| Resolved font = Noto Sans on host with noto-fonts | **PASS** |
| ISO live smoke of this tree | **Not yet** (needs rebake) |

## Known limitations

- Outfit not packaged; claim is preferred-when-available only.
- Sway still has no SSD window buttons (documented).
- Blur remains off; glass is rgba.
- Component library is CSS helpers + Phase-2 HTML preview — not a separate widget toolkit.
- WP-F6 screenshots on live ISO pending next build.
