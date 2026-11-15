# Etheris OS

Arch-based Wayland desktop. Default session: **Sway** with Etheris themes.  
Version: see `/usr/local/share/etheris/VERSION` (product) and `/etc/os-release`.

Idle RAM target: about **500 MB** for the Etheris/Sway session (a goal — do not strip security for it).

## Live login

- User / password: `etheris` / `etheris`
- Greeter: **ReGreet** (text fallback available)
- Session: **Etheris (Sway)**

## Shortcuts

| Key | Action |
|-----|--------|
| Super+Return | Terminal |
| Super+D / Super+Space | Launcher |
| Super+A | Control Center |
| Super+, | Settings |
| Super+Shift+E | Power menu |
| Super+L | Lock |
| Super+/ | Shortcut Center |

## Customize

```bash
etheris                 # interactive menu
etheris themes
etheris wallpaper
etheris status
etheris hardware
etheris performance
etheris help
```

Configs: `~/.config/sway`, `~/.config/waybar`, `~/.config/etheris`, …

## Install

```bash
sudo etheris-installer
```

After install, first boot runs the setup wizard when needed (`etheris oobe`).

## Docs in this folder

Security, channels, hardware/gaming, installer persistence, first-boot setup, polkit, and release policy — same topics as the project `docs/` tree (curated subset synced at bake time).

## Not on this ISO

Optional desktops (Hyprland / KDE / XFCE), disk encryption UI in the installer, Secure Boot, and immutable A/B updates are **not** included in 0.1.0-alpha.
