# Etheris OS — Maturity pass criteria

**Date:** 2026-11-15  
**Rule:** Claim **maturity PASS** only when every **Must** row below is green with evidence.  
**Script:** `scripts/maturity-check.sh` covers Must L0/L1 (+ optional guest hooks). L2/L3 need live screenshots.

---

## Verdict levels

| Verdict | Meaning |
|---------|---------|
| **PASS** | All Must criteria green |
| **CONDITIONAL PASS** | Must L0–L3 desktop green; doctor/units still failing for known tree-fixed bugs |
| **FAIL** | Any Must L0–L3 desktop gate red |

---

## Must (Alpha maturity)

| ID | Criterion | How to prove |
|----|-----------|--------------|
| M0.1 | `check-profile.sh` PASSED | script log |
| M0.2 | `test-p0-security.sh` 0 FAIL | script log |
| M1.1 | `validate-iso.sh` 0 FAIL on ship ISO | script log |
| M2.1 | UEFI live boot → ReGreet | screenshot |
| M2.2 | Password-first + auto `Etheris (Sway)` | greeter screenshot |
| M3.1 | Login → Sway + Waybar | desktop screenshot |
| M3.2 | Super+A opens Etheris Menu | screenshot |
| M3.3 | Super+D opens launcher | screenshot |
| M3.4 | `etheris-auth-check` 0 FAIL | CLI / screenshot |
| M3.5 | `nftables` is-active | CLI |
| M3.6 | `etheris doctor` exit 0 | CLI (from live session preferred) |
| M3.7 | No **product-relevant** failed systemd units | `systemctl --failed` (VM CDROM `systemd-loop@*` may WARN only) |

## Should (recorded, not blocking Alpha)

| ID | Criterion |
|----|-----------|
| S1 | MOTD Sway-only · BUILD_ID matches channels |
| S2 | hide-stock-sway + regreet-cache active |
| S3 | `etheris-menu-hover` running after Menu use |
| S4 | rgb tools mode 755 |
| S5 | Install / LUKS E2E when installer changed |

## Must not claim without separate gates

- Physical GPU / gaming on silicon  
- Secure Boot **supported**  
- SELinux enforcing  
- Bit-identical reproducible ISO  

---

## Fixes tied to these criteria

| Failure | Fix |
|---------|-----|
| `etheris-perf` `HOME: unbound variable` | `: "${HOME:=/root}"` + `Environment=HOME=/root` on unit |
| security audit “no password hash” without sudo | `as_root` / SKIP like auth-check |
| doctor FAIL on VM `systemd-loop@*` | treat as benign WARN |
