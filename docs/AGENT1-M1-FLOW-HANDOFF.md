# Agent 1 → Agent 2 Handoff — Milestone 1: Etheris Flow

**Role:** Agent 1 (inspect / plan / gate)  
**Date:** 2026-11-13  
**Scope:** Desktop Experience Roadmap Milestone 1 — Etheris Flow Design System  
**Do not start:** Milestone 2 (WM animations maturity) until M1 critical gaps below are closed or explicitly waived.

## Progress (in-tree, 2026-11-13)

| Item | Status |
|------|--------|
| WP-F1 Flow docs | **Done** — `docs/FLOW.md` (+ airootfs copy) |
| WP-F2 / reliability | **Done** — theme-apply honours `animations=`; fontconfig UI font; Settings/CC re-apply |
| WP-F3 component classes | **Partial** — `.etheris-*` helpers in `gtk.css.tmpl` |
| WP-F4 typography honesty | **Done** — ISO default Noto Sans (Outfit preferred when installed) |
| WP-F5 motion contract | **Done** — GTK flag + reduced-motion CSS; docs |
| WP-F6 verification report | Pending ISO/VM evidence |

---

## 1. Verdict (Agent 1)

Etheris already has a **partial Flow foundation** under the Ocean Glass look. It is **not** Milestone-1 complete.

| M1 deliverable | Status | Notes |
|---|---|---|
| Complete Flow design specification | **Mostly done (blueprint)** | `design/phase-2/` — rename/brand as **Etheris Flow** still missing |
| Centralized design-token files | **Shipped** | `share/etheris/design/etheris.tokens.json` → `tokens-{dark,light}.conf` via `etheris-tokens-generate` |
| Reusable UI component library | **Spec + preview only** | `COMPONENTS.md` + HTML preview; **no shared runtime widget library** for GTK/shell apps |
| Light and dark themes | **Shipped** | Arctic Glow / Ocean Glass (+ Atmosphere packs) via `etheris-theme-apply` |
| Typography and iconography guidelines | **Spec done; UI font deferred** | Outfit specified; ISO still falls back (often JetBrainsMono). Icons: Papirus |
| Animation specification | **Spec + partial runtime** | Phase-1/2 motion docs; `etheris-motion` + `animations=` in settings |
| Accessibility guidelines | **Spec done; partial enforcement** | `ACCESSIBILITY.md`; reduced-motion path exists; contrast not systematically verified |
| Screenshots of representative components | **Preview HTML** | Not a VM/ISO component gallery report |
| Developer documentation (how to use Flow) | **Partial** | design README + ADR; no single **Flow developer guide** for app authors |

**Bottom line for Agent 2:** Do **not** redesign from scratch. Close the gap between Phase-2 blueprint and a **named, documentable, enforceable Flow** that all Etheris apps/shell surfaces consume.

---

## 2. Existing stack to reuse (do not duplicate)

### Design / tokens
- `design/phase-2/` — canonical Flow blueprint (previews, tokens CSS, acceptance)
- `profile/etheris/airootfs/usr/local/share/etheris/design/etheris.tokens.json` — runtime source of truth
- `tokens-dark.conf` / `tokens-light.conf` — generated conf for theme apply
- `design/templates/{gtk,waybar,wofi,mako,rofi*}.tmpl` — token substitution surfaces
- `etheris-tokens-generate`, `etheris-theme-apply`

### Shell / apps already themed
- Sway (compositor — **keep**; not Flow)
- Waybar, Rofi (launcher), mako, foot, ReGreet CSS
- GTK 3/4 via `gtk.css.tmpl` (CSD titlebuttons, surfaces)
- Settings / Control Center / power menu / wallpaper / widgets (scripts + GTK)

### Architecture invariants (binding)
1. **Sway = compositor**; shell ≠ compositor (`docs/WINDOW-DECORATIONS.md`, ADR).
2. **Blur off** by default; rgba glass is honest.
3. **One overlay at a time**.
4. No dual always-on panels (Waybar + Quickshell).
5. Quickshell only after RSS/CPU gates; Sway session must remain.
6. Do not replace Sway to get animations.

---

## 3. Gap analysis → Agent 2 work packages

### WP-F1 — Brand the design system as Etheris Flow
**Goal:** One product name across docs and share tree.

- Add `docs/FLOW.md` (or promote `design/phase-2/README.md`) as the Flow entry point: identity, tokens, components, motion, a11y, how apps consume Flow.
- Cross-link from `docs/DESIGN.md`, `share/etheris/design/README.md`, README.
- **Flow** is the design system; Ocean Glass is the default theme.
- Update `etheris.tokens.json` `meta.name` to include Flow (e.g. `"Etheris Flow"`) without breaking generators.

**Acceptance:** A new contributor can find “how to style an Etheris app” from one doc.

### WP-F2 — Token completeness audit (shipped vs JSON)
**Goal:** Generated confs and templates expose every token apps need.

Inspect and close mismatches:
- Geometry (`RADIUS_*`, spacing) — Stage 1 kept `RADIUS_PANEL=12` vs JSON `14`; document or converge deliberately.
- Motion tokens (`openMs`, `closeMs`, ease) — ensure settings/`etheris-motion` read the same source.
- Shadow / focus ring — present in JSON; verify templates use them where relevant.
- Reduced transparency / reduced motion — map settings keys → apply behaviour.

