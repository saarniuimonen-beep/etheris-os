# Etheris OS — Security Audit

**Date:** 2026-11-15 · **Scope:** Repository defaults + known verification.  
**Not a penetration test.** Not a claim of “secure OS.”

---

## Current implementation

| Control | Implementation | Files |
|---------|----------------|-------|
| Package signatures | Pacman `SigLevel=Required` (Arch) | `pacman.conf` |
| Firewall | nftables inet filter, input drop default | `etc/nftables.conf` |
| SSH | Not enabled by default; audit checks `sshd` | `etheris-security` |
| Telemetry | Declared off | `etc/etheris/privacy.conf`, Firefox policies |
| Live privilege | NOPASSWD sudo **live only** | `etc/sudoers.d/etheris` |
| Installed privilege | Password sudo for wheel | Installer writes wheel sudoers; strips live file |
| Polkit | Narrow YES list + AUTH_ADMIN_KEEP for pacman/perf | `polkit/49-etheris-wheel.rules` |
| Live password resetter | Conditioned on archiso cmdline; masked on install | `etheris-auth-setup.service` |
| Auth sanity | `etheris-auth-check` (incl. libxcrypt on Py3.13) | Verified 12 OK (2026-11-15) |
| OOBE state perms | `root:wheel` 2770/660 | Installer + P0 |
| Local audit CLI | `etheris-security audit` | Checklist only |

**Verified recently:** nftables active; auth-check; scoped polkit (P0); live creds not for installs (E2E).

---

## Identified problems

| Problem | Severity | Notes |
|---------|----------|-------|
| No LUKS in installer | High (for laptop theft model) | Documented deferred |
| No Secure Boot chain | High (for evil-maid model) | Must not advertise |
| `etheris-security audit` still limited | Low–Medium | Ports/LUKS/sudoers/nftables/sysctl added; SB/SELinux/failed units still light |
| Gaming/multilib always on ISO | Medium | Larger attack surface |
| Warpinator ports open in nftables | Medium (LAN) | Intentional for transfers; document clearly |
| ReGreet password UX | Low–Medium | Extra click; AUTH_ERR if automation mistypes |
| Privileged ISO build container | Medium (supply chain) | Host trust boundary |
| Triple polkit file copies | Low | Drift risk if not synced |

---

## Proposed solutions (not implemented in this phase)

### Optional LUKS (Critical → Alpha 0.3)

- **Current:** none  
- **Proposed:** installer opt-in, cryptsetup, documented recovery key flow, tested boot  
- **Benefits:** data-at-rest protection  
- **Risks:** brick risk if recovery weak; complexity  
- **Deps:** installer, initramfs, docs  
- **Test:** VM encrypt install + unlock + failed-passphrase

### Secure Boot (Alpha 0.3+)

- **Current:** unsigned Arch/systemd-boot path  
- **Proposed:** research enrolled keys + signed artifacts; recovery USB  
- **Do not ship** as “supported” until hardware-tested

### SELinux evaluation (study first)

- **Current:** none  
- **Proposed:** research note on Arch+Sway+GTK4 friction; optional later  
- **Risk:** breaks desktop if restrictive policy naive

### Expand `etheris security audit`

- **Done (2026-11-15):** listening sockets summary + fail on `:22`, LUKS/`crypt` detection note, sudoers inventory + installed NOPASSWD trap, nftables `policy drop`, sysctl drop-in  
- Still optional: failed units, Secure Boot EFI vars, nftables counters  
- Keep **actionable findings**, no fake scores  
- Align with proposed `etheris doctor`

### firewalld vs nftables

- **Current:** nftables works and is verified active  
- **Proposal:** keep nftables unless firewalld clearly improves user controls; avoid dual stacks

---

## Security implications of upcoming desktop work

Visual polish must not:

- Disable firewall for “convenience”
- Reintroduce world-writable OOBE state
- Copy live NOPASSWD to installs
- Log passwords in greeter/OOBE

---

## Testing requirements

| Gate | Status |
|------|--------|
| `scripts/test-p0-security.sh` | **44 OK** (source; expanded 2026-11-15) |
| `scripts/test-security.sh` (rock-solid S0–S2) | **PASS — 22 OK** on ISO `49ee87b5…` |
| Live auth-check | **12 OK** (2026-11-15) |
| Live `etheris-security audit` | **PASS path** on `49ee87b5…` (`as_root` + sshd masked + forward drop in squashfs) |
| Persist E2E (no live sudoers) | **PASS** (2026-11-13) |
| LUKS / SB / SELinux | **Not started** / unsupported |

Formal Must IDs: [`SECURITY-CRITERIA.md`](SECURITY-CRITERIA.md).
