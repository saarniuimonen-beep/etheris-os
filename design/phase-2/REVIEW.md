# Phase 1 Design Review — Decisions for Phase 2

This document critiques Phase 1 (`design/phase-1/`) and records what Phase 2 changes. Phase 1 is **not** accepted wholesale.

---

## What Phase 1 got right

- Ocean Glass direction (aqua / turquoise / nature Atmospheres) without copying old Windows looks.
- Shared CSS token approach and Atmosphere remapping of colour + wallpaper only.
- Selective glass; blur off by default; ≤500 MiB as aspirational, not a hard cut of features.
- Correct architecture baseline: Etheris Light = Sway session brand, **not** a compositor.
- Login / splash as concepts only while tuigreet ships.

---

## Weaknesses and inconsistencies

| Area | Issue | Phase 2 decision |
|------|-------|------------------|
| Desktop | Dock **and** desktop icons **and** floating panel competed in one viewport | **Default Light desktop:** thin edge-to-edge top bar only + one example window. Desktop icons off by default. Optional dock = layout preference, not default. |
| Widgets | Shown as always-on chrome in extras | Widgets are **opt-in**; none on default desktop. Max 2–3 lightweight widgets when enabled. |
| Launcher | Categories + pins look polished but exceed what wofi can do | Spec remains the **target UX**. Implementation path: theme wofi first (search/pins via wrapper), then Quickshell/custom launcher if gaps remain. |
| Control Center | No power actions; DND duplicated; felt like a tile collage | Compact sheet: 2×2 toggles, audio/brightness sliders, **notification mute**, power row (lock/logout/sleep), link to Settings. Width ≤360px. |
| Settings | Incomplete IA (missing Display / Sound / Keyboard / System) | Full sidebar IA locked in Phase 2. |
| Notifications | Toasts only; no center / history behaviour | Toast (mako) always; Notification Center = optional history panel; **mutually exclusive** with Control Center. |
| Panel vs tray | Unclear what lives in panel vs CC | Panel: workspaces, clock, network/audio/battery **summaries**, CC chevron. Details live in CC. |
| Type | Outfit chosen but not packaged in OS | Keep Outfit as design face; Stage 1 packages font or ships fallback (see TYPOGRAPHY). |
| Tokens | CSS vars only; no machine-readable JSON | Add `tokens/etheris.tokens.json` as source of truth. |
| Architecture | Quickshell mentioned cautiously; Phase 2 brief **permits** evaluating it as shell foundation | Blueprint: **Sway forever as compositor**. Shell path A = Waybar/wofi/mako; Path B = Quickshell shell with Waybar **cutover** (never dual). Stages 1–2 prefer Path A; Path B gated after RSS/latency gates. |
| Extras | Boot/guide/shortcuts were mood boards | Each gets interaction + token rules; still deferred in roadmap Stage 6. |

---

## Significant design decisions (Phase 2)

1. **One primary overlay at a time** — Launcher, Control Center, Notification Center, Shortcut Center, Power Menu: opening one closes the others.
2. **No Mac-style dock by default** — Etheris Light stays panel-first for RAM and clarity; dock is optional personalisation.
3. **Atmospheres are not five DEs** — Identical radii, type, spacing, panel layout; only colour tokens + wallpaper (+ optional light/dark variant) change.
4. **Glass = rgba first** — Compositor blur remains off; premium one-shot blur only on Power Menu (already in OS as concept).
5. **Quickshell is shell-only** — Explicitly allowed for panel/CC/widgets **after** gates; never replaces Sway; crash recovery returns to Sway + minimal Waybar fallback unit.
6. **Master roadmap wins** — Design stages map under M6+/desktop work; do not skip installer/OOBE/ISO gates for chrome.

---

## Carry-forward unchanged

- Colour family (ocean / aqua / turquoise / greens).
- 4px grid; control radius 8; menu 14; dialog 16.
- JetBrains Mono for terminal only.
- Five Atmosphere names already in tree packs.
