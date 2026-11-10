# Etheris OS — UI Component Specifications

All components consume shared tokens from [TOKENS.md](TOKENS.md). Preview reference: `preview/*.html`.

---

## States (every interactive control)

| State | Spec |
|-------|------|
| Normal | Default surface + border |
| Hover | ≤80ms; border → accent or brightness +4–6% |
| Focus (keyboard) | Visible ring `0 0 0 3px accent-soft`; never remove |
| Pressed | Scale ≤0.98 or inset highlight |
| Selected | Accent border + soft accent fill |
| Disabled | Opacity ~0.45; no hover motion; not-focusable where invalid |
| Error | Danger border + caption under field |
| Loading | Replace label with quiet spinner or progress; keep layout stable |

---

## Buttons

| Variant | Use |
|---------|-----|
| Primary | One main action; gradient accent → accent; dark ink on bright aqua |
| Ghost / secondary | Highlight fill + border |
| Danger | Soft danger fill + danger text (Shutdown, destructive) |
| Icon | Square control radius; 36–40px hit target minimum |

Padding: 10×16. Radius: `--eth-radius-control` (8).

---

## Inputs

- Background `--eth-input`, border `--eth-border`, radius 8.
- Placeholder `--eth-fg-subtle`.
- Focus: accent border + focus ring.
- Error: danger border; helper text caption danger.
- Password: same field; reveal toggle optional ghost icon button.

---

## Toggle

- Track 44×26, pill radius.
- Off: elevated bg + border.
- On: accent-tinted track; thumb moves 18px; thumb ink dark on bright.
- Must be operable by Space when focused.

---

## Slider

- Track 6px pill; thumb 16px circle with accent fill + light border.
- Used for volume, brightness; show value caption when useful.

---

## Menus & dropdowns

- Surface `--eth-menu`, radius 14, single soft shadow, hairline border.
- Item height ≥36px; padding 10×12.
- Hover/selected: accent-soft fill.
- Separators: 1px border at 40% opacity.
- Open motion: opacity + scale from 0.97 (≤180ms).

---

## Dialogs & sheets

- Radius 16; max width ~420–520 for confirmations; larger for Settings panes.
- Title heading + muted body + footer actions (secondary left / primary right, or stacked on narrow).
- Scrim: dark 30–40% over desktop — **no** full-screen blur required.

---

## Notifications (toast)

- Width ~360; radius 14; accent bar or icon leading.
- Title caption semibold + body muted.
- Auto-dismiss quiet; action chip optional.
- Stack from top-right with 8px gap (mako alignment).

---

## Panel (floating)

- Pill radius; translucent panel rgba; workspace dots; clock; status pills.
- Height ~40px; horizontal padding 14; top offset ~14px centered.

---

## Launcher tile

- Icon well 52×52, radius 14, gloss inset, accent-tinted gradient.
- Label caption under tile; selected ring focus.

---

## Window chrome (concept)

- Titlebar elevated + gloss; traffic-light dots muted (decorative in mock; Sway may keep border-only).
- Client radius 12; border accent when focused.
