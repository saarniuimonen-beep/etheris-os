# Etheris OS — Animation & Interaction Guidelines

## Principles

1. **Restrained** — Motion clarifies hierarchy; it never entertains.
2. **Fast** — Open ≤180ms; hover ≤80ms; page crossfade ≤220ms.
3. **Interruptible** — Prefer CSS transitions that cancel cleanly.
4. **Optional** — Honour `prefers-reduced-motion` and settings `animations=off`.

Easing: `cubic-bezier(0.22, 1, 0.36, 1)` (`--eth-ease-out`).

---

## Patterns

| Interaction | Motion |
|-------------|--------|
| Menu / launcher open | Fade + scale 0.97→1, 180ms |
| Menu close | Fade out 120–150ms |
| Hover colour | ≤80ms |
| Toggle thumb | 180ms transform |
| Control Center / dialog | Same as menu open; scrim fades |
| Atmosphere switch | Crossfade wallpaper/accent ≤220ms (no parallax) |
| Boot splash mark | Soft opacity pulse ≤1.2s loop **only** on splash; stop when session ready |
| First-login guide | Panel slide 8–12px + fade |

---

## Forbidden

- Bounce / overshoot springs on chrome
- Parallax wallpaper
- Long delays before focus lands
- Continuous animated backgrounds in default Atmospheres
- Stacked competing transitions on the same node

---

## Reduced motion

When reduced:

- Duration tokens → 0
- Show/hide without scale
- Splash mark static
- Atmosphere switch instant colour swap

Preview: `[data-motion="reduced"]` or OS `animations=off`.
