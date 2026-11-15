# Etheris OS — Prioritised Implementation Plan

**Gate:** Owner must approve Design Phase 1 (`design/phase-1/`) before any of the following changes land in `profile/etheris/airootfs/`.

---

## Done already (not this phase)

| ID | Item |
|----|------|
| P0 | Theme tokens + `etheris-theme-apply` + theme packs + baseline ≤500 MiB |
| — | Power menu GTK concept in OS (may be restyled to match Phase-1 tokens later) |

---

## After approval

### P1a — Token bridge

- Align `tokens-dark.conf` / `tokens-light.conf` with Phase-1 semantic names where needed.
- Extend Atmosphere packs (accent + surface tint) without changing geometry.
- Update waybar / wofi / mako / foot templates from the Phase-1 token set.

**Exit:** `etheris theme ocean-glass|aurora|meadow|arctic-glow|midnight-ocean` soft-reloads chrome; no session restart.

### P1b — Panel + launcher polish

- Floating pill panel spacing, workspace dots, status pills per preview.
- Deep-theme wofi: search-first, pins layout if feasible, focus/hover states, Outfit if packaged.

**Exit:** Super+D and panel match design language; keyboard-first intact.

### P1c — Control Center stub + wallpaper UX

- Overlay: network, BT, audio, brightness, battery, DND, shortcuts into settings.
- Atmosphere / wallpaper picker UX (reuse packs).

**Exit:** One entry point from panel; RAM impact documented.

### P1d — Settings foundation

- Personalisation: theme, Atmosphere, wallpaper, reduced motion/transparency.
- Prefer token-driven GTK or small dedicated UI; keep `etheris` CLI.

**Exit:** User can change Atmosphere without editing conf files by hand.

### P2 — Broader identity (separate approvals)

- Notification center (mako + optional history)
- Desktop widgets (opt-in)
- First-login guide / Shortcut Center visual polish
- Boot splash branding
- Login/greeter per `docs/LOGIN.md` (only when that milestone is opened)

---

## Explicit non-starts (need new written approval)

- Replacing Sway
- Shipping Quickshell as compositor
- Blur-by-default on panels
- Atmosphere “cloud” / marketplace
- Dual Waybar + Quickshell always-on panels
- Replacing Papirus with a full custom icon set before a dedicated milestone

---

## Suggested review order for the owner

1. Open `preview/index.html`
2. Walk Desktop → Launcher → Control Center → Settings → Login
3. Compare Atmospheres page
4. Read IDENTITY + ARCHITECTURE + this plan
5. Approve / request changes **before** P1a coding
