# WP-S2 / S3 / S4 — implementation status (in tree → second bake)

**Date:** 2026-11-08  
**WP-S1:** verified on ISO `aa1c8b30…` (see `VERIFICATION-WP-S1-SHELL.md`)  
**WP-S2–S4:** implemented in tree; formal VM claim after second `./build.sh`

## WP-S2 — Control Center, notifications, tray

| Feature | Implementation |
|---------|----------------|
| Richer CC | `ethereal-control-center` — volume/brightness steps, DND, tray policy cycle, notifications entry |
| Notification center | `ethereal-notifications` — history / restore / DND / dismiss / test · Super+N |
| Tray policy | `ethereal-shell-layout tray panel\|off\|cc` · settings `tray=` · applied from theme-apply |
| Mako theming | DND mode, max-visible, token template |
| libnotify | added to `packages.x86_64` |

## WP-S3 — Window decorations (honest Sway limits)

| Feature | Implementation |
|---------|----------------|
| Architecture doc | `docs/WINDOW-DECORATIONS.md` |
| Sway title strip | `default_border normal` + titlebar padding (title only — **no SSD buttons**) |
| Panel window controls | `ethereal-winctl` + Waybar `custom/winctl` (close / float / fullscreen) · Super+Shift+A menu |
| GTK CSD | `design/templates/gtk.css.tmpl` → gtk-3/4 `gtk.css` via theme-apply (hover/pressed/disabled/close) |

## WP-S4 — Motion (after S3 foundation)

| Feature | Implementation |
|---------|----------------|
| Open fade | `ethereal-motion` — short opacity ramp on `window::new` via sway IPC |
| Reduced motion | Honours `animations=off` / `reduced` in settings.conf; exits immediately when off |
| Not claimed | Genie/minimize morphs, close animations (window already destroyed), compositor blur trails |

**Explicit:** Stock Sway cannot do macOS/Windows-class effects; we ship lightweight IPC opacity only and keep Sway as compositor.

## Files (additive since WP-S1)

- `usr/local/bin/ethereal-notifications`
- `usr/local/bin/ethereal-shell-layout`
- `usr/local/bin/ethereal-winctl`
- `usr/local/bin/ethereal-motion`
- `usr/local/share/ethereal/design/templates/{mako.config,gtk.css}.tmpl`
- sway / waybar / settings / KEYBOARD / `docs/WINDOW-DECORATIONS.md`
- `packages.x86_64` (+libnotify)

## Verification pending

Second ISO bake + disposable VM: Super+N, winctl, normal titlebars, motion with animations on/off, tray policy, idle RSS.
