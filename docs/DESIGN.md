# Etheris OS — Visual Polish & Unified Desktop Design

**Status:** Theme foundations **landed** (tokens + apply pipeline). Panel geometry SoT is phase-2 tokens (**28**/0); blur default **off**.

**Authority:** Master roadmap + `docs/ETHERIS-DESKTOP-P0.md` + [AGENT1-M1-FLOW-HANDOFF.md](AGENT1-M1-FLOW-HANDOFF.md) + [NEO-AERO-DESIGN.md](NEO-AERO-DESIGN.md). Do not replace Sway or ship Quickshell until evaluated with the working fallback preserved.

Related: `docs/LOGIN.md`, `docs/OOBE.md`, `docs/FLOW.md`, baseline `out/BASELINE-ETHERIS-DESKTOP-P0.md`.

---

## 0. Glossary (Neo-Aero ⊂ Flow)

| Term | Meaning |
|------|---------|
| **Neo-Aero** | Design **language** — glass, ocean atmospheres, motion, IA (see NEO-AERO-DESIGN) |
| **Flow** | Design **engine** — `etheris.tokens.json` → `tokens-*.conf` → `etheris-theme-apply` |
| **Path A** | Compositor stays **Sway**; Rofi launcher; GTK Menu/Session sheets |
| **Path B** | Experimental shells/compositors — gated; not default |

Neo-Aero is expressed **through** Flow tokens; they are not competing systems.

---

## 1. Current architecture (inspect)

Etheris Light is a **Sway + small Wayland toolkit** stack, not a full DE shell.

| Surface | Component today | Themeable? |
|---------|-----------------|------------|
| Compositor / chrome | **Sway** (fallback + default) | Client borders via `config.d/20-etheris-colors` |
| Panel | Waybar | Generated CSS from tokens |
| App launcher | **Rofi** Kickoff via `etheris-launcher` (wofi fallback) | Generated / themed rasi |
| Notifications | mako | Generated config |
| Terminal | foot | `colors-dark` / `colors-light` from tokens |
| GTK 3/4 apps | Adwaita (+ dark) + Papirus | `settings.ini` from theme pack |
| File manager | PCManFM | Mostly GTK |
| Lock | swaylock solid color | Color from tokens |
| Session apply | `etheris apply-session` → `etheris-theme-apply` + wallpaper | Soft reload (no session restart) |
| Theme packs | Etheris `*.theme` + `design/tokens-{dark,light}.conf` | Shared design system |
| Wallpapers | SVG (ocean-glass, arctic-glow, aurora, meadow, midnight-ocean, …) | Brand assets |
| Power / logout | **`etheris-power-menu`** Session sheet · `etheris logout-menu` entry | Ocean-glass list (not tile grid) |
| Quick settings / Menu | **`etheris-control-center`** GTK sheet · wofi `--menu` fallback | Path A landed; Quickshell optional later |
| Quickshell | **Not in tree** | Shell only if adopted later; never confuses with compositor |

**Principle:** Shared tokens + generators. Do **not** swap Sway for aesthetics alone.

---

## 2. Design goals

- One cohesive OS look: menus, dialogs, pickers, and shell chrome share language.
- Clean, refined, lightweight — distinctive Etheris branding, not a clone of another OS.
- Predictable interaction states; subtle motion; strong keyboard a11y.
- Idle RAM discipline: no heavy shell frameworks; avoid blur farms and decorative GPU waste.

---

## 3. Etheris design system (proposed)

### 3.1 Brand character

- **Atmosphere:** cool ocean blues, turquoise accents, soft whites; dark mode uses deep blues/greens.
- **Tone:** translucent panels where useful, without heavy blur or decorative effects; keep it light and readable.
- **Name in UI:** “etheris” mark in panel; full “Etheris OS” on lock/login/first-boot/guide.

### 3.2 Color tokens (semantic) — shipped P0

Canonical files:

- `/usr/local/share/etheris/design/tokens-dark.conf`
- `/usr/local/share/etheris/design/tokens-light.conf`

