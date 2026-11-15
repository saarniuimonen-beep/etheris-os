# Neo-Aero / Desktop Design Roadmap

**Date:** 2026-11-15  
**Depends on:** [`NEO-AERO-DESIGN.md`](NEO-AERO-DESIGN.md), [`DESKTOP-AUDIT.md`](DESKTOP-AUDIT.md), [`DEVELOPMENT-ROADMAP.md`](DEVELOPMENT-ROADMAP.md)

Visual work is **Medium** priority relative to installer/update/security **Critical** work. Sequence accordingly.

---

## Phase D0 — Unify naming (**done** 2026-11-15)

| Task | Outcome |
|------|---------|
| Declare Neo-Aero = design language; Flow = token engine | **Done** — glossary in DESIGN.md §0 |
| Update phase-2 “not applied” where tokens already ship | Honest status via audits |
| Keep Sway Path A ADR authoritative | No silent Hyprland default |

**Files:** `docs/DESIGN.md`, `design/phase-2/IDENTITY.md`, `docs/FLOW.md`  
**Test:** Docs consistency review only  

---

## Phase D1 — Token completeness (High within design)

| Task | Benefit | Risk |
|------|---------|------|
| Align JSON tokens with NEO-AERO-DESIGN tables | Consistency | Theme churn |
| Sync `design/phase-2/tokens` ↔ `share/.../etheris.tokens.json` (panel **28**/0) | **Done** (prepare-profile copies SoT) | Theme churn |
| Reconcile blur default (JSON vs skel) | **Done** (`blur=off` skel + JSON) | Menu frost opt-in |
| Ensure light + dark apply without breaking foot/mako/waybar | Cohesion | Regressions |
| Contrast checklist on ocean-glass + meadow | A11y | — |
| Fix DESIGN.md / phase READMEs (Rofi Path A; drop “not implemented”) | Doc honesty | — |

**Deps:** `etheris-tokens-generate`, `etheris-theme-apply`  
**Test:** VM theme switch screenshots  

---

## Phase D2 — Chrome polish (Medium)

1. Waybar spacing/iconography pass (no module explosion)  
2. Menu/CC visual alignment with preview HTML **intent** (not pixel-copy)  
3. Launcher slim/icon styles  
4. Greeter password-first + card polish (also Critical reliability)  
5. Lock screen brand + readability  

---

## Phase D3 — Signature features (Medium / after D2)

| Feature | Notes |
|---------|-------|
| Control Center IA expansion | Appearance, privacy, updates — wrap existing tools |
| Dynamic themes | Coordinate GTK/Qt-later/terminal/bar/launcher/wallpaper |
| Workspace profiles | User-reversible; off by default |
| System Monitor UI | Wrap sensors/perf; careful polling |

---

## Phase D4 — Experimental (explicitly gated)

- SwayFX evaluation behind flag  
- Video wallpapers  
- Advanced effects  

**Exit criteria for any compositor change:** idle RSS, crash fallback, owner ADR update, hardware smoke.

---

## Explicit non-schedule

- Copying unixporn dotfiles  
- Default Hyprland session  
- Shipping unfinished Quickshell beside Waybar  

---

## Success metrics

| Metric | Target |
|--------|--------|
| Theme switch breaks apps | 0 known on smoke path |
| Menu/launcher usable keyboard-only | Yes |
| Idle RAM with polish | Still within budget without Firefox |
| Design docs match ISO | Spot-check each bake |
