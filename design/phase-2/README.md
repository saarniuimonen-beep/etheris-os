# Etheris OS — Design Phase 2 (Final Neo-Aero Blueprint)

**Status:** Ready for owner review · **live OS / airootfs / ISO not modified**  
**Supersedes Phase 1** for implementation planning (Phase 1 kept as archive).

## Open previews

```bash
xdg-open ~/etheris-os/design/phase-2/preview/index.html
```

Walk: Desktop → Launcher → Control Center → Settings → Login → Atmospheres → Components → Experience.

## Deliverables checklist

| # | Deliverable | File |
|---|-------------|------|
| 1 | Final visual identity | [IDENTITY.md](IDENTITY.md) |
| 2 | Exact tokens | [TOKENS.md](TOKENS.md) · [tokens/etheris.tokens.json](tokens/etheris.tokens.json) |
| 3 | Typography & icons | [TYPOGRAPHY-ICONS.md](TYPOGRAPHY-ICONS.md) |
| 4 | Component library | [COMPONENTS.md](COMPONENTS.md) · `preview/components.html` |
| 5 | Refined screens | `preview/*.html` |
| 6 | Five Atmospheres | [ATMOSPHERES.md](ATMOSPHERES.md) |
| 7 | Interactions / keyboard | [INTERACTIONS.md](INTERACTIONS.md) |
| 8 | Accessibility | [ACCESSIBILITY.md](ACCESSIBILITY.md) |
| 9 | Performance | [PERFORMANCE.md](PERFORMANCE.md) |
| 10 | Architecture | [ARCHITECTURE.md](ARCHITECTURE.md) |
| 11 | Implementation roadmap | [ROADMAP.md](ROADMAP.md) |
| 12 | Acceptance criteria | [ACCEPTANCE.md](ACCEPTANCE.md) |
| — | Phase 1 critique | [REVIEW.md](REVIEW.md) |

## Key Phase 2 decisions (summary)

- **Panel-first** default desktop (no dock / icons / widgets unless opted in).
- **One overlay at a time** (launcher, CC, notifications, shortcuts, power).
- **Atmospheres** = colour + wallpaper (+ light/dark), not five DEs.
- **Sway** stays compositor; **Quickshell** allowed as shell Path B after RSS gates; Path A = Waybar/wofi first.
- **Blur off** by default; rgba glass first.

## Approval

Do **not** start the complete desktop redesign until the project owner approves this blueprint.

After approval, begin [ROADMAP.md](ROADMAP.md) Stage 1 only — still respecting master ISO/OOBE milestones.