| Token | Role | Ocean Glass (dark) |
|-------|------|--------------------|
| `BG` | Shell background | `#0a1628` |
| `BG_ELEVATED` | Menus / elevated | `#122338` |
| `FG` / `FG_MUTED` | Primary / secondary text | `#e8f4fc` / `#a8c4d8` |
| `ACCENT` / `ACCENT_2` | Brand / secondary | `#38bdf8` / `#2dd4bf` |
| `BORDER_RGBA` | Hairline / chrome | aqua @ ~28% |
| `SUCCESS` / `WARNING` / `DANGER` | Semantic | green / amber / rose |
| Panel/menu rgba | Translucent glass without blur | `BG_PANEL_RGBA`, `BG_MENU_RGBA` |

Default pack: **ocean-glass**. Light pack: **arctic-glow**. Others (aurora, meadow, midnight-ocean, mist alias) select variant + accent + wallpaper.

### 3.3 Typography

| Role | Guidance |
|------|----------|
| UI sans | Prefer a readable UI font for menus/dialogs (evaluate Inter-class **or** keep JetBrains for terminal-only) |
| Mono | JetBrainsMono Nerd Font — terminal, code, optional panel |
| Hierarchy | Title / body / caption sizes locked (e.g. 18 / 13 / 11) |
| Avoid | Mixing three+ families in one popup |

**Decision at implementation:** either (A) UI sans + mono terminal, or (B) mono-forward Light identity. Document choice in tokens; apply everywhere.

### 3.4 Geometry & depth

| Rule | Value (proposal) |
|------|------------------|
| Radius — controls | 8px |
| Radius — menus/dialogs | 12–14px |
| Spacing unit | 4px grid (8/12/16 padding) |
| Border | 1px default; 2px only for primary chrome if needed |
| Shadow | Optional soft single-layer; **no** stacked multi-shadow |
| Blur | **Off by default** (`blur=off` already in settings); translucent panels OK without blur |

### 3.5 Icons

- Default: **Papirus** (already packaged) — one family end-to-end.
- Sizes: 16 / 24 / 32 / 48; menus use 24 or 32 consistently.
- No mixed emoji+symbolic in the same row without reason.
- Missing icons: fix `.desktop` / theme inheritance; never ship generic “blank gear” placeholders in Etheris chrome.

### 3.6 Motion

| Use | Spec |
|-----|------|
| Menu open/close | ≤150–200ms opacity/scale; GPU-friendly |
| Hover | Instant or ≤80ms color |
| Reduced motion | Honor `animations=off` / a11y; skip transitions |
| Forbidden | Bounce, parallax, long delays before focus |

### 3.7 Component states (all interactive chrome)

Normal · Hover · Pressed · Selected · Keyboard-focused (visible ring) · Disabled · Loading · Empty · Error.

Shared CSS/class names or GTK style classes where applicable.

### 3.8 Reusable delivery

1. **Canonical tokens** file(s).  
2. **Generator / `etheris theme apply`** writes derived `waybar/style.css`, `wofi/style.css`, `mako/config`, Sway colors, GTK settings, foot colors.  
3. Optional small GTK CSS under `~/.config/gtk-3.0/gtk.css` / gtk-4 for dialogs.  
4. Future login/OOBE/welcome **import the same tokens** — no one-off palettes.

---

## 4. Application menu & launcher (priority surface)

### Today

wofi center `drun`, basic CSS, prompt `etheris`, icons via `-I`. No categories, favorites, recents, or descriptions beyond what `.desktop` provides.

### Target experience

- Organized layout; consistent icons; search focused **immediately** on open.
- Categories; recently used; favorites/pins.
- Clear names + optional descriptions.
- Hover / selected / focused states; keyboard-first (already strong in wofi).
- Subtle open/close motion; not a stock launcher with a tinted background.

### Implementation approach (milestones, not now)

| Phase | Approach |
|-------|----------|
| **L1** | Deep-theme wofi: spacing, states, empty/search, icons, fonts from tokens |
| **L2** | Wrapper script: favorites/recents files + filtered drun / frequency sort **if** wofi can express it |
| **L3** | Only if L1–L2 fail product bar: evaluate **nwg-drawer** / similar **lightweight** Wayland launcher—still token-driven; keep Super+D binding |

