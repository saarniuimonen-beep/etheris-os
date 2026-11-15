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
| Polkit | Narrow wheel rules only — see [`POLKIT.md`](POLKIT.md) |
| OOBE state | `/var/lib/etheris/oobe` is `root:wheel` 2770/660 — **not** world-writable |
| Live auth setup | `etheris-auth-setup.service` gated by live cmdline + `/run/archiso`; masked on install |

## Commands

```bash
etheris-security status
sudo etheris-security firewall
etheris-security audit
etheris privacy              # dashboard wrapper
etheris doctor
etheris report create        # redacted local support bundle
sudo nft list ruleset
```

Firewall config: `/etc/nftables.conf`  
Restart: `sudo systemctl restart nftables`

## Related (0.3 planning)

| Doc | Topic |
|-----|-------|
| [`UPDATE-RECOVERY.md`](UPDATE-RECOVERY.md) | Interrupted upgrades |
| [`SECURITY-UPDATES.md`](SECURITY-UPDATES.md) | Channel security policy |
| [`LUKS-PLAN.md`](LUKS-PLAN.md) | Optional encryption (not shipped) |
| [`SECURE-BOOT-PLAN.md`](SECURE-BOOT-PLAN.md) | SB research |
| [`SELINUX-STUDY.md`](SELINUX-STUDY.md) | MAC deferred |

## Privacy

See `/etc/etheris/privacy.conf` and [`PRIVACY-DASHBOARD.md`](PRIVACY-DASHBOARD.md).  
No cloud diagnostic reporting. Local `etheris report create` is user-initiated and redacted.

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
