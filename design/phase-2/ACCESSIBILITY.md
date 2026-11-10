# Accessibility Requirements (Phase 2)

## Contrast & type

- Body text ≥ **4.5:1** on its surface (all Atmospheres).
- Large text / titles ≥ **3:1**.
- Do not convey state by colour alone.
- Minimum body 12px @ 100%; target 14px.
- Support 125% and 150% scale at 1280×800 and 1920×1080.

## Focus & keyboard

- Visible focus ring on all interactive controls (`focusRingPx` + `accentSoft`).
- Full keyboard paths for Launcher, CC, Notification Center, Settings, Shortcut Center, Login concept.
- Overlay Esc-to-close; focus restore on close.

## Modes

| Preference | Behaviour |
|------------|-----------|
| `animations=off` / `prefers-reduced-motion` | Zero-duration transitions; static splash |
| `blur=off` (default) | No compositor blur |
| Reduced transparency | Solid `bgElevated` surfaces |
| High contrast (future) | Stronger borders; opaque accent hairlines |

## Hit targets

- Prefer ≥36px; toggles 44×26 with padding OK.
- Power and destructive actions require clear labels (not icon-only without tooltip).

## Assistive tech (implementation later)

- GTK/Qt apps inherit toolkit a11y.
- Custom Quickshell/GTK overlays must expose accessible names/roles.
- Do not remove tuigreet accessibility until LOGIN replacement proves parity.
