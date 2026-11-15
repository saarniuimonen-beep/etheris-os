# Etheris P0 — Foundations (audit & architecture)

**Status:** **Complete** (foundations only) — 2026-11-08  
**Scope:** Tokens, light/dark direction, theme apply into existing shell, baseline metrics.  
**Evidence:** `out/BASELINE-ETHERIS-DESKTOP-P0.md`, `out/VERIFICATION-ETHERIS-DESKTOP-P0.md`  
**Not in P0:** Atmospheres product, widgets, Control Center, Quickshell shell, full Settings app.

## 1. Architecture audit (reuse)

| Surface | Component | Reuse for Etheris? |
|---------|-----------|---------------------|
| Compositor | **Sway** | **Yes — keep as fallback and default** |
| Panel | Waybar | Yes — restyle via generated CSS |
| Launcher | wofi | Yes — restyle; replace only if proven gap |
| Notifications | mako | Yes — generated config |
| Terminal | foot | Yes — `colors-dark` / `colors-light` |
| GTK apps | Adwaita + Papirus | Yes — light/dark Adwaita pairing |
| Session | `etheris-session` → Sway | Unchanged |
| Themes today | Thin `*.theme` | Extended to select token pack + wallpaper |
| Quickshell | **Not in tree** | Evaluate in P1+; must not replace Sway until proven |

### Sway vs Quickshell

- **Sway** is the Wayland compositor (window management, inputs, outputs).
- **Quickshell** (if adopted later) would be a **desktop shell** (panels/widgets/QS), not a compositor.
- P0 keeps Sway + Waybar/wofi/mako. Any Quickshell experiment must leave `etheris-session` → Sway working.

## 2. Design system delivery (P0)

Canonical tokens:

- `/usr/local/share/etheris/design/tokens-dark.conf` — Etheris dark (ocean)
- `/usr/local/share/etheris/design/tokens-light.conf` — Etheris light (arctic / sky)

Apply path:

`etheris theme <name>` → `etheris-theme-apply` writes user configs for waybar, wofi, mako, foot, sway colors, GTK preference — **no session restart required** (waybar USR2 / mako reload).

Blur remains **off by default** (efficient fallback = translucent solid rgba, no KWin-style blur).

## 3. Performance risks (P0 notes)

| Risk | Mitigation |
|------|------------|
| Heavy blur on full-screen panels | Not enabled; rgba panels only |
| Duplicate theme engines | Single apply script; no extra daemon |
| Quickshell + Waybar both resident | Do not ship both until evaluated |
| Token apply thrashing disk | Write only on theme change / session start |

## 4. Baseline method

See `out/BASELINE-ETHERIS-DESKTOP-P0.md` (VM idle after settle). Metric: `MemTotal − MemAvailable` from `/proc/meminfo` (same as `etheris ram`).

## 5. Recommended next (P1)

After P0 lands in ISO: panel layout polish, basic Control Center (wofi/foot), wallpaper UX improvements, optional first Atmosphere presets built on these tokens — still on Sway.
