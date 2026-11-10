# ADR — Neo-Aero desktop implementation

**Status:** Accepted (owner go-ahead 2026-11-08)  
**Compositor:** Sway remains compositor and forever fallback. Quickshell is never a compositor.

## Decision

| Concern | Choice now | Later |
|---------|------------|--------|
| Panel / tray / workspace strip | **Path A — Waybar** (token-themed floating panel) | Path B Quickshell cutover only if gates pass |
| Launcher / app menu | **wofi** via `etheris-launcher` (pins + overlay mutex) | Optional Quickshell launcher after cutover |
| Toasts | **mako** (retain) | Shell history panel may wrap later |
| Control Center | **`etheris-control-center`** stub (wofi quick settings → GTK later) | Quickshell CC candidate |
| Power | Existing GTK4 `etheris-power-menu` | unchanged |
| Window decorations | Separate WP-S3 — investigate SSD/CSD before coding | Animations only after S3 |
| Animations | **Blocked** until decorations architecture tested | WP-S4 |

## Quickshell evaluation (2026-11-08)

- Packaged in Arch **extra** as `quickshell` 0.3.x (Qt6 declarative + wayland).
- Fit: excellent for panel/CC/widgets; **not** a compositor.
- Cost: pulls Qt6 stack (~hundreds of MiB install; non-trivial RSS vs Waybar).
- Gates before cutover (must all pass):
  1. Idle RSS delta documented vs Waybar Path A on same VM ISO.
  2. `etheris-session` still starts Sway if shell dies.
  3. **No dual panel** — cut over; never run Waybar+Quickshell together.
  4. Crash-loop → automatic Waybar fallback + one mako notice.
  5. Same token palette (JSON / generated conf) as `etheris-theme-apply`.

**Now:** ship Path A value (Stage 2 roadmap). Spike Quickshell behind a feature flag at WP-S2/S3 boundary if Path A CC hits Waybar limits.

## Work packages

| ID | Scope | Exit |
|----|--------|------|
| **WP-S0** | This ADR + package map | Done when owner sees plan |
| **WP-S1** | Floating panel polish, workspace strip, tray, launcher wrapper, overlay mutex, CC stub entry, border token wiring | Soft-reload desktop matches Neo-Aero panel preview direction; Super+D / Super+A |
| **WP-S2** | Richer Control Center, notification history policy, tray policy, settings hooks | Super+A usable for quick settings |
| **WP-S3** | Decoration architecture + Etheris controls (SSD where possible, honest CSD elsewhere) | Controls work; doc of limits |
| **WP-S4** | Signature open/close/min/restore/max animations + reduced-motion | Only after S3 tested |
| **WP-S5** | Wallpaper/Atmosphere UX, GTK Settings, workspace overview, optional widgets (off by default) | Personalisation without file edits; Super+, / Super+W |
| **WP-S6** | Performance measurements + polish | Idle RSS/CPU recorded |

### Checkpoint — WP-S5 (2026-11-08)

Path A remains Waybar+wofi+mako. Added:

- `etheris-settings` (GTK4) — themes, wallpapers, tray, widgets, motion
- `etheris-workspace-overview` — IPC workspace/window picker (no GNOME overview clone)
- `etheris-widgets` / `etheris-widget-clock` — optional sticky clock (**off** by default)
- Decorations doc refreshed; panel winctl includes scratch(min)

**Quickshell:** still gated (RSS / crash-fallback). Do not dual-run with Waybar.

## Non-negotiables

- No Fedora host config / physical disk changes.
- Do not replace working components without written justification.
- Do not claim success from mocks or inject-only tests for ship gates.
- Stop for review at each major integration checkpoint.
