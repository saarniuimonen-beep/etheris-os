# Etheris OS — Package groups (Alpha 0.4 design)

**Status:** Lists + CLI stub ship; full Software Center UI is thin wrapper  
**Related:** [`GAMING.md`](GAMING.md), `etheris packages`, `etheris software`

---

## Groups

| Group | Default install | Source list |
|-------|-----------------|-------------|
| **core** | Always (base system) | installer PKGS core set |
| **desktop** | Always (Sway desktop) | installer desktop set |
| **gaming** | Opt-in (`ETHERIS_INSTALL_GAMING=1`) | `/usr/local/share/etheris/groups/gaming.list` (= gaming-packages.list) |
| **dev** | Opt-in | `groups/dev.list` |
| **multimedia** | Opt-in | `groups/multimedia.list` |

Live ISO may still include gaming for try-before-install; disk installs stay lean by default.

---

## Trust labeling (Software Center)

| Label | Meaning |
|-------|---------|
| **Etheris** | Curated list in `/usr/local/share/etheris/groups/` |
| **Arch** | Official repos via pacman |
| **AUR** | `etheris-aur` only — user accepts risk |

Never present AUR as “verified secure.”

---

## CLI

```bash
etheris packages list
etheris packages show gaming
sudo etheris packages install gaming
sudo etheris packages remove gaming   # best-effort; may leave deps
etheris software                      # alias → packages / future GUI
```
