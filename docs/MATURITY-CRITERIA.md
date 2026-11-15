# Etheris OS — Maturity pass criteria (strict / rock-solid)

**Date:** 2026-11-15 (strict revision)  
**Rule:** Claim **maturity PASS** only when every **Must** row is green with evidence.  
**No CONDITIONAL PASS** for rock-solid claims — tree-only fixes without live proof are **FAIL** until guest-apply or rebake shows green.  
**Scripts:** `scripts/maturity-check.sh` (host M0/M1 + tree) · live M2/M3 need QEMU screenshots + CLI.

Related: [`RELIABILITY-CRITERIA.md`](RELIABILITY-CRITERIA.md) · [`STABILITY-CRITERIA.md`](STABILITY-CRITERIA.md)

---

## Verdict

| Verdict | Meaning |
|---------|---------|
| **PASS** | Every Must row green with evidence |
| **FAIL** | Any Must row red, missing evidence, or only “fixed in tree” without live proof |

---

## Must — host / artifact

| ID | Criterion | Prove |
|----|-----------|-------|
| M0.1 | `check-profile.sh` PASSED | script log |
| M0.2 | `test-p0-security.sh` 0 FAIL | script log |
| M0.3 | Super+A → Menu · Super+D → launcher · Waybar Menu chip | check-profile keybind gates |
| M1.1 | `validate-iso.sh` 0 FAIL on ship ISO | script log |
| M1.2 | Channel Archive DBs reachable | `channel-validate.sh` |
| M1.3 | Tree ships doctor-clean fixes (`HOME:=/root`, unit `Environment=HOME`, security `as_root`/SKIP, doctor `systemd-loop@*`) | `maturity-check.sh` |

## Must — live boot / greeter

| ID | Criterion | Prove |
|----|-----------|-------|
| M2.1 | UEFI live boot → ReGreet ≤ ~120 s | screenshot |
| M2.2 | Password-first + auto `Etheris (Sway)` (no Login click) | greeter screenshot |
| M2.3 | Stock Sway hidden in greeter UI | greeter screenshot / unit active |

## Must — live desktop / rock-solid session

| ID | Criterion | Prove |
|----|-----------|-------|
| M3.1 | Login → Sway + Waybar (**Etheris** brand + **Menu** chip) | desktop screenshot |
| M3.2 | Super+A → Etheris MENU sheet | screenshot |
| M3.3 | Super+D → icon launcher | screenshot |
| M3.4 | Overlay soak: **≥5** open/close Menu + launcher; session still up | screenshots / note |
| M3.5 | `etheris-auth-check` **12 OK, 0 FAIL** — run **twice** (after soak) | CLI / screenshots |
| M3.6 | `nftables` is-active | CLI |
| M3.7 | `etheris-hide-stock-sway` + `etheris-regreet-cache` active | CLI |
| M3.8 | `sway` + `waybar` + `etheris-menu-hover` running | CLI |
| M3.9 | `etheris doctor` exit 0 (**0 FAIL**; WARN only for benign `systemd-loop@*`) | CLI / screenshot |
| M3.10 | No **product-relevant** failed units (`etheris-perf` must not be failed) | `systemctl --failed` + doctor |
| M3.11 | `etheris-perf.service` active (or oneshot RemainAfterExit success) | CLI |
| M3.12 | Desktop intact after soak + TTY round-trip (Waybar still painted) | screenshot |
| M3.13 | Watermark **Etheris OS** visible | desktop screenshot |

## Should (recorded; promote to Must before 1.0)

| ID | Criterion |
|----|-----------|
| S1 | MOTD Sway-only · BUILD_ID matches channels |
| S2 | rgb tools mode 755 |
| S3 | Firefox preload leaves no visible workspace window (scratchpad only) |
| S4 | Install / LUKS E2E when installer changed |
| S5 | Multi-day operator channel soak |

## Must not claim without separate gates

- Physical GPU / gaming on silicon  
- Secure Boot **supported**  
- SELinux enforcing  
- Bit-identical reproducible ISO  

---

## Fixes tied to these criteria

| Failure | Fix |
|---------|-----|
| `etheris-perf` `HOME: unbound variable` | `: "${HOME:=/root}"` + `Environment=HOME=/root` |
| security audit false FAIL without sudo | `as_root` / SKIP |
| doctor FAIL on VM `systemd-loop@*` | benign WARN (`systemd-loop@*`) |
| Firefox preload leaves workspace window | `firefox_visible_on_ws` + scratchpad retries |

Live ISO may need **guest-apply** or **rebake** before M3.9–M3.11 claim on stock squashfs.
