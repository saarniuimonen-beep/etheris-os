# Verification — Bug criteria ROCK-SOLID PASS (2026-11-19)

**Criteria:** [`docs/BUG-CRITERIA.md`](../docs/BUG-CRITERIA.md)  
**ISO:** `out/etheris-2026.11.19-x86_64.iso`  
**SHA256:** `173b316bf047373a100b23b93fde678fa98002314a6930ac2b899d2350c63cf0`  
**Guest-apply:** **none**

## Host Must B0–B2

| Gate | Result |
|------|--------|
| `scripts/test-bugs.sh` | **38 OK, 0 FAIL** |
| Evidence | `out/bugs-20261119T174200Z/` |

Includes new regression seals **B1.22–B1.29** (blur seed, lock routing, ram idle-check argv, browser_preload default, installer channel rewrite, duplicate Name=, Firefox private lean path).

## Live Must B3 (no inject)

| ID | Result | Evidence |
|----|--------|----------|
| B3.1 greeter / password-first | **PASS** | `out/qemu-bugs-20261119T174218Z/01-greeter.png` |
| B3.2 desktop | **PASS** | `02-desktop.png` |
| B3.3 `etheris-auth-check` | **12 OK, 0 FAIL** · `AUTH_RC=0` | `03-auth.png` |
| B3.4 doctor | **16 OK, 0 FAIL, 2 WARN** (benign VM loop) · `DOCTOR_RC=0` | `04-doctor.png` |
| B3.5 `etheris-perf` | **active** | `05-probe.png` |
| B3.6 overlay soak ×10 (Super+A / Super+D) | **PASS** | `soak-*-menu/launcher.png` |
| B3.7 menu-hover | `pgrep -af` → python3 etheris-menu-hover | `05-probe.png` |
| B3.8 failed units | doctor: no product-relevant fails | `04-doctor.png` |
| B3.9 no guest-apply | inject disks detached; statement here | — |

Live runner: `scripts/test-bugs-live.sh` → **7 OK, 0 FAIL** · `out/qemu-bugs-20261119T174218Z/`

## Product fixes this pass

| Bug | Fix |
|-----|-----|
| Host B0 false-FAIL from accidental `__pycache__` | `test-bugs.sh` / `reliability-check.sh` clean bytecode before profile gate; clearer FAIL logging |
| Settings recreate `blur=on` / preload on | Sealed B1.22/B1.25/B1.26 (product already fixed) |
| Lock bypasses branding | Sealed B1.23 |
| `etheris ram idle-check` argv | Sealed B1.24 |
| Install rolling mirrors + stable label | Sealed B1.27 |
| Duplicate Defaults / Firefox private | Sealed B1.28/B1.29 |

## Verdict

**ROCK-SOLID PASS** — B0–B2 green on tree + ISO; B3 green on ship ISO without guest-apply.