Do not adopt Plasma/GNOME overview shells for Light.

---

## 5. Selectors, pickers, dialogs

| UI | Plan |
|----|------|
| Open / save / folder | GTK file chooser via Adwaita + Etheris gtk.css tokens |
| Open with / MIME defaults | Document + theme xdg tools; avoid custom heavy UI until needed |
| Install/remove apps | Prefer existing pacman/Flatpak UIs later; style via GTK; no fake store chrome yet |
| Session selection | greetd/tuigreet (LOGIN.md) — same colors when customized |
| Logout / power | Replace bare CLI with small branded dialog (foot+wofi or GTK) using tokens |

Fix cramped layouts by enforcing spacing tokens—not one-off pixel tweaks.

---

## 6. Other desktop elements (unified backlog)

| Element | Current | Polish direction |
|---------|---------|------------------|
| Quick settings | Scattered | Waybar flyouts or one QS popup (volume/brightness/network/bt) — light |
| Notification center | mako only | Theme mako; optional history later |
| Volume / brightness | Keys + pavucontrol | OSD toast (mako or swayosd-class tool) styled |
| Network / Bluetooth | nmtui / none | Themed entry points; NM applets if RAM OK |
| Calendar / clock | Waybar tooltip | Richer clock popup optional |
| Workspace overview | Sway workspaces | Keep; style urgent/focus |
| Window switcher | Sway defaults | Theme if using `swayr`/`roto` later—optional |
| Context / desktop menu | Minimal | Optional `etheris desktop-menu` via wofi |
| System settings | `etheris` CLI | Grow carefully; GUI settings later still token-based |
| Login / OOBE / welcome / shortcuts | Specs / stubs | Consume design system when those milestones run |

---

## 7. Performance & Wayland

- No extra always-on daemons for cosmetics.  
- Prefer CSS opacity over blur.  
- Menus must open on first Super+D without hitch on 2 GiB VM-class hardware.  
- Test 1280×800, 1920×1080, 125%/150% scaling.  
- All shell UI is Wayland-native (current stack already is).

---

## 8. Quality assurance (when implementing)

- Walk the full session: panel → launcher → terminal → files → notification → logout.  
- Light + dark; multiple theme packs.  
- Keyboard-only and mouse paths; focus rings visible.  
- Compare dialogs side-by-side for token drift.  
- `etheris ram` before/after; reject changes that blow Light budget for decoration.  
- No component “done” while placeholder icons or broken foot/theme apply remain.

---

## 9. Implementation milestones (approval-gated)

| ID | Milestone | Exit criteria |
|----|-----------|---------------|
| **P0** | Theme foundations | **Done** — tokens, packs, `etheris-theme-apply`, baseline ≤500 MiB; Sway fallback kept |
| **P1 / V2** | First usable Etheris desktop | Panel/launcher polish, Control Center stub, wallpaper UX, basic widgets, Settings foundation |
| **P2 / V3+** | Complete Etheris identity | Atmospheres product, expanded widgets, icon/sound polish |
| **P3** | Future | Widget marketplace, advanced effects — not blocking installable OS |

**Explicit non-starts without approval:** replacing Sway, shipping Quickshell as compositor, Atmospheres cloud, blur-by-default.

---

## 10. Acceptance criteria (future)

- [ ] Documented token set + light/dark.  
- [ ] Shell components share radii, spacing, accent, focus rings.  
- [ ] Launcher meets §4 without feeling stock-skinned.  
- [ ] `etheris theme` / apply-session keeps files in sync.  
- [ ] Reduced motion / high contrast respected.  
- [ ] No regression to live login/Sway; RAM target still credible.  
- [ ] Written approval before V2+ tool replacements.

---

## Immediate priority reminder

P0 tokens/apply are in tree. Next: **ISO bake** (`./build.sh`), then **P1** panel/launcher/Control Center stubs — still Sway + Waybar/wofi/mako.
