# Incremental Implementation Roadmap (Phase 2)

**Gate:** Owner approval of this Phase 2 blueprint.  
**Constraint:** Respect master roadmap (M0–M6, ISO, OOBE). Do not skip unfinished core OS milestones for chrome.

Design stages below are **Neo-Aero shell work**, sequenced after/alongside verified ISO+install path.

---

## Stage 1 — Visual foundation — **DONE** (2026-11-08)

- Map `etheris.tokens.json` → OS conf/CSS generators — **done** (`etheris-tokens-generate`)
- Package Outfit (or approved fallback) — **deferred** (no new ISO dep; CSS falls back to JetBrainsMono)
- Icon policy (Papirus) + component CSS for GTK/wofi/waybar/mako — **done** (existing templates + FONT_UI placeholder)
- Light (Arctic) + dark bases verified — **done** (`out/VERIFICATION-STAGE1-TOKENS.md`)

**Exit:** `etheris theme` switches Ocean Glass ↔ Arctic Glow with soft reload; no session restart. **Met** (apply path tested in isolated `$HOME`).

## Stage 2 — Core desktop shell — **WP-S1 PASS** (baked + VM)

- Floating panel polish (Waybar Path A) — **verified**
- Launcher + overlay mutex + CC stub — **verified**
- ADR: `docs/ADR-NEO-AERO-DESKTOP.md`

## Stage 2+/3/4 desktop packages — **IN TREE** (second bake)

- **WP-S2** notifications + tray policy + richer CC — in tree  
- **WP-S3** decorations (normal titlebars + panel winctl + GTK CSD) — in tree · `docs/WINDOW-DECORATIONS.md`  
- **WP-S4** opacity motion + reduced-motion — in tree (honest Sway limits)

**Exit:** second ISO VM verify; then Stage 5 widgets only with approval.

## Stage 3 — System interface

- Control Center stub (GTK or Quickshell spike)
- Notification toasts themed; optional history panel
- Tray policy (panel **or** CC)
- Shortcut Center visual polish
- Decide Path A vs Path B shell using RSS/latency gates

**Exit:** Super+A / Super+N (or panel entry) work; one overlay at a time.

## Stage 4 — Personalisation

- Wallpaper picker UX
- Five Atmospheres fully mapped
- Theme selection in Settings Personalisation
- Optional panel layout (dock) behind setting

**Exit:** User changes Atmosphere without editing files.

## Stage 5 — Widgets

- Built-in: clock/weather/RAM (lightweight)
- Widget enable/disable; none default
- No marketplace

**Exit:** ≤3 widgets; RSS delta documented.

## Stage 6 — Full integration & polish

- Settings sections: Display, Sound, Keyboard, System
- Login appearance (LOGIN.md milestone)
- First-login guide / sounds / motion / a11y modes
- Performance testing vs baseline

**Exit:** Acceptance criteria in [ACCEPTANCE.md](ACCEPTANCE.md) checked.

---

## Explicit non-starts without new approval

Replace Sway · Quickshell-as-compositor · blur-by-default · Atmosphere cloud · dual Waybar+Quickshell panels · custom icon set wholesale before Stages 1–3
