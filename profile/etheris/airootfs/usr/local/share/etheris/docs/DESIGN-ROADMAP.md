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

## Phase D2 — Chrome polish (Medium) — **done (tree)**

1. Waybar spacing/hairline pass (skel) — **done**  
2. Menu/CC foot links Privacy + Apps + Updates — **done**  
3. Launcher slim width/border polish — **done** (`etheris-slim.rasi`)  
4. Greeter password-first — **done** (reliability)  
5. Lock screen brand — **done** (`etheris-lock` ocean-glass swaylock colors)  

*Needs rebake for live ISO proof of lock/launcher CSS.*

---

## Phase D3 — Signature features (Medium / after D2) — **done (CLI/UI stubs)**

| Feature | Notes |
|---------|-------|
| Control Center IA expansion | Privacy + Apps + Updates; Settings Privacy/Software pages |
| Dynamic themes | Via `etheris theme` / Flow (existing) |
| Workspace profiles | **`etheris profiles`** save/load |
| System Monitor UI | **`etheris monitor`** CLI wrap |

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
