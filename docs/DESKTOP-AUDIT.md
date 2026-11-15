# Etheris OS — Desktop Audit

**Date:** 2026-11-15  
**Compositor:** **Sway** (packages + live verification). Hyprland is **not** the default.

---

## Current architecture (Path A)

Per [`ADR-ETHERIS-DESKTOP.md`](ADR-ETHERIS-DESKTOP.md):

| Role | Component |
|------|-----------|
| Compositor | Sway |
| Panel | Waybar |
| Launcher | Rofi (preferred) / wofi fallback via `etheris-launcher` |
| Notifications | mako |
| Control Center / Menu | `etheris-control-center` (GTK4 + layer-shell / fallback) |
| Power | `etheris-power-menu` |
| Settings | `etheris-settings` |
| Theme pipeline | `etheris-theme-apply` + `etheris-tokens-generate` |
| Greeter | greetd + ReGreet (`etheris-greeter`) |
| Files | PCManFM (`etheris-files`) |
| Terminal | Foot |
| Portals | xdg-desktop-portal-wlr |

**Verified 2026-11-15:** Waybar brand + Menu chip, Super+A Menu sheet, Super+D icon launcher, desktop session.

---

## Naming collision (important)

| Name | What it is |
|------|------------|
| **Etheris Flow** | **Canonical design system** — tokens, `docs/FLOW.md`, generators, GTK comments |
| **Etheris Desktop** | Product / session brand (panel, greeter, ADR Path A) |
| **Ocean Glass** | Default Atmosphere |
| **Neo-Aero** | Visual *direction* / initiative name (calm glass, quiet motion) — **not** a second token system |

Phase-1/2 READMEs still say “not implemented” / “ISO not modified” — **stale** relative to shipped Path A. Treat **Neo-Aero ⊂ Flow ⊂ Etheris Desktop** in docs; do not invent a parallel token brand.

Follow-up detail from read-only design audit ([Neo-Aero design audit](3a6f1065-0042-4afe-9bbc-e5e191a3fa1e)).

---

## Component inspection (gaps)

| Component | Inconsistent / weak areas |
|-----------|---------------------------|
| Waybar | Height **28** flush top in skel; shipped `etheris.tokens.json` still lists panel **40**/offset **14** (Phase-1 floating) — **token drift** |
| Launcher | **Rofi** Kickoff is Path A; wofi remains fallback. Some docs still say wofi-primary (**stale**) |
| Notifications | mako tokenized; history/UI policy incomplete vs CC |
| Lock screen | swaylock — limited branding vs ReGreet; hard-coded colours in places |
| Wallpaper | Strong atmospheres; licensing OK if kept first-party |
| Window decorations | SSD = title strip only; no fake SSD buttons (`WINDOW-DECORATIONS.md`) |
| GTK vs Qt | GTK4 first-party; Qt not default (good for weight) |
| Hover Menu | Helper ships; layer-shell support false on live Sway → evdev fallback |
| Blur policy | JSON `blurDefault: off` vs skel `blur=on` (one-shot grim for Menu) — reconcile |
| Font | Spec Outfit; ISO ships **Noto Sans** (+ Liberation) — document as ISO face |
| Panel wordmark | Spec lowercase `etheris`; shipped Waybar uses **Etheris** Title Case |

---

## Accessibility / usability

| Topic | State |
|-------|--------|
| Reduced motion | Settings + Flow CSS path |
| Keyboard shortcuts | Documented partially (`KEYBOARD.md`); Super+A/D verified |
| Screen reader | **Unverified** / likely weak on custom GTK overlays |
| Contrast on glass | Risk if transparency too high — keep solid elevated fallback |
| Text scaling | Partial via settings; needs audit |

---

## Proposed desktop improvements (priority)

1. **Critical:** Greeter password-first (reliability, not chrome)  
2. **High:** Single design-token source branded Neo-Aero; retire contradictory “not applied” wording once tokens match IDENTITY  
3. **High:** Control Center sections map (network/audio already); avoid duplicate Settings  
4. **Medium:** Lock screen Neo-Aero pass  
5. **Medium:** Notification hierarchy  
6. **Experimental:** SwayFX / Hyprland — **out of scope** until reliability + ADR revisit  

Do **not** copy unixporn rice configs wholesale. Prefer original tokens + measured UX.
