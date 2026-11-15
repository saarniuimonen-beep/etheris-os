# Etheris OS — Login screen

**Status: done** (greetd + ReGreet graphical login)

Login still uses **greetd + PAM**. The graphical screen is **ReGreet** (GTK4) on a small Sway session, styled with Etheris CSS.

---

## Stack

| Piece | Role | Location |
|-------|------|----------|
| **greetd** | Display manager | `greetd` · `display-manager.service` |
| **ReGreet** | Graphical login | `greetd-regreet` · `/etc/greetd/regreet.{toml,css}` |
| **Sway (greeter)** | Minimal session for ReGreet | `/etc/greetd/sway-config` |
| **tuigreet** | Emergency text login | `etheris-greeter-tui` |
| **PAM** | Username/password | `/etc/pam.d/greetd` |
| **Sessions** | Wayland/XDG `.desktop` files | e.g. `etheris.desktop` → `etheris-session` |

Live tip: `etheris` / `etheris`. Installed systems use the user you create in the installer.

---

## Custom styling

- Wallpaper: `/usr/local/share/etheris/wallpapers/ocean-glass.png`
- Translucent login card, accent borders, Noto Sans/Papirus — `/etc/greetd/regreet.css`
- Greeting: **Etheris OS** · clock/date in `regreet.toml`
- Power: ReGreet reboot/shutdown · Super+Shift+E swaynag on the greeter seat
- `skip_selection=true` uses the **last-used** user/session from ReGreet state (`/var/lib/regreet/state.toml`)
- Live ISO seeds `state.toml` with `last_user = "etheris"` and `user_to_last_sess.etheris = "Etheris (Sway)"` (desktop `Name=`) so cold boot skips to the **password** prompt
- `etheris-regreet-cache.service` chowns `/var/lib/regreet` to `greeter` before greetd (mkarchiso cannot chown to greeter at bake time)
- Installer seeds the same cache for the installed username
- Stock `sway.desktop` is hidden (`NoDisplay`/`Hidden`) via `etheris-hide-stock-sway` (boot oneshot + pacman hook + installer) so the greeter prefers **Etheris (Sway)**

To fall back to text login temporarily:

```toml
# /etc/greetd/config.toml
[default_session]
command = "etheris-greeter-tui"
user = "greeter"
```

---

## Goals met

1. Branded Etheris login (not stock tuigreet)
2. Still a lightweight Wayland display manager (greetd)
3. Brand + clock + date
4. PAM auth only
5. Session selection via `.desktop` files
6. Shutdown / reboot from the login screen
7. No plaintext password logging

---

## Related

- [OOBE.md](OOBE.md) — first-boot after login (not the greeter)
- [SECURITY.md](SECURITY.md)
