# Typography & Icon Specifications (Phase 2)

## Typography

### Families

| Role | Spec | Packaging note |
|------|------|----------------|
| UI | **Outfit** 300–700 | Stage 1: package `ttf-outfit` (AUR/font) or vendor under `/usr/local/share/fonts/etheris/`; fallback **Source Sans 3** if Outfit unavailable — never Inter as brand face |
| Mono | **JetBrains Mono** | Already used in foot; keep |

### Hierarchy

Locked sizes in `etheris.tokens.json` → `type.*`.  
Panel clock: caption + tabular nums.  
Login brand: display.  
Keycaps: mono 11px.

### Rules

- Sentence case in UI; short ALL CAPS only for power actions (LOCK, etc.).
- Body ≥12px at 100% scale; target 14px.
- Contrast: body ≥4.5:1; large title ≥3:1 on its surface.
- One UI family per surface; mono only for code/terminal/keycaps.

---

## Icons

### Style

- Soft outlined geometric; ~1.75–2px stroke at 24px.
- Cool monochrome in chrome; colour tiles only in launcher app icons.
- Corner radius consistent with control radius language.

### Sizes

16 / 20 panel · 24 menus · 32–48 launcher · 48–56 dock (if enabled)

### Until custom set

**Papirus / Papirus-Dark** remains OS default (Atmosphere switches icon theme). Custom Etheris icon set = later milestone after Stage 1–3.

### Don’t

Emoji mixed into chrome rows · blank gear placeholders · neon-recolour entire Papirus set.
