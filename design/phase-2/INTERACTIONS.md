# Interaction & Keyboard Behaviour (Phase 2)

## Overlay policy (critical)

Only **one** of these may be open:

| Overlay | Open | Close |
|---------|------|-------|
| Launcher | Super+D / Super+Space / panel Apps | Esc · click outside · launch app |
| Control Center | Click panel CC / Super+A (proposed) | Esc · click outside · open another overlay |
| Notification Center | Click bell / Super+N (proposed) | Esc · click outside |
| Shortcut Center | Super+/ | Esc |
| Power Menu | Super+Shift+E | Esc · action |

Opening any overlay **closes** the others before show. No stacking of Launcher + CC.

Settings, file manager, terminal = normal Sway windows (not overlays).

---

## Component map

| Piece | Behaviour |
|-------|-----------|
| **Panel** | Always visible on focused output; click workspace dots → Sway workspace; click summaries → CC; clock may open calendar popover later |
| **Launcher** | Search focused on open; ↑↓ select; Enter launch; typed query filters |
| **Window management** | Sway: Super+arrows focus; Super+Shift+arrows move; Super+F fullscreen; Alt+F4/Super+Q close; Alt+Tab cycle |
| **Workspaces** | Super+1..N; panel dots; overview = Sway native (no GNOME overview clone) |
| **Widgets** | Opt-in; click focuses widget; no auto-refresh storms (interval ≥30s unless weather needs) |
| **Control Center** | Tiles toggle services; sliders write PipeWire/brightness; power row → lock/logout/sleep/power menu |
| **Notification Center** | History list; clear all; DND syncs with CC |
| **System tray** | Prefer StatusNotifier in panel **or** CC “Tray” section — not both duplicated |
| **Settings** | App window; search filters nav; Atmosphere apply immediate soft-reload |
| **Context menus** | Desktop/titlebar: wofi/GTK menu; same tokens; Esc closes |
| **Shortcut Center** | Read-only cheatsheet; links don’t steal compositor binds |
| **Wallpaper / Atmosphere** | Settings → Personalisation; also optional CC shortcut |

---

## Keyboard (design target)

| Binding | Action |
|---------|--------|
| Super+Return | Terminal |
| Super+D / Super+Space | Launcher |
| Super+E | Files |
| Super+A | Control Center (new) |
| Super+N | Notification Center (new) |
| Super+/ | Shortcut Center |
| Super+Shift+E | Power Menu |
| Super+L | Lock |
| Esc | Close top overlay |

Existing Sway binds in skel remain until implementation migrates carefully.

---

## Focus & a11y interaction

- Overlay open → focus moves into overlay; close → restore previous focus.
- Tab cycles within overlay; focus ring always visible.
- Reduced motion: overlays appear/disappear without scale.
