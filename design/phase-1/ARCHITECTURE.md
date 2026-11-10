# Etheris OS — Technical Implementation Recommendation

**Design Phase 1 inspection only — do not replace the desktop yet.**

## Current architecture (as shipped)

Etheris Light is a **Sway + small Wayland toolkit** stack. “Etheris Light” is a **session brand**, not a compositor.

```text
greetd + tuigreet
        ↓
etheris-session
        ↓
Sway  (compositor / WM / inputs / outputs)
 ├── Waybar          panel
 ├── wofi            launcher
 ├── mako            notifications
 ├── foot            terminal
 ├── pcmanfm         files (GTK)
 ├── swaylock/idle   lock
 └── etheris-theme-apply   tokens → CSS/conf (soft reload)
```

Quickshell is **not in the tree**. Power menu is a transient GTK4 app. OOBE/guide/shortcuts are foot/scripts.

---

## What Sway owns

- Window management, workspaces, keybinds, outputs, borders/gaps
- Session lifetime (`etheris-session` → `exec sway`)
- Wallpaper via `output * bg` / swaybg

**Recommendation:** Keep Sway as default and fallback forever unless a future milestone explicitly replaces the compositor (out of scope).

---

## What a shell (e.g. Quickshell) could own later

Panels, Control Center popups, widgets, fancy notification center — **shell chrome only**.

| If Quickshell is proposed | Rule |
|---------------------------|------|
| Role | Shell widgets / CC / optional panel |
| Must not | Replace Sway; become the compositor |
| Must keep | `etheris-session` → Sway path working |
| Must avoid | Running full Waybar **and** Quickshell panel together without cutover |

---

## Reuse vs replace

| Component | Verdict |
|-----------|---------|
| Sway | **Reuse** |
| Waybar | **Reuse** — restyle via tokens (P1) |
| wofi | **Reuse** first — deep theme; replace only if product gaps remain |
| mako | **Reuse** — theme; history UI later |
| foot | **Reuse** — token colours |
| Adwaita + Papirus | **Reuse** until custom icons approved |
| `etheris-theme-apply` | **Extend** — map Phase-1 tokens into templates |
| tuigreet | **Keep** until LOGIN.md milestone approved |
| PCManFM | **Reuse** — GTK styling |
| New Settings app | **New** later — token-driven GTK or light UI; CLI remains |
| Control Center | **New stub** — prefer GTK popup or small shell widget; not a DE rewrite |

---

## Recommended target architecture (post-approval)

1. **P1:** Still Sway + Waybar + wofi + mako + GTK; stronger token apply.
2. **Control Center:** Lightweight overlay (GTK4 or single Quickshell window) invoked from panel — no second compositor.
3. **Atmospheres:** Already thin `.theme` packs — deepen wallpaper/accent mapping only.
4. **Login:** Concept in this package; implementation waits for LOGIN milestone.
5. **Never:** Dual always-on shells for cosmetics; blur-by-default; Quickshell-as-compositor.

---

## Performance gates before adopting Quickshell

- Measure idle RSS (`etheris ram`) with and without prototype.
- Prove Super+D launcher latency unchanged.
- Document cutover plan from Waybar if Quickshell takes the panel.
