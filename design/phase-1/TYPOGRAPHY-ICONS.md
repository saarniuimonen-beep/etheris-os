# Etheris OS — Typography & Icon Guidelines

## Typography

### Families

| Role | Family | Where |
|------|--------|-------|
| UI sans | **Outfit** (300–700) | Panels, menus, dialogs, Settings, launcher, login |
| Mono | **JetBrains Mono** | Terminal (foot), code, Shortcut Center keycaps optional |

Do not mix a third family in the same popup. Do not use Inter / Roboto / Arial / system-ui as the brand UI face in new Etheris chrome.

### Hierarchy

| Role | Size | Weight | Line |
|------|------|--------|------|
| Display | 40px | 700 | 1.2 |
| Title | 22px | 600 | 1.2 |
| Heading | 18px | 600 | 1.3 |
| Body | 14px | 400–500 | 1.45 |
| Caption | 12px | 400–500 | 1.4 |
| Micro | 11px | 500 | 1.3 |

Panel clock / status: caption, tabular nums.  
Login brand: display or large title.  
Keycaps in Shortcut Center: mono or micro sans with tracked letter-spacing.

### Rules

- Prefer sentence case in UI; ALL CAPS only for short power-action labels if needed.
- Never set body text below 12px at 100% scale.
- Maintain contrast: dark FG on light surfaces ≥ 4.5:1 for body; large titles ≥ 3:1.

---

## Icons

### Direction (spec)

- Soft **outlined geometric** icons with slight corner roundness.
- Consistent stroke (~1.75–2px at 24px).
- Cool aqua/teal monochrome in chrome; full-colour app icons only for launcher tiles.
- Inspired by Papirus clarity — not skeuomorphic glossy icons.

### Sizes

| Context | Size |
|---------|------|
| Inline / menu | 16 or 20 |
| Panel / tray | 16–20 |
| Launcher grid | 32–48 |
| Desktop / dock | 48–56 |
| Empty states | 64 |

### Until a custom set ships

Keep **Papirus** / **Papirus-Dark** in the OS (already packaged). Phase 1 does not replace icon themes. Custom Etheris icon set is a later, approval-gated milestone.

### Don’t

- Mix emoji and symbolic icons in the same control row without reason.
- Ship blank gear placeholders in Etheris chrome.
- Recolour every Papirus glyph to neon — use accent sparingly on active states.
