# Etheris OS — Reliability pass criteria (Alpha 0.2 → rock-solid)

**Date:** 2026-11-15 (stricter revision)  
**Rule:** Claim **reliability PASS** only when every **Must** row is green with evidence.  
**Rock-solid rule:** Claim **rock-solid PASS** only when every Must **and** every Rock-solid row is green **on the shipped ISO** — guest-apply / inject does **not** count.  
**Host script:** `scripts/reliability-check.sh` (L0/L1 + tree + rock-solid tree gates). Live L2/L3 need QEMU screenshots.  
**Related:** [`MATURITY-CRITERIA.md`](MATURITY-CRITERIA.md) · [`STABILITY-CRITERIA.md`](STABILITY-CRITERIA.md)

---

## Verdict

| Verdict | Meaning |
|---------|---------|
| **ROCK-SOLID PASS** | All Must + Rock-solid rows green on bake SHA; no guest-apply |
| **PASS** | All Must rows green (live OK; tree fixes may still await rebake) |
| **FAIL** | Any Must L0–L3 desktop/auth/services gate red |

**CONDITIONAL PASS is retired** for new claims. Use FAIL + “fixed in tree, rebake pending” instead.

---

## Must

| ID | Criterion | Prove with |
|----|-----------|------------|
| R0.1 | `check-profile.sh` PASSED | script log |
| R0.2 | `test-p0-security.sh` 0 FAIL (≥44 OK after 2026-11-15 expansion) | script log |
| R0.3 | `bash -n` on all `airootfs/usr/local/bin/etheris*` shell scripts | `reliability-check.sh` |
| R0.4 | `python3 -m py_compile` on all `etheris*` Python scripts under airootfs | `reliability-check.sh` |
| R0.5 | Keybinds: Super+A Menu · Super+D launcher · Waybar Menu chip | check-profile |
| R0.6 | No legacy ReGreet `cache.toml`/`cache.json` in airootfs | check-profile |
| R0.7 | `test-stability.sh` A-gates 0 FAIL (host) | script log |
| R1.1 | `validate-iso.sh` 0 FAIL on ship ISO | script log |
| R1.2 | Squashfs ships perf HOME-safe + doctor `systemd-loop@*` filter + security `as_root` | validate-iso / reliability-check |
| R2.1 | UEFI live boot → ReGreet | screenshot |
| R2.2 | Password-first + auto `Etheris (Sway)` | greeter screenshot |
| R3.1 | Login → Sway + Waybar (**Etheris** brand + **Menu**) | desktop screenshot |
| R3.2 | Super+A → Etheris MENU sheet | screenshot |
| R3.3 | Super+D → icon launcher | screenshot |
| R3.4 | `etheris-auth-check` 0 FAIL | CLI / screenshot |
| R3.5 | `nftables` is-active | CLI |
| R3.6 | `etheris doctor` exit 0 (**0 FAIL**; WARN OK for benign VM loop) | CLI |
| R3.7 | No **product-relevant** failed systemd units | `systemctl --failed` — `systemd-loop@*` WARN only |
| R3.8 | `etheris-hide-stock-sway` + `etheris-regreet-cache` active | CLI |

---

## Rock-solid (blocking for rock-solid PASS)

| ID | Criterion | Prove with |
|----|-----------|------------|
| RR1 | `etheris-menu-hover` running after login | `pgrep -af etheris-menu-hover` (not `-x`; name >15 chars) |
| RR2 | `etheris-perf.service` active **without** guest-apply | `systemctl is-active` on clean boot |
| RR3 | Overlay soak: ≥**8** open/close of Menu + launcher; session still up | screenshots |
| RR4 | `etheris-auth-check` **twice** after soak → 12 OK / 0 FAIL each | CLI ×2 |
| RR5 | Desktop intact after soak + TTY round-trip | final desktop screenshot |
| RR6 | Firefox preload does not leave a visible workspace window | `firefox_visible_on_ws` path in tree + live spot-check |
| RR7 | Doctor/security/perf binaries in **ISO squashfs** match tree rock-solid fixes | validate-iso R1.2 |
| RR8 | No guest-apply / HTTP inject used for the claimed bake | verification report statement |

---

## Should (recorded, not blocking PASS; preferred for rock-solid)

| ID | Criterion |
|----|-----------|
| RS1 | Watermark **Etheris OS** visible |
| RS2 | MemAvailable after soak ≥ 1.0 GiB on 4 GiB VM (no swap thrash) |
| RS3 | Channel Archive DBs reachable (`channel-validate.sh`) |

---

## Fixes tied to these criteria

| Failure | Fix in tree |
|---------|-------------|
| `etheris-perf` `HOME: unbound variable` | `: "${HOME:=/root}"` + unit `Environment=HOME=/root` |
| security audit “no password hash” without sudo | `as_root` / SKIP |
| doctor FAIL on VM `systemd-loop@*` | `is_benign_failed_unit` → WARN only |
| Firefox preload leaves workspace window | `etheris-browser` `firefox_visible_on_ws` + scratchpad retries |
| Installer greeter seed drift | Installer writes `state.toml` only |

Ship via ISO rebake. Guest-apply is for debugging only — never for rock-solid claims.
