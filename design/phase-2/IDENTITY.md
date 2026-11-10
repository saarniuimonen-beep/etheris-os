# Etheris OS — Final Visual Identity Guide (Phase 2)

**Status:** Implementation-ready design blueprint — **not applied** to the live OS.  
**Supersedes:** Phase 1 identity for review purposes (see [REVIEW.md](REVIEW.md) for what changed).

---

## Essence

Etheris OS is **modern Neo-Aero / Neo-Frutiger Aero**: luminous cool air, water, and soft glass — futuristic, clean, bright, atmospheric, and efficient. It is **not** a Windows Vista/7 clone and **not** a pile of unrelated pretty screens.

**One sentence:** *Clear glass over ocean light, with calm type and quiet motion.*

---

## Brand marks

| Context | Treatment |
|---------|-----------|
| Panel | 16–18px mark + word **etheris** (lowercase) |
| Login / splash / OOBE / guide | Mark + **Etheris OS** |
| About / ISO | Etheris OS + version |

Mark: concentric luminous circles (sky → cyan → teal). No Start orb, no pearl button language.

---

## Colour story

| Family | Role |
|--------|------|
| Ocean blue | Primary accent / focus (`#38bdf8` dark default) |
| Aqua / turquoise | Secondary accent, success-adjacent highlights |
| Fresh green | Meadow Atmosphere + semantic success |
| Whites / cool neutrals | Arctic Glow surfaces; text on dark |
| Dark ocean | Default shell backgrounds |
| Amber / rose | Warning / danger only |

Exact values: [`tokens/etheris.tokens.json`](tokens/etheris.tokens.json).

---

## Materials

| Material | Spec |
|----------|------|
| Glass | RGBA panel/menu surfaces; **no** permanent compositor blur |
| Transparency | Selective (panel ~72%, menu ~94%); reduced-transparency → solid elevated |
| Reflections / gloss | Single top inset highlight on raised chrome |
| Gradients | Wallpaper atmospheres; primary button subtle vertical; icon wells |
| Shadows | One soft layer (soft / float); never stacked multi-shadow |
| Depth | Wallpaper → desktop → panel → windows → modal overlays |

---

## Layout principles

- 4px grid; one job per surface.
- Default desktop = **floating top panel** + wallpaper + windows (no dock, no desktop icons, no widgets).
- Overlays are centered or anchored; never full-screen dimming that blocks Sway focus traps poorly — scrim ≤40% opacity.
- Same component geometry in all Atmospheres.

---

## What we refuse

Vista/7 recreation · purple AI-default kits · cream/terracotta editorial · broadsheet density · blur farms · looping animated wallpapers by default · dual always-on shell panels.
