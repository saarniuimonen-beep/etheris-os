# Verification — desktop reliability / maturity pass (2026-11-13)

In-tree fixes after live maturity smoke + Agent Flow work. **Needs ISO rebake** for guest proof.

## Problems addressed

| Issue | Fix |
|-------|-----|
| DND setting not restored after login | `etheris-notifications restore-dnd` + sway exec after mako; also from `etheris apply-session` |
| `etheris-winctl` aborted on failed `swaymsg` (`set -e`) | Soft `sway_ok`; menu never kills the session helper |
| Window menu bypassed overlay mutex | Super+Shift+A → `etheris-overlay winctl`; nested guard |
| Overview / notifications / winctl stuck on wofi-only | Prefer **Rofi**, wofi fallback |
| Alt+Tab when focus has no pid | Focus-cycle starts at first toplevel |
| First-login guide never auto-ran | `exec etheris-guide` after delay (no-op on live + if done) |
| Fresh `etheris` settings defaulted launcher to `wide` | Align with skel: `slim` + `dnd=off` |
| `nftables` looked “dead” after oneshot | `RemainAfterExit=yes` drop-in |

## Related (already in tree, still need rebake)

- Flow: animations → GTK; Noto Sans UI font; Settings/CC re-apply
- `etheris-auth-check` privileged probes + share polkit rule path

## Host checks

| Check | Result |
|-------|--------|
| `bash -n` on touched scripts | **PASS** |
| `restore-dnd` without mako (no crash) | **PASS** |
| Skel sway contains restore-dnd + guide + overlay winctl | **PASS** |

## Not yet verified on live ISO

- DND persists across logout/login
- Guide once on installed system only
- nftables `is-active` after boot
- Overlay mutex under rapid Super+D / Super+A / Super+N / Super+Shift+A
