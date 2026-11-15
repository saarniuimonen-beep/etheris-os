# Etheris OS — Stability criteria (Beta 0.5)

**Principle:** A gate is **PASS** only with recorded evidence. Soft language (“seems fine”) is not a pass.

Automated runner: `scripts/test-stability.sh`  
Live evidence: `out/VERIFICATION-STABILITY-*.md` + `out/qemu-stability-*/`

---

## A. Automated MUST (host — every PR / every bake)

| ID | Criterion | How |
|----|-----------|-----|
| A1 | Profile consistency | `scripts/check-profile.sh` exit 0 |
| A2 | P0 security source | `scripts/test-p0-security.sh` → 0 FAIL |
| A3 | Super+A → Menu (control-center) | check-profile keybind gate |
| A4 | Super+D → launcher | check-profile keybind gate |
| A5 | Waybar **Menu** chip → control-center | check-profile |
| A6 | ReGreet `state.toml` password-first seed | check-profile + validate-iso |
| A7 | Stock `sway.desktop` hidden path present | check-profile / validate-iso |
| A8 | Channel Archive DBs reachable | `scripts/channel-validate.sh` |
| A9 | ISO squashfs gates (when ISO present) | `scripts/validate-iso.sh` → 0 FAIL |

`test-stability.sh` fails the run if any A-gate fails.

---

## B. Live MUST (KVM QEMU — every reliability / stability bake)

| ID | Criterion | Pass rule |
|----|-----------|-----------|
| B1 | Cold boot → ReGreet | Greeter UI within ~120 s |
| B2 | Password-first | Password field visible without Login click |
| B3 | Login `etheris`/`etheris` | Sway + Waybar (Etheris + Menu chip) |
| B4 | Super+A | Opens Etheris Menu sheet (control-center) |
| B5 | Super+D | Opens icon launcher |
| B6 | Overlay soak | ≥5 open/close of Menu + launcher; session still up |
| B7 | `etheris-auth-check` | **12 OK, 0 FAIL** (twice after soak preferred) |
| B8 | `nftables` + hide-sway | `systemctl is-active` → active |
| B9 | Shell processes | `sway`, `waybar`, `etheris-menu-hover` running |
| B10 | Desktop intact | Waybar still painted after soak + TTY round-trip |
| B11 | Preload hygiene | Firefox warm-start must not leave a visible workspace window (scratchpad only) |

---

## C. Explicitly NOT required for Stability PASS

| Item | Why |
|------|-----|
| Multi-day operator `rc` soak | Manual; tracked in channel-soak OUT |
| Physical GPU / Wi-Fi / suspend | L5 hardware matrix |
| Secure Boot “supported” | Unsupported by policy |
| Nested virt CI smoke | Optional nightly |

---

## D. Fix policy

If an **A** or **B** criterion fails:

1. Prefer a **product fix** in tree (keybind, greeter seed, preload scratchpad, unit enablement).
2. Re-run `scripts/test-stability.sh` (and live B-gates when UI-related).
3. Do **not** mark PASS by weakening the criterion without updating this file and saying why.

## E. Fixes applied for these criteria (2026-11-15)

| Criterion / failure | Fix |
|---------------------|-----|
| A3–A5 keybinds | `check-profile.sh` enforces Super+A Menu, Super+D launcher, Waybar Menu chip |
| B11 Firefox preload leaves workspace window | `etheris-browser` verifies off-workspace via `firefox_visible_on_ws` + retries |
| Maturity F1/F2/F3 (doctor clean) | `etheris-perf` HOME-safe + unit `Environment=HOME=/root`; `etheris-security` `as_root` shadow; doctor benign `systemd-loop@*sr0*` WARN |
| Guest automation typing | `libvirt-keys.sh` supports `$ ? > < \ \`` |

Live ISO `79106f8b…` still needs **rebake** to ship F1/F2/F3 + B11 in the guest. Host A-gates pass on tree now.

Also see [`MATURITY-CRITERIA.md`](MATURITY-CRITERIA.md).
