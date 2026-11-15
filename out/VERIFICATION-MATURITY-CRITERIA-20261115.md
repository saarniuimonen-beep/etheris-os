# Verification — Maturity criteria + fixes (2026-11-15)

## Criteria added

- [`docs/MATURITY-CRITERIA.md`](../docs/MATURITY-CRITERIA.md) — Must / Should / Must-not  
- [`scripts/maturity-check.sh`](../scripts/maturity-check.sh) — automates Must **M0/M1** + tree fix presence  

**maturity-check:** **PASSED** (11 OK) on ISO `79106f8b…`

## Fixes (so Must M3.6 / M3.7 can pass)

| Finding | Fix | Host proof |
|---------|-----|------------|
| `etheris-perf` `HOME: unbound variable` | `${HOME:-}` + unit `Environment=HOME=/root` | `env -u HOME etheris-perf profiles` OK |
| security audit false FAIL on `/etc/shadow` | `as_root` / **SKIP** (auth-check pattern) | no “Permission denied → no hash” false FAIL |
| doctor FAIL on VM `systemd-loop@*sr0*` | benign unit filter → WARN only | unit-test BENIGN_SR0 / PRODUCT_PERF |

## Live L2/L3 (already green from maturity smoke)

Greeter · desktop · Super+A/D · auth-check 12 OK · nftables — see `out/VERIFICATION-MATURITY-20261115.md`.

## Still needs rebake for guest doctor PASS

Current ISO still has the old `etheris-perf` / audit / doctor. Tree fixes are ready; next `./build.sh` ships them so live **M3.6 doctor exit 0** and **M3.7 no product failed units** can be claimed without inject.

Evidence: `out/maturity-criteria-verify-20261115T191247Z/FIX-VERIFY.md`
