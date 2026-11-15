# Neo-Aero Design System (Specification Draft)

**Status:** Design specification for Etheris OS · **Compositor constraint:** Sway Path A  
**Date:** 2026-11-15  
**Related:** [`design/phase-2/IDENTITY.md`](../design/phase-2/IDENTITY.md), [`FLOW.md`](FLOW.md), tokens in `usr/local/share/etheris/design/`

This document defines **Neo-Aero** as Etheris’s visual *direction* (calm glass, ocean accents, quiet motion). The **canonical design system implementation** remains **Etheris Flow** (`docs/FLOW.md`, `etheris.tokens.json`, `etheris-theme-apply`). Neo-Aero is not a second token brand.

**Map:** Neo-Aero (direction) ⊂ Flow (system) ⊂ Etheris Desktop (product).

It does not authorize switching compositors or copying third-party rices.

---

## 1. Essence

**One sentence:** Cool blue calm, soft panels, readable type, quiet motion.

Neo-Aero is **not**:

- A Windows Aero / Vista clone  
- A Hyprland anime rice  
- Permanent fullscreen blur for its own sake  

It **is**: clear hierarchy, ocean accents, selective transparency, first-party atmospheres.

---

## 2. Design tokens (canonical targets)

Implementation today: `etheris.tokens.json` → `tokens-dark.conf` / `tokens-light.conf` via `etheris-tokens-generate`.

| Token family | Role | Dark default direction |
|--------------|------|------------------------|
| Accent primary | Focus / links / active | Ocean `#38bdf8` |
| Accent secondary | Highlights | Aqua / teal |
| Danger / warning | Destructive only | Rose / amber |
| Surface shell | Panel / menu | Dark ocean + alpha |
| Surface elevated | Modals when reduced-transparency | Solid |
| Text primary / muted | Readable on wallpaper | High contrast whites / cool gray |
| Radius | Controls / sheets | Small–medium (4px grid) |
| Shadow | Single soft float | No stacked glow stacks |
| Motion | Open/close | Short ease; **off** by default in settings |

Exact values: keep JSON as source of truth; this doc owns **intent**.

---

## 3. Typography & icons

| Role | Guidance |
|------|----------|
| UI sans | Noto Sans (Outfit if installed) — already Flow direction |
| Mono | JetBrains Mono Nerd for terminal |
| Icons | Papirus family — consistent symbolic set |
| Brand wordmark | Panel: **Etheris**; marketing/login: **Etheris OS** |

Avoid thin type on glass. Prefer medium weight on translucent panels.

---

## 4. Materials

| Material | Neo-Aero rule |
|----------|----------------|
| Glass | RGBA panels; **no** permanent Sway compositor blur |
| Frost | Optional one-shot Menu backdrop (`blur=on`) |
| Borders | Hairline accent or soft edge — consistent across Waybar/Rofi/GTK |
| Wallpaper | Atmosphere set (ocean-glass, mist, meadow, …) with subtle watermark |

Accessibility: if contrast fails, force elevated solid surfaces (`reduced-transparency`).

---

## 5. Components

| Component | Spec focus |
|-----------|------------|
| Status bar | Thin edge-to-edge; brand; workspaces; clock; status; **Menu** |
| Menu / CC | Frost sheet under bar; tiles + sliders; Esc / Super+A |
| Launcher | Fast search; icon grid; slim default |
| Notifications | mako; clear urgency colors; DND |
| Greeter | ReGreet card; password-first target; ocean wallpaper |
| Lock | Readable clock + password; brand mark |
| Windows | Honest SSD/CSD; focus ring visible |

---

## 6. Motion

- Default: **animations=off** for reliability/VMs  
- When on: 150–250ms fades/rises; no bounce spam  
- Honor reduced-motion OS/settings flags  

---

## 7. Light / dark

Ship both token sets. Dark remains default for live ISO atmosphere. Theme manager must switch GTK + shell templates together (`etheris-theme-apply`).

---

## 8. Non-goals

- Forking to SwayFX/Hyprland for blur as default  
- Desktop icons / docks as default chrome  
- Emoji-heavy panels  
- Copying GlassesArch / Garuda / commercial OS chrome  

---

## 9. Implementation mapping

| Spec item | Code today |
|-----------|------------|
| Tokens | `share/etheris/design/` (**sync with** `design/phase-2/tokens/`) |
| Apply | `etheris-theme-apply` |
| Menu | `etheris-control-center` |
| Previews | `design/phase-2/preview/*.html` (not runtime) |

## 10. Known drift to close (D1)

| Issue | Reality | Target |
|-------|---------|--------|
| Panel geometry in JSON | Shipped JSON still 40px / offset 14 | Match Waybar **28** / flush **0** |
| Blur default | JSON `off`, skel `blur=on` | One policy (prefer off default; opt-in Menu frost) |
| Launcher docs | Some docs say wofi-primary | **Rofi** Kickoff Path A; wofi fallback only |
| Font | Outfit in specs; **Noto Sans** on ISO | Document ISO face or package Outfit |
| Wordmark | Spec `etheris`; bar **Etheris** | Pick one; update IDENTITY |

Gaps and sequencing: [`DESIGN-ROADMAP.md`](DESIGN-ROADMAP.md).
