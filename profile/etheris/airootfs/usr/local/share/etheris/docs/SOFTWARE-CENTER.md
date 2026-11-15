# Etheris OS — Software Center (Alpha 0.4)

**Status:** CLI-first stub (`etheris software` → package groups). GTK store UI **not** claimed.

---

## Scope for 0.4

1. Browse curated **package groups** (gaming, dev, multimedia).  
2. Install/remove via pacman with clear trust labels.  
3. Link to docs (`GAMING.md`, AUR warnings).  
4. Do **not** scrape random AUR packages into a “store.”

---

## Non-goals (yet)

- Flatpak/Snap boutique  
- Ratings / screenshots CDN  
- Paid apps  
- Replacing `pacman` / `etheris-aur` for power users  

---

## Implementation

| Piece | Path |
|-------|------|
| Group lists | `/usr/local/share/etheris/groups/*.list` |
| CLI | `etheris-packages` · hub `etheris packages` / `etheris software` |
| Future GUI | Wrap same lists in GTK (Settings → Apps) |

---

## Exit criteria

- [x] Groups documented + lists on ISO  
- [x] CLI install gaming/dev/multimedia  
- [ ] Optional GTK browser  
- [ ] Settings deep-link  
