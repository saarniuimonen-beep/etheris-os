# Etheris OS

Lightweight Arch-based desktop. Target: **≤500 MB RAM at idle**.

## Shortcuts

| Key | Action |
|-----|--------|
| Alt+Enter | Terminal |
| Alt+D / Alt+Space | Launcher |
| Alt+Esc | Session menu |
| Super+L | Lock |
| Print | Screenshot to clipboard |

## Customize

```bash
etheris themes
etheris wallpaper
etheris status
nwg-look
```

Configs live in `~/.config/labwc`, `~/.config/waybar`, `~/.config/etheris`.

## Install

```bash
sudo archinstall
```

## Desktops

At the **SDDM login screen**, pick a session:

| Session | Notes |
|---------|--------|
| Etheris Light (labwc) | Lowest RAM (≤500MB idle target) |
| Hyprland | Tiling Wayland |
| Plasma | Full KDE desktop (uses more RAM) |
| Xfce | Classic GTK desktop |

Live user: `etheris` / `etheris`

Install with desktop choice: `etheris install`
