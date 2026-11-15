# Etheris OS keyboard shortcuts (Sway)

| Key | Action |
|-----|--------|
| Super+Return | Terminal (foot) |
| Super+D / Super+Space | Etheris launcher (Rofi Kickoff) |
| **Super+A** | Etheris Menu (Control Center sheet) |
| **Super+N** | Notification center |
| **Super+W** | Workspace / window overview |
| **Super+,** | Etheris Settings (GTK) |
| — | Etheris Wallpapers (`etheris-wallpaper` / Settings / launcher) |
| — | Etheris Transfers (`etheris-transfer` — LAN / Bluetooth / shares) |
| **Super+/** | **Shortcut Center** (searchable reference) |
| Super+E | Files (pcmanfm) |
| Super+Shift+A | Focused window menu (close / float / fullscreen / scratch) |
| **Alt+F4** | **Close focused window** (primary) |
| Super+Q | Close focused window (additional) |
| Super+Shift+Q | Close focused window (legacy) |
| **Alt+Tab** | Cycle open windows on this workspace |
| Alt+Shift+Tab | Cycle windows backwards |
| **Super+H** | Send focused window to the **Sway scratchpad** (hidden) |
| **Super+Shift+H** | Show / cycle windows from the scratchpad |
| Super+Shift+E | Logout menu |
| Super+L | Lock |
| Super+F | Fullscreen |
| Super+Shift+Space | Toggle floating |
| Super+R | Resize mode (arrows, then Enter/Esc) |
| Super+1..9 | Workspaces |
| Super+Shift+1..9 | Move window to workspace |
| Print | Screenshot to clipboard |
| Shift+Print | Region screenshot to clipboard |

## Scratchpad (Super+H) — not ordinary minimize

Sway does not use a Windows-style taskbar minimize. **Super+H** moves the focused window to the **scratchpad** (a hidden holding area).

- **Hide:** focus the window → `Super+H`
- **Restore:** `Super+Shift+H` (shows the scratchpad window; repeat to cycle if several are hidden)
- Hidden windows stay running; they are not closed

## Tips

- Sway title strip has **no** SSD close/min/max buttons; use panel window controls, **Alt+F4**, or the app’s own CSD buttons (GTK themed).
- Shortcut Center: `Super+/` or `etheris shortcuts` (launcher: Shortcut Center).
- First-login guide: `etheris guide --force` (auto once on installed systems).
- Greeter (ReGreet): graphical login · text fallback `etheris-greeter-tui` · live user `etheris` / `etheris`.
