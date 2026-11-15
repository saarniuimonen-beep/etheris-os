# Etheris OS — Repository and Update Channels

Inspired by Omarchy-style channels, implemented **without** a custom package mirror.
Pacman is pointed at either the **Arch Linux Archive** (coherent dated snapshot) or live Arch mirrors (edge).

## Channels

| Channel | Source | Lag | Audience |
|---------|--------|-----|----------|
| **stable** (default) | `archive.archlinux.org` | **14 days** (configurable → 30) | Daily drivers |
| **rc** | Archive | **7 days** | Testers / upcoming Etheris changes |
| **edge** | Official Arch mirrors | ~0 | Experienced users only |

## Commands

```bash
etheris-update status
etheris-update check
sudo etheris-update channel stable   # or rc | edge
sudo etheris-update upgrade          # one pacman -Syu transaction
sudo etheris-update security         # emergency fresher coherent snapshot
sudo etheris-update recover          # previous known-good mirrors + Suu
```

## AUR

Optional. Not an official binary repo.

```bash
etheris-aur check <pkg>
```

Lag aligns with `AUR_LAG_DAYS` in `/etc/etheris/channels.conf` (default 14).

## Security

Critical fixes are **not** blindly delayed forever.  
`etheris-update security` advances the whole channel to a fresher **single** Archive date (`SECURITY_LAG_DAYS`, default 3) so dependencies stay coherent, then runs `pacman -Syu`.

## Recovery

Every channel switch / refresh / security action saves:

- previous mirrorlist
- previous snapshot date
- previous channel

Restore with `sudo etheris-update recover`.

## What we deliberately do **not** do yet

- Custom Etheris package mirrors / CDN
- Promising multi-year binary support repos
- Automatic “promote to stable” CI

Those wait until **Archiso ISO + installer work reliably** (see `docs/RELEASE-POLICY.md`).

## Promotion testing (before declaring a Stable snapshot “blessed”)

Manual checklist (do not invent results):

1. Build ISO  
2. QEMU install  
3. Full `etheris-update upgrade`  
4. Sway / net / audio  
5. `pacman -Dk` / dependency sanity  
6. Verify signatures (`SigLevel` Required)  
