# Etheris OS — Accessibility & Performance Considerations

## Accessibility

### Contrast & type

- Body text ≥ **4.5:1** against its surface (light and dark Atmospheres).
- Large titles ≥ **3:1**.
- Never rely on colour alone for state (pair with icon, label, or weight).
- Minimum body 12px at 100% scale; target 14px.

### Focus & keyboard

- Every interactive control has a **visible focus ring** (`--eth-focus-ring`).
- Launcher, Control Center, Settings, Shortcut Center: full keyboard paths.
- Login concept: Tab between user / password / session / power; Enter submits.

### Alternatives

| Setting | Behaviour |
|---------|-----------|
| Reduced transparency | Solid elevated surfaces; no rgba glass |
| Reduced motion / `animations=off` | Instant show/hide; static splash |
| High contrast (future) | Stronger borders; accent ≥ opaque hairlines |

### Pointer & scale

- Hit targets ≥ 36px where practical (toggles 44×26 ok with padding).
- Design verified conceptually at 1280×800, 1920×1080, 125% / 150% scale.

---

## Performance (identity constraint)

Etheris’s look must stay smooth on modest hardware and inside the ≤500 MiB idle RAM goal.

| Do | Don’t |
|----|-------|
| RGBA translucent panels | Full-screen permanent compositor blur |
| Static SVG/JPG wallpapers | Looping animated wallpaper by default |
| Soft-reload themed CSS | Extra always-on cosmetic daemons |
| One soft shadow | Multi-layer shadow stacks / glow farms |
| Theme Waybar / wofi / mako | Dual shells (Waybar + Quickshell) until evaluated |
| One-shot blur for rare overlays | Blur on every panel |

### Risk notes for later implementation

- SVG wallpapers may spawn `glycin-svg` (~30 MiB) — watch RSS.
- GTK4 power menu is transient — fine when closed.
- Quickshell, if adopted, must not run beside a full Waybar stack without a deliberate cutover.
