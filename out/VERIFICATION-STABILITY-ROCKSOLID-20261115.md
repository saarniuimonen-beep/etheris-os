# Etheris OS — Rock-solid stability / reliability verification

**Date:** 2026-11-15T19:58Z (UTC+2 local battery ~21:48–21:58)  
**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `49ee87b5e8db6c309e4f051873d82ae7c6036b51e9f13e2f5de7ff9c3625fc25`  
**Domain:** `etheris-os` (qemu:///session, KVM, ~3.5 GiB RAM)  
**Evidence dir:** `out/qemu-rocksolid-20261115T195200Z/`  
**Inject disks / live patches:** **none** (RR8 / B14 — no guest-apply)

**Verdict: ROCK-SOLID PASS**

Criteria: `docs/STABILITY-CRITERIA.md` (A+B+R) · `docs/RELIABILITY-CRITERIA.md` (Must + Rock-solid)

---

## Host (A / L0–L1)

| Gate | Result |
|------|--------|
| `scripts/reliability-check.sh` | **21 OK, 0 FAIL** |
| `check-profile.sh` | PASSED |
| `test-p0-security.sh` | 44 OK, 0 FAIL |
| `test-stability.sh` A-gates | PASSED |
| `validate-iso.sh` | PASSED (R1.2 squashfs markers present) |

---

## Live baseline (B) + rock-solid (R / RR)

| ID | Criterion | Evidence | Result |
|----|-----------|----------|--------|
| R1 / B1 | Greeter ≤90 s | `01-greeter.png` after cold start | **PASS** |
| B2 | Password-first | `02-pw-typed.png` | **PASS** |
| B3 | Login → Sway + Waybar | `04-desktop.png` Etheris + Menu | **PASS** |
| B4 / RR | Super+A Menu | soak `*-menu.png`, `28-menu-boot2.png` Etheris MENU | **PASS** |
| B5 | Super+D launcher | soak `*-launcher.png`, `29-launcher-boot2.png` | **PASS** |
| R2 / RR3 | Overlay soak ×15 | `soak-01`…`soak-15` menu+launcher | **PASS** |
| R3 / B7 / RR4 | `etheris-auth-check` ×3 (12 OK / 0 FAIL) | `06-auth1` · `12-auth3` AUTH3_RC=0 · `16-auth-final` · boot2 `22-auth-boot2` | **PASS** |
| R4 / B12 | Doctor 0 FAIL | `07-doctor` · `23-doctor-boot2` PASSED / RC=0 | **PASS** |
| R5 / B13 / RR2 | `etheris-perf` active | `17-final-probe` · `24-probe-boot2` | **PASS** |
| R6 | swap used=0; MemUsed ≤1.8 GiB | post-soak `17-final-probe`: MemUsed **1384** MiB, swap **0**; boot2 `24-probe-boot2`: MemUsed **1232** MiB, swap **0** | **PASS** |
| R7 / B9 / RR1 | sway + waybar + menu-hover | `24-probe-boot2` `pgrep -af etheris-menu-hover` → python3 …/etheris-menu-hover | **PASS** |
| R8 | Terminal open/close ×5 | `10-termstress.png` | **PASS** |
| R9 / B8 | nftables + hide-sway + regreet-cache | all **active** in probes | **PASS** |
| R10 / B10 / RR5 | Final desktop intact | `14-final-desktop` · `30-desktop-intact` | **PASS** |
| R11 | Second cold boot → login → desktop | `boot2-*` · `22-auth-boot2` 12 OK · Menu/launcher on boot2 | **PASS** |
| B11 / RR6 | Preload hygiene (tree + ISO) | `firefox_visible_on_ws` in tree + squashfs (validate-iso) | **PASS** |
| B14 / RR8 | No guest-apply | this report | **PASS** |

### Should (recorded)

| ID | Note |
|----|------|
| RS1 | Watermark **Etheris OS** visible on desktop shots |
| RS2 | MemAvailable after soak **~2012 MiB** (≥1.0 GiB); no swap thrash |
| RS3 | Channel Archive DBs — covered by host A8 / reliability-check path |

---

## Notes

1. Earlier session misread zram **size** (~1697 MiB) as swap pressure; measured **swap used = 0B** throughout probes — R6 green without further preload changes.
2. `pgrep -a etheris-menu-hover` truncates at 15 chars; live script now uses `pgrep -af` (`scripts/test-rocksolid-live.sh`). Host/ISO unchanged — **no rebake required** for that fix.
3. Benign `systemd-loop@*sr0*` WARN only; doctor treats as non-FAIL.

---

## How to re-run

```bash
./scripts/reliability-check.sh
ETHERIS_STABILITY_MODE=rocksolid ./scripts/test-stability.sh out/etheris-2026.11.15-x86_64.iso
# optional full live battery:
./scripts/test-rocksolid-live.sh out/etheris-2026.11.15-x86_64.iso
```
