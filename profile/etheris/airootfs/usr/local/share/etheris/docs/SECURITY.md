# Etheris OS — Security and Privacy

**Honest scope:** Etheris aims for safe defaults and privacy-respecting configuration.  
It is **not** claimed to be anonymous, hardened against all attacks, or “completely secure.”

## Implemented defaults (profile)

| Area | Default |
|------|---------|
| Telemetry / analytics / crash upload | Off — none shipped |
| Mandatory accounts / cloud | None |
| Pacman signatures | `SigLevel = Required` (official Arch) |
| SSH | Package optional; **sshd disabled/masked** by default |
| Firewall | **nftables** enabled; inbound drop except lo + established + limited ICMP |
| Outbound network | Allowed (normal browsing/DHCP) |
| AUR | Optional (`etheris-aur`); not an official binary repo |
| ISO checksums | SHA-256 in `out/SHA256SUMS` after builds |
| Desktop user | Unprivileged user; root not the desktop session |
| Live ISO sudo | `%wheel NOPASSWD` for convenience (**live only**) |
| Installed sudo | Password required (`%wheel ALL=(ALL:ALL) ALL`) |

## Commands

```bash
etheris-security status
sudo etheris-security firewall
etheris-security audit
sudo nft list ruleset
```

Firewall config: `/etc/nftables.conf`  
Restart: `sudo systemctl restart nftables`

## Privacy

See `/etc/etheris/privacy.conf`.  
No diagnostic reporting is enabled. If diagnostics are added later, they must be **opt-in** with clear disclosure.

## Not in the first experimental release

- Full-disk encryption (LUKS) installer UI — planned as **opt-in**, never forced
- Secure Boot signed boot chain
- Flatpak sandboxing as default app model
- Automatic security-update channel separate from `pacman -Syu`
- Claim of application sandboxing without verified confinement

## Live ISO limitation

The live environment uses a **documented shared login** for testing.  
That is **not** acceptable as an installed-system default. The installer must create a user with a password you choose.

## User responsibilities

- Choose strong passwords after install
- Keep the system updated (`sudo pacman -Syu`)
- Review firewall changes before exposing services (e.g. SSH)
- Treat AUR packages as untrusted until you review them
- Screen lock ≠ disk encryption

## Auditing

Before any public release, run `etheris-security audit`, inspect `ss -tulpn`, review sudoers, and re-check this document against the running system.
