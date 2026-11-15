# Etheris OS — Security updates across channels

**Related:** [`CHANNELS.md`](CHANNELS.md), [`UPDATE-RECOVERY.md`](UPDATE-RECOVERY.md), `etheris-update`

---

## Policy (Alpha)

| Channel | Cadence | Security urgency |
|---------|---------|------------------|
| **stable** | Archive lag (~14d) | Prefer coherent snapshot; use `etheris-update security` for ~3d lag emergency |
| **rc** | Shorter lag (~7d) | Testers; still coherent Archive |
| **edge** | Rolling Arch | Fastest fixes **and** fastest breakage |

**Principle:** Never mix arbitrary package dates. Advance the whole Archive snapshot, then `pacman -Syu`.

---

## Operator playbook

```bash
# Routine
sudo etheris-update check
sudo etheris-update upgrade

# Known critical CVE on Arch, stable too old:
sudo etheris-update security    # typed SECURITY confirm

# Bad upgrade:
sudo etheris-update recover
```

---

## What Etheris does **not** do (yet)

- Push notifications for CVEs  
- Automatic unattended upgrades  
- Separate “security-only” package repo  
- Guarantees that lag windows contain zero known exploits  

Document CVEs affecting the shipped stack in release notes when known.

---

## Future (Beta+)

- Optional notify via `etheris-notifications` when `check` finds upgrades  
- Channel validation automation (promote rc → stable)  
- Tie into `etheris doctor` / report bundles for support
