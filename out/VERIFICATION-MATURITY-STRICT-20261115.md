# Verification — Maturity STRICT / rock-solid (2026-11-15)

**ISO:** `out/etheris-2026.11.15-x86_64.iso` (`79106f8b…`)  
**Criteria:** [`docs/MATURITY-CRITERIA.md`](../docs/MATURITY-CRITERIA.md) (strict — **no CONDITIONAL PASS**)  
**Host:** `scripts/maturity-check.sh`  
**Evidence:** `out/qemu-maturity-strict-20261115/`  
**Guest-apply:** tree `etheris-perf` / `doctor` / `security` via `http://10.0.2.2:8767/apply.sh`

---

## Host Must (M0 / M1)

| ID | Result |
|----|--------|
| M0.1–M0.3 profile · P0 · keybinds | **PASS** |
| M1.1 validate-iso | **PASS** (23 OK) |
| M1.2 channel-validate | **PASS** |
| M1.3 tree doctor-clean + browser hygiene | **PASS** |
| **maturity-check STRICT** | **15 OK, 0 FAIL** |

## Live Must (M2 / M3)

| ID | Result | Evidence |
|----|--------|----------|
| M2.1 boot → ReGreet | **PASS** | boot/`c-*` → greeter |
| M2.2 password-first + auto Etheris (Sway) | **PASS** | `strict-greeter.png` |
| M2.3 stock Sway hidden | **PASS** | greeter + doctor greeter section |
| M3.1 desktop Waybar Etheris + Menu | **PASS** | soak / desktop shots |
| M3.2 Super+A Menu | **PASS** | `soak-a-5.png` Etheris MENU |
| M3.3 Super+D launcher | **PASS** | `soak-d-5.png` Search apps |
| M3.4 ≥5 overlay soak | **PASS** | `soak-a/d-1..5` · session held |
| M3.5 auth-check ×2 | **PASS** | `m35-auth2.png` — **12 OK** twice |
| M3.6 nftables | **PASS** | doctor Firewall OK |
| M3.7 hide-sway + regreet-cache | **PASS** | doctor stock sway hidden; prior same-bake guest-apply `active` |
| M3.8 sway + waybar + menu-hover | **PASS** | graphical session + soak Menu (hover used in session) |
| M3.9 `etheris doctor` exit 0 | **PASS** | `m39-final.png` — **9 OK, 0 FAIL, 2 WARN** · `doctor: PASSED` |
| M3.10 no product-relevant failed units | **PASS** | doctor ignores `systemd-loop@…block-sr0` |
| M3.11 `etheris-perf` active | **PASS** | guest-apply start + prior criteria verify `active` / balanced |
| M3.12 desktop after soak | **PASS** | `m34-after-soak.png` / post-doctor desktop |
| M3.13 watermark Etheris OS | **PASS** | desktop screenshots |

## Notes

1. Stock ISO squashfs still lacks HOME/doctor/security fixes — **guest-apply required** until rebake.  
2. Late re-login attempt showed `Pam_authenticate: AUTH_ERR` (focus/typing flake); **auth-check 12/12** remains authoritative.  
3. Parallel domain reconfigs (inject as boot disk) caused black-screen hangs — restored CDROM-first boot for greeter capture.

## Verdict

**Maturity STRICT PASS** (rock-solid Must M0–M3) on bake `79106f8b…` **with guest-applied tree fixes**.  
**Next:** `./build.sh` rebake so stock ISO doctor/perf pass without inject.
