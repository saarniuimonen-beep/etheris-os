# Neo-Aero — Design Research Notes

**Date:** 2026-11-15  
**Purpose:** Inspiration and anti-patterns for Etheris Neo-Aero.  
**Rule:** Learn patterns; **do not copy** configs, artwork, logos, or distinctive complete setups.

---

## 1. Communities & what users repeatedly ask for

Sources consulted at research time (public web / known community themes):

| Community / theme | Useful signals | Avoid |
|-------------------|----------------|-------|
| r/unixporn, r/swaywm, r/Hyprland | Compact bars, grouped modules, cohesive colors from wallpaper | One-off unmaintainable rice; opaque setup scripts |
| r/linux, r/gnome, r/kde | Complaints: inconsistency, settings sprawl, opaque updates | Cloning GNOME/KDE chrome |
| Garuda Sway Waybar discussions | Collapsible module **groups** to fight bar clutter | Distro-specific branding |
| Glassmorphism a11y writeups | Semi-opaque overlays, borders, strong type, limit transparency | Low-contrast frosted text |
| SwayFX / “liquid glass” forks | Desire for blur/rounded corners | Switching compositor without ADR + perf gates |
| Dynamic theming (e.g. wallust-style pipelines) | Wallpaper-driven accents | Fragile dependencies as default |

Representative public references (inspiration only):

- Glassmorphism accessibility: [newtarget.com — Glassmorphism with accessibility](https://www.newtarget.com/web-insights/blog/glassmorphism/) (contrast, overlays, performance)  
- Waybar styling practices: project docs / community CSS guides  
- SwayFX feature list (blur/shadows) — evaluate as **optional upstream fork**, not default  

---

## 2. Patterns Etheris should adopt (abstracted)

1. **Grouped status modules** — keep bar calm; details on click/hover (Menu already centralizes toggles).  
2. **Readable glass** — opacity floors + borders; solid fallback.  
3. **One accent family** — ocean/cyan; semantic colors only for warn/danger.  
4. **Keyboard-first** — every chrome action has a shortcut (already Super+A/D).  
5. **Quiet motion** — optional; never block input.  
6. **Unified theme apply** — one command updates bar/launcher/GTK/terminal.

---

## 3. Anti-patterns (reject)

- Permanent heavy blur on all windows (perf + a11y)  
- Dual panels / docks + bar by default  
- Mixing three icon themes  
- Advertising Hyprland aesthetics while shipping Sway without saying so  
- Copying another distro’s panel CSS wholesale  

---

## 4. Platform constraints (research → reality)

| Desire from rice culture | Etheris reality |
|--------------------------|-----------------|
| True compositor blur | Stock **Sway cannot**; one-shot grim blur or fork |
| Animated borders | Costly; low priority vs reliability |
| Video wallpapers | Optional later; not default ISO weight |
| Qt shell (Quickshell) | ADR: only after RSS gates |

---

## 5. Competitor / peer UX (lessons, not clones)

| Peer | Lesson |
|------|--------|
| Stock Arch + sway | Too raw for product identity |
| Fedora Sway spin | Clear session packaging |
| Commercial OS settings | Unified Control Center mental model |
| macOS Control Center | Dense toggles — adapt carefully, don’t clone |

---

## 6. Research → Etheris actions

| Finding | Action |
|---------|--------|
| Bar clutter | Prefer Menu sheet over endless Waybar modules |
| Glass contrast failures | Enforce elevated solid + contrast checks in design QA |
| Users want “one theme button” | Finish dynamic theme manager on token pipeline |
| Reliability > rice | Keep Alpha 0.2 system work ahead of effects |

Further visual QA should screenshot light/dark + ocean-glass/meadow wallpapers for contrast.
