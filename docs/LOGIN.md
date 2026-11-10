# Etheris OS — Login screen

**Status: IMPLEMENTED (greetd + ReGreet Neo-Aero)**

Auth stays on **greetd + PAM**. The visual greeter is **ReGreet** (GTK4) under a minimal Sway seat, styled with Etheris Neo-Aero CSS.

---

## Stack

| Piece | Role | Location |
|-------|------|----------|
| **greetd** | Display manager | `greetd` · `display-manager.service` |
| **ReGreet** | Graphical Neo-Aero login | `greetd-regreet` · `/etc/greetd/regreet.{toml,css}` |
| **Sway (greeter)** | Minimal seat for ReGreet | `/etc/greetd/sway-config` |
| **tuigreet** | Emergency TUI fallback | `etheris-greeter-tui` |
| **PAM** | Username/password | `/etc/pam.d/greetd` |
| **Sessions** | Wayland/XDG `.desktop` | e.g. `etheris.desktop` → `etheris-session` |

Live tip: `etheris` / `etheris`. Installed systems use the installer user.

---

## Custom styling

- Wallpaper: `/usr/local/share/etheris/wallpapers/ocean-glass.png`
- Glass login card, accent borders, Outfit/Papirus — `/etc/greetd/regreet.css`
- Greeting: **Etheris OS** · clock/date in `regreet.toml`
- Power: ReGreet reboot/shutdown · Super+Shift+E swaynag on the greeter seat

To fall back to TUI temporarily:

```toml
# /etc/greetd/config.toml
[default_session]
command = "etheris-greeter-tui"
user = "greeter"
```

---

## Goals met

1. Original Etheris login look (not stock tuigreet)
2. Still lightweight Wayland DM (greetd)
3. Brand + clock + date
4. PAM auth only
5. Session selection via `.desktop` files
6. Shutdown / reboot from greeter
7. No plaintext password logging

---

## Related

- [OOBE.md](OOBE.md) — first-boot after login (not the greeter)
- [SECURITY.md](SECURITY.md)
