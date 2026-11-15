# Reusable Component Library Specification (Phase 2)

All components consume `etheris.tokens.json`. Preview: `preview/components.html` + screen pages.

## Universal states

Normal · Hover (≤80ms) · Focus-visible (3px accentSoft ring) · Pressed (scale ≤0.98) · Selected · Disabled (opacity 0.45) · Error · Loading

## Buttons

| Variant | Spec |
|---------|------|
| Primary | Accent gradient; ink `#041018` on bright aqua; padding 10×16; radius 8 |
| Ghost | highlight fill + border |
| Danger | danger soft fill + danger text |
| Icon | ≥36px hit; square-ish radius 8 |

## Inputs

`input` surface · border · radius 8 · placeholder fgSubtle · focus accent+ring · error danger border + caption

## Toggle

44×26 pill · off elevated · on accent-tinted · thumb 18px · Space activates

## Slider

Track 6px pill · thumb 16px accent · used for audio/brightness

## Menus / dropdowns

menu surface · radius 14 · soft shadow · item ≥36px · hover accentSoft · open fade+scale 0.97→1

## Dialogs

radius 16 · width 420–520 confirmations · scrim rgba(4,10,18,0.35) · secondary + primary footer

## Notifications (toast)

~360 wide · radius 14 · leading accent bar · title caption + muted body · stack top-right 8px gap

## Panel (edge top bar)

Height 28 · flush top · bottom hairline · `etheris` wordmark · workspace dots · summaries · clock · menu chip

## Launcher

Search field first · pinned row · category chips · result rows with icon+name+description · max width 640

## Window chrome

Focused border = accent · inactive = muted border · titlebar elevated+gloss (GTK/Sway); decorative traffic lights optional in mock only

## Control Center sheet (Etheris Menu)

≤360 wide · top-right · frosted one-shot blur backdrop · translucent glass (rgba + inset gloss) · fade/rise open (~280ms) · brand header · 2×2 tiles · sliders · session row · hover chip / Esc / click-outside / Super+A toggle. Bar stays visible (overlay inset below 28px). `blur=` / `animations=` in settings.conf. Ocean accent — not GNOME purple pills.

## Session / power menu

Centered frosted sheet · stronger blur backdrop · fade/rise · brand header (`etheris` + Session) · vertical rows (Lock · Sleep · Log out | Restart · Shut down) · Shut down danger only · Esc / click-outside / Super+Shift+E toggle · letter shortcuts. Not a 5-tile rainbow grid.

## Settings shell

220px nav · search · content pane · Atmosphere cards · wallpaper strip
