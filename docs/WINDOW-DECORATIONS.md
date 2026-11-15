# Window decorations — architecture (WP-S3)

**Compositor:** Sway (wlroots). This is binding for what we can honestly ship.  
**Status:** Foundation implemented (title strip + panel controls + GTK CSD). Animations (WP-S4) build on this; they must not assume SSD button widgets exist in Sway.

## Wayland reality (investigate first)

| Layer | Who draws chrome | Etheris role |
|-------|------------------|---------------|
| **SSD** (server-side) | Compositor | Sway can draw a **title strip** (`default_border normal`) and coloured borders. Sway **does not** draw close / min / max buttons. |
| **CSD** (client-side) | Application toolkit (GTK, Qt, Chromium, …) | We theme GTK 3/4 headerbar titlebuttons via tokenized `gtk.css`. Qt/others keep toolkit defaults unless they opt into our theme. |
| **xdg-decoration** | Negotiation | Clients often prefer CSD; Sway cannot force identical chrome on every app. |

## What Sway can and cannot do

| Capability | Sway support | Etheris approach |
|------------|--------------|-------------------|
| Coloured pixel / normal borders | Yes | Token-driven via `20-etheris-colors` |
| Titlebar with window title | Yes (`default_border normal`) | Etheris title strip (title text only) |
| SSD close / min / max buttons | **No** | Not faked as compositor SSD |
| Focused window controls | Via IPC | Panel `custom/winctl` + `etheris-winctl` + Super+Shift+A |
| GTK CSD headerbar buttons | Client-side | `gtk.css` hover / pressed / disabled / close / min / max |
| Foot / many terminals | No CSD | Borders + keybinds (Alt+F4, Super+Q) |
| Windows-style minimize | No | Scratchpad = hide (`etheris-winctl scratch`) |
| Maximize | Fullscreen / floating | `etheris-winctl fullscreen` · Super+F |

## Policy

1. **Do not claim** every app has identical Etheris chrome.
2. Prefer **real** controls: GTK CSD where the toolkit draws them; Sway titlebars for title identity; panel window controls for the focused container.
3. Animations (WP-S4) use sway IPC opacity / layout only — never invent non-existent SSD widgets.
4. Path B Quickshell may later host a richer chrome HUD; it still cannot become the compositor.

## Implementation map

| Surface | Mechanism |
|---------|-----------|
| Sway title strip | `default_border normal`, `titlebar_padding`, token colours |
| Panel controls | Waybar `custom/winctl` → close · scratch(min) · float · fullscreen |
| Menu | Super+Shift+A → `etheris-winctl menu` |
| GTK 3/4 CSD | `design/templates/gtk.css.tmpl` via `etheris-theme-apply` |
| Docs | `docs/KEYBOARD.md` for non-CSD apps |

## Test checklist (live / installed)

- [ ] Foot: title strip visible; close via Alt+F4 / panel ✕
- [ ] GTK app (e.g. pcmanfm / pavucontrol): CSD buttons respond to hover/press
- [ ] Panel − sends focused window to scratchpad; Super+Shift+H restores
- [ ] Fullscreen toggle from panel ⛶ and Super+F
- [ ] No claim that Firefox/Chromium match GTK titlebutton styling exactly
