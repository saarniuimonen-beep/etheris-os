# Verification — Beta 0.5 Stability battery (2026-11-15)

KVM QEMU (`qemu:///session`). Evidence: `out/qemu-stability-20261115/` · host logs `out/stability-20261115/`.

## Artifact

| Item | Value |
|------|--------|
| ISO | `out/etheris-2026.11.15-x86_64.iso` |
| SHA256 | `79106f8b47177585a113075d79153141e13ccbfd97363911768318e1ecb8b105` |
| Accel | KVM · host-passthrough |
| Domain | `etheris-os` (live CD boot) |

## L0 — Static / source

| Gate | Result | Evidence |
|------|--------|----------|
| `scripts/check-profile.sh` | **PASS** (14 OK) | `out/stability-20261115/l0.txt` |
| `scripts/test-p0-security.sh` | **PASS — 30 OK, 0 FAIL** | same |

## L1 — ISO artifact

| Gate | Result | Evidence |
|------|--------|----------|
| `scripts/validate-iso.sh` | **PASS — 23 OK, 0 FAIL** | `out/stability-20261115/l1-validate.txt` |

## Channel (Beta 0.5)

| Gate | Result | Evidence |
|------|--------|----------|
| `scripts/channel-soak.sh` | **PASS** (Archive DBs OK) | `out/channel-soak-20261115T185121Z/` |
| stable/rc core+extra DB reachability | **OK** | `channel-validate-20261115T185121Z.md` |
| Operator multi-day `rc` soak | **Not run** (manual checklist open) | `SOAK-CHECKLIST.md` |

## L3 — Live desktop stability smoke

| Check | Result | Evidence |
|-------|--------|----------|
| Cold boot → ReGreet | **PASS** (~55 s) | `01-greeter.png` |
| Password-first card (no Login click) | **PASS** | `01-greeter.png` (Password field + auto session toast) |
| Login `etheris`/`etheris` → Sway+Waybar | **PASS** | `05-desktop.png` |
| Super+A / Super+D ×5 open/close | **PASS** (no crash; session held) | `cycle1–5-{menu,launcher}.png` |
| Icon launcher overlay | **PASS** | `cycle1-launcher.png` |
| Etheris MENU sheet | **PASS** | `cycle5-menu.png` |
| `etheris-auth-check` (post-cycles) | **PASS — 12 OK, 0 FAIL, 0 SKIP** | `tty-auth-check.png` |
| Auth-check round 2 | **PASS — 12 OK, 0 FAIL** | `tty-auth2b.png` |
| `nftables` active | **PASS** | `tty-services.png` |
| `etheris-hide-stock-sway` active | **PASS** | `tty-services.png` |
| `etheris-regreet-cache` oneshot | **PASS** (prior `active`; RemainAfterExit) | unit + services shot |
| sway + waybar + `etheris-menu-hover` | **PASS** | `tty-procs.png` |
| `etheris doctor` | **PASS** (system info printed) | `tty-doctor2.png` |
| Memory after cycles | **1.3 GiB / 3.3 GiB · swap 0B** | `tty-auth2b.png` / OCR |
| Desktop still up after TTY round-trip | **PASS** | `12-final-desktop.png` |

## Notes

1. Password-first greeter on bake `79106f8b…` is **PASS** (improvement vs earlier PARTIAL on `ec72603b…`).
2. During Super+A cycles, Firefox/Settings windows also appeared (automation key timing / live app focus). Menu and launcher still opened; compositor did not crash or drop the session.
3. Multi-day operator channel soak and physical GPU matrix remain **out of scope** for this automated battery.

## Verdict

**Stability battery PASS** for bake `79106f8b…`: L0 + L1 + channel Archive validate + live desktop 5× Menu/launcher soak with auth-check 12/12 twice, firewall/session units healthy, desktop intact.

Formal Must IDs + host runner: [`docs/STABILITY-CRITERIA.md`](../docs/STABILITY-CRITERIA.md) · `scripts/test-stability.sh` — follow-up [`VERIFICATION-STABILITY-CRITERIA-20261115.md`](VERIFICATION-STABILITY-CRITERIA-20261115.md).