**Files likely touched:**
- `etheris-tokens-generate`
- `etheris-theme-apply`
- `tokens-*.conf`, templates
- `etc/skel/.config/etheris/settings.conf`

**Acceptance:** Theme switch updates all chrome; no hard-coded hex in new shell CSS outside generators.

### WP-F3 — Runtime component kit (minimal, GTK-first)
**Goal:** Reusable components, not only HTML preview.

Prefer **extend existing** GTK CSS + small shared helpers over a new framework:

1. Expand `gtk.css.tmpl` to cover Flow component classes used by Etheris GTK apps (buttons, switches, dialogs, lists, cards) matching `COMPONENTS.md` states.
2. Inventory Etheris GTK UIs (`etheris-settings`, `etheris-control-center`, `etheris-power-menu`, greeter CSS, defaults UI) and migrate one-off styles onto shared classes.
3. Optional: `share/etheris/flow/` with CSS snippets + short examples — **no** new heavy dependency.

**Do not:** Introduce Quickshell solely for a component gallery.  
**Do not:** Blind repo-wide CSS rewrite.

**Acceptance:** Settings + Control Center + power menu share the same button/dialog/focus treatment; theme switch visibly updates them.

### WP-F4 — Typography / icons enforcement
**Goal:** Guidelines match what users see.

- Decide and document: ship Outfit (or approved UI sans) **or** officially keep current fallback for alpha.
- Apply `FONT_UI` consistently in Waybar/Rofi/GTK/ReGreet.
- Confirm Papirus light/dark pairing per Atmosphere (already in JSON).

**Acceptance:** Doc ↔ ISO behaviour match; no “Outfit” claim if not packaged.

### WP-F5 — Motion + accessibility as Flow contracts
**Goal:** Flow owns the rules; WM/shell obey.

- Document Flow motion contract (durations, what may animate, reduced-motion).
- Wire `animations=off` / reduced-motion so GTK CSS transitions and `etheris-motion` both honour it (skel currently defaults `animations=off` — keep honesty).
- Contrast spot-check: body text on panel/menu rgba for dark + light.

**Acceptance:** Toggling animations off disables nonessential transitions; text remains readable on glass.

### WP-F6 — Evidence pack (M1 closeout)
**Goal:** Milestone report Agent 1 can sign off.

- VM screenshots: panel, launcher, CC, settings dialog, notification, light + dark.
- Short `out/VERIFICATION-FLOW-M1.md`: tokens path, theme switch, reduced-motion, no dual notification daemons, idle note if measured.
- List known limitations (Sway blur, SSD buttons, Outfit deferred, etc.).

**Acceptance:** All nine M1 deliverables mapped to files + pass/fail.

---

## 4. Explicit non-goals for Agent 2 (this milestone)

| Out of scope | Why |
|---|---|
| Custom compositor / replacing Sway | Roadmap + WM reliability doc |
| Full WM open/close animation maturity (M2) | Separate milestone; reliability > polish |
| Orbit widgets marketplace / overview rewrite | M4 |
| Hub redesign beyond Flow styling | M5 |
| GameView | M6 |
| Dual compositor experiments | Forbidden |
| Host OS destructive changes | Use disposable VM/ISO |

---

## 5. Milestone 2 preview (Agent 1 note — do not implement yet)

WM maturity requirements are **binding** when M2 opens:

- Reliability > appearance.
- Decorations honesty: Sway has **no** SSD close/min/max; panel `etheris-winctl` + GTK CSD only (`docs/WINDOW-DECORATIONS.md`).
- Animations must not block input or leave bad window state; reduced-motion required.
- Keep compositor vs shell separation; `etheris-motion` is shell/IPC, not a compositor.

Agent 2 may **only** touch WM surfaces in M1 if required to consume Flow tokens (colours/borders) — no new animation features.

---

## 6. Suggested Agent 2 sequence

1. WP-F1 (docs / naming) — small, unblocks clarity  
2. WP-F2 (token audit) — foundation  
3. WP-F4 (font honesty) — parallel with F2 if small  
4. WP-F3 (GTK component convergence) — main implementation  
5. WP-F5 (motion/a11y contracts)  
6. WP-F6 (VM evidence + verification report)  

Stop and report if ISO boot, login, or theme-apply regress.

---

## 7. Test commands (Agent 2)

```bash
cd ~/etheris-os
# Token regen (from share tree or staged)
ETHERIS_SHARE=profile/etheris/airootfs/usr/local/share/etheris \
  profile/etheris/airootfs/usr/local/bin/etheris-tokens-generate

# Theme apply in disposable HOME or live VM
etheris theme ocean-glass
etheris theme arctic-glow

# Soft desktop reload paths already used by theme-apply (waybar/mako)
# VM: virsh -c qemu:///session … (see SESSION-LOG.md)
```

Prefer disposable libvirt domain `etheris-os`; do not test installers on host disks.

---

## 8. Definition of Done (Milestone 1)

Agent 1 will accept M1 when:

1. Flow is the documented design-system name; Ocean Glass remains the default look.
2. Tokens remain single-sourced; generators are the write path.
3. Core Etheris GTK shell apps share Flow component styling.
4. Light/dark (+ Atmosphere) theme switching works without logout.
5. Typography claims match packages.
6. Reduced-motion / animations-off is respected by Flow surfaces.
7. `out/VERIFICATION-FLOW-M1.md` exists with screenshots and known limits.
8. No critical desktop regressions vs current ISO maturity smoke.

**Quality and integration beat speed.**
