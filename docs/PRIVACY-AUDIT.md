# Etheris OS — Privacy Audit

**Date:** 2026-11-15  

---

## Current implementation

| Area | State | Location |
|------|--------|----------|
| Policy file | `TELEMETRY=off`, analytics/crash/log upload off, diagnostics opt-in-only | `/etc/etheris/privacy.conf` |
| Firefox | Studies/telemetry/Pocket/sponsored surfaces disabled via policies | `etc/firefox/policies/policies.json` |
| Accounts / cloud | No mandatory accounts | privacy.conf |
| SSH inbound | Closed by default (nftables + sshd not enabled) | firewall + security audit |
| Live shared login | Documented testing credential only | SECURITY.md / greeter |
| Diagnostic uploads | None implemented | — |
| Privacy dashboard UI | **Missing** | Planned |

**Verified:** config files present; Firefox policies in profile; no Etheris telemetry service found in systemd wants.

**Unverified:** runtime network capture proving zero unexpected phoning-home beyond normal package/mirror/NTP traffic.

---

## Identified problems

1. **No user-facing privacy center** — policy is files + Firefox policies; ordinary users cannot see “what talks to the network.”
2. **AUR / Flatpak trust** — AUR helper exists with lag gate; Flatpak not default; trust models not surfaced in a Software Center (none yet).
3. **Warpinator / Avahi** — LAN discovery ports intentionally open; privacy-sensitive on hostile LAN.
4. **Update mirrors** — Archive/geo mirrors are expected network use; must stay transparent in docs.
5. **`etheris report` missing** — when added, must redact secrets (passwords, tokens, home file contents).

---

## Proposed solutions

### Privacy dashboard (Medium → Alpha 0.4)

- **Problem:** Invisible policy  
- **Solution:** Control Center / Settings section reading `privacy.conf` + firewall summary + “listening services” + Firefox policy summary  
- **Benefits:** transparency, trust  
- **Risks:** over-promising anonymity  
- **Security:** read-only where possible; no new exfil paths  
- **Test:** UI matches files; toggling diagnostics stays opt-in

### Transparent network communication (High docs / Medium tooling)

- Document expected outbound: NTP, mirrors, user browsers  
- Optional `etheris network diagnose` (no packet capture of user content by default)

### Diagnostic reporting (only if needed)

- Opt-in, explicit share action, redaction list, local tarball first  
- Align with `etheris report create`

---

## Principles (binding)

- No silent diagnostic uploads  
- Live credentials never become installed defaults (already enforced — keep tested)  
- Do not claim anonymity or anti-tracking beyond shipped config  
