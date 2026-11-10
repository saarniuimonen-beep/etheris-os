# Recommended Technical Architecture (Phase 2)

**Inspected reality:** Etheris Light = `etheris-session` → **Sway**. Not a compositor. Quickshell is not in tree today.

## Current stack

```text
greetd + tuigreet
    → etheris-session
        → Sway
            ├── Waybar (panel)
            ├── wofi (launcher)
            ├── mako (toasts)
            ├── foot / pcmanfm / GTK apps
            ├── swaylock / swayidle
            ├── etheris-power-menu (GTK4 transient)
            └── etheris-theme-apply (tokens → conf/CSS)
```

## Ownership split

| Concern | Owner |
|---------|-------|
| Compositor, windows, workspaces, outputs, global binds | **Sway** (keep; fallback forever) |
| Panel, CC, notification history, widgets, fancy launcher | **Shell** — Path A Waybar+popups **or** Path B Quickshell |
| Toasts | mako (retain) unless shell provides equivalent |
| Terminal | foot |
| Files | PCManFM + GTK |
| Lock | swaylock (token colour); branded lock later |
| Themes / Atmospheres | `*.theme` + design tokens + `~/.config/etheris/settings.conf` |
| Settings app | New token-driven GTK (or light UI) + keep `etheris` CLI |
| Login | tuigreet until LOGIN milestone |

## Quickshell evaluation (explicitly permitted)

Quickshell may become the **desktop shell foundation** for panel / CC / widgets / launcher **if** gates pass:

1. Idle RSS impact documented vs Waybar path.
2. `etheris-session` still starts Sway if shell dies.
3. **No dual panel**: cut over from Waybar; do not run both.
4. Crash recovery: systemd user unit restarts shell; if crash-loop → fall back to Waybar minimal profile automatically.
5. Never treat Quickshell as compositor.

**Phase 2 recommendation:**

- **Stages 1–2:** Path A (extend Waybar + wofi + GTK CC stub) — ships value without new runtime.
- **Stage 2 exit / Stage 3 entry:** Spike Quickshell panel+CC behind a feature flag; compare RSS/latency; owner chooses cutover.
- **Stages 4–5:** Widgets prefer shell that won Stage 3 decision.

## Shared tokens implementation

1. Design JSON (`etheris.tokens.json`) → generate `tokens-dark.conf` / `tokens-light.conf` + Atmosphere overlays.
2. `etheris-theme-apply` remains single writer for waybar/wofi/mako/foot/sway/GTK.
3. Quickshell (if used) reads same JSON or generated QML/CSS tokens — **one palette**.

## Preferences persistence

```text
~/.config/etheris/settings.conf
  atmosphere=ocean-glass
  blur=off
  animations=on
  transparency=default|reduced
  panel_layout=floating          # future: dock optional
  widgets=                       # csv ids
```

## Service wiring (conceptual)

| UI | Backend |
|----|---------|
| Network tile | NetworkManager (nmcli/DBus) |
| Bluetooth | BlueZ |
| Audio | PipeWire / wpctl / pamixer |
| Brightness | brightnessctl / logind |
| Battery | UPower |
| DND | mako mode / shell state |
| Power | logind / swaymsg |

## Crash recovery

1. Sway remains; windows intact if only shell dies.
2. User unit `etheris-shell.service` Restart=on-failure with rate limit.
3. After N failures → `etheris-shell-fallback` starts Waybar-only profile + mako.
4. Notify user via mako once: “Shell restarted in safe mode”.
