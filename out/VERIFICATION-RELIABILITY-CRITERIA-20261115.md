# Verification — reliability criteria + live fixes (2026-11-15)

**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `79106f8b47177585a113075d79153141e13ccbfd97363911768318e1ecb8b105`  
**Domain:** `etheris-os` @ `qemu:///session` (KVM)  
**Criteria:** [`docs/RELIABILITY-CRITERIA.md`](../docs/RELIABILITY-CRITERIA.md)  
**Host gate:** `scripts/reliability-check.sh`  
**Evidence:** `out/qemu-reliability-criteria-20261115/`

---

## Host / tree (Must R0–R1)

| ID | Result |
|----|--------|
| R0.1 check-profile | **PASS** |
| R0.2 P0 security | **PASS** (30 OK) |
| R1.1 validate-iso | **PASS** (23 OK) |
| Tree HOME / unit / security / doctor filters | **PASS** (`reliability-check.sh` 11 OK) |

## Live (prior retest + this stretch)

| ID | Result | Evidence |
|----|--------|----------|
| R2.1–R2.2 greeter password-first | **PASS** | `greeter.png` |
| R3.1–R3.3 desktop + Super+A/D | **PASS** | prior reliability retest |
| R3.4 auth-check | **PASS** 12 OK | `criteria-doctor-top.png` |
| R3.5 nftables | **PASS** | doctor Firewall OK |
| R3.6 `etheris doctor` exit 0 | **PASS** | `criteria-doctor.png` — **9 OK, 0 FAIL, 2 WARN** · `doctor: PASSED` |
| R3.7 no product-relevant failed units | **PASS** | doctor ignores `systemd-loop@…block-sr0` as WARN |
| R3.8 hide-sway + regreet-cache | **PASS** | prior retest |
| RS3 `etheris-perf.service` | **PASS** (guest-apply) | `active` · applied `balanced` |

## Fixes applied (tree + live guest-apply)

| Issue | Fix |
|-------|-----|
| `etheris-perf` `HOME: unbound variable` | `: "${HOME:=/root}"` + unit `Environment=HOME=/root` |
| security audit false FAIL without sudo | already `as_root` / SKIP in tree; live-applied |
| doctor FAIL on VM `systemd-loop@*` (name often has no bare `sr0` token mid-string; full unit includes `block-sr0`) | `is_benign_failed_unit` matches `systemd-loop@*` |

Live guest-apply via `http://10.0.2.2:8767/apply.sh` (tree binaries). **Next ISO rebake ships these without inject.**

## Verdict

**Reliability criteria PASS** on bake `79106f8b…` with guest-applied tree fixes for R3.6/R3.7/RS3.  
Host `reliability-check.sh` green; live `etheris doctor: PASSED`.
