# Etheris OS — Stability criteria (Beta 0.5 → rock-solid)

**Principle:** A gate is **PASS** only with recorded evidence. Soft language (“seems fine”) is not a pass.  
**Rock-solid** means the stricter **R** table below — not the older 5-cycle smoke alone.

Automated runner: `scripts/test-stability.sh`  
Live evidence: `out/VERIFICATION-STABILITY-*.md` + `out/qemu-stability-*/` / `out/stability-rocksolid-*/`

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
| A10 | Maturity tree fixes present | `scripts/maturity-check.sh` tree section (perf HOME · security as_root · doctor benign filter) |

`test-stability.sh` fails the run if any A-gate fails.

---

## B. Live MUST (baseline — every reliability bake)

| ID | Criterion | Pass rule |
|----|-----------|-----------|
| B1 | Cold boot → ReGreet | Greeter UI within ~120 s |
| B2 | Password-first | Password field visible without Login click |
| B3 | Login `etheris`/`etheris` | Sway + Waybar (Etheris + Menu chip) |
| B4 | Super+A | Opens Etheris Menu sheet (control-center) |
| B5 | Super+D | Opens icon launcher |
| B6 | Overlay soak | ≥**8** open/close of Menu + launcher; session still up (was 5; rock-solid) |
| B7 | `etheris-auth-check` | **12 OK, 0 FAIL** **twice** after soak (both runs required) |
| B8 | `nftables` + hide-sway + regreet-cache | `systemctl is-active` → active |
| B9 | Shell processes | `sway`, `waybar`, `etheris-menu-hover` running |
| B10 | Desktop intact | Waybar still painted after soak + TTY round-trip |
| B11 | Preload hygiene | Firefox warm-start must not leave a visible workspace window (scratchpad only) |
| B12 | `etheris doctor` | exit 0 · **0 FAIL** (WARN OK for `systemd-loop@*` only) |
| B13 | `etheris-perf.service` | active without guest-apply |
| B14 | No guest-apply | Verification must not depend on HTTP inject for PASS |

---

## R. Rock-solid MUST (stricter performance / soak)

Claim **rock-solid PASS** only when **A + B + all R** are green.

| ID | Criterion | Pass rule |
|----|-----------|-----------|
| R1 | Fast greeter | ReGreet usable ≤ **90 s** after `virsh start` (KVM) |
| R2 | Deep overlay soak | ≥ **15** Menu (Super+A) + launcher (Super+D) open/close pairs; no session drop |
| R3 | Auth triple | `etheris-auth-check` **12 OK / 0 FAIL** three times (pre-soak, mid, post) |
| R4 | Doctor clean | `etheris doctor` **exit 0** (product-relevant units only; benign `systemd-loop@*sr0*` WARN OK) |
| R5 | Perf unit healthy | `etheris-perf.service` **active** (oneshot RemainAfterExit) or exited 0 — not failed |
| R6 | Memory steady | After R2: **swap used = 0**; guest `MemUsed` ≤ **1.8 GiB** on 3.5 GiB VM (or growth ≤ **400 MiB** vs post-login baseline) |
| R7 | Shell still up | `pgrep -x sway` · `pgrep -x waybar` · `pgrep -af etheris-menu-hover` after R2 (use `-f`; name >15 chars) |
| R8 | Terminal stress | Super+Return open + close (Esc / exit) × **5**; session held |
| R9 | Services | `nftables` + `etheris-hide-stock-sway` active; `etheris-regreet-cache` active/exited |
| R10 | Final desktop | Waybar + Etheris brand still painted after all R gates |
| R11 | Second cold boot | Destroy → start → greeter → login → desktop still works (no “second boot brick”) |

---

## C. Explicitly NOT required for rock-solid PASS

| Item | Why |
|------|-----|
| Multi-day operator `rc` soak | Manual; tracked in channel-soak OUT |
| Physical GPU / Wi-Fi / suspend | L5 hardware matrix |
| Secure Boot “supported” | Unsupported by policy |
| Nested virt CI smoke | Optional nightly |
| Bit-identical ISO | Reproducibility doc only |

---

## D. Fix policy

If an **A**, **B**, or **R** criterion fails:

1. Prefer a **product fix** in tree (keybind, greeter seed, preload scratchpad, unit enablement, doctor/perf).
2. Re-run `scripts/test-stability.sh` and the live rock-solid battery.
3. Do **not** mark PASS by weakening the criterion without updating this file and saying why.

## E. Fixes applied for these criteria (2026-11-15)

| Criterion / failure | Fix |
|---------------------|-----|
| A3–A5 keybinds | `check-profile.sh` enforces Super+A Menu, Super+D launcher, Waybar Menu chip |
| B11 Firefox preload leaves workspace window | `etheris-browser` verifies off-workspace via `firefox_visible_on_ws` + retries |
| R4/R5 / maturity F1–F3 | `etheris-perf` HOME-safe + `Environment=HOME=/root`; `etheris-security` `as_root`; doctor benign loop WARN |
| Guest automation typing | `libvirt-keys.sh` supports `$ ? > < \ \`` |

Also see [`MATURITY-CRITERIA.md`](MATURITY-CRITERIA.md).
