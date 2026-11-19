# Etheris OS — system sounds

## Startup sound

An original short tone ships at:

`/usr/local/share/etheris/sounds/startup.wav`

**Default: disabled** (`startup_enabled=0`) so shared and quiet environments stay quiet.

### Controls

```bash
etheris sound status
etheris sound enable
etheris sound disable
etheris sound preview
etheris sound volume 40    # 0–100
etheris sound reset
```

Preferences: `~/.config/etheris/sound.conf` (per user).

Playback happens once per login from `etheris apply-session` after `etheris-session-ready` brings PipeWire up — never during early boot, and never if disabled. A runtime guard under `$XDG_RUNTIME_DIR` prevents repeats in one session.

Players: `pw-play` or `paplay` (PipeWire). Missing players fail softly.

Hardware keys call `etheris-volume` (toast via mako). Waybar scroll uses `--quiet` to avoid spam. Mixer UI: `pavucontrol` (Waybar middle-click / Menu → Sound).

### Custom file

Set `startup_file=/path/to/file.wav` in `sound.conf` (optional).
