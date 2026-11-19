# Etheris OS — Bug criteria (extremely strict / rock-solid)

**Rule:** Claim **bug PASS** / **rock-solid bug bar** only when every **Must** is green with evidence.  
**Purpose:** Prevent regressions of bugs Etheris has already hit (auth, greeter, polkit, preload, units, install cleanup).  
**Runner:** `scripts/test-bugs.sh`  
**Related:** [`RELIABILITY-CRITERIA.md`](RELIABILITY-CRITERIA.md) · [`STABILITY-CRITERIA.md`](STABILITY-CRITERIA.md) · [`SECURITY-CRITERIA.md`](SECURITY-CRITERIA.md)

---

## Verdict

| Verdict | Meaning |
|---------|---------|
| **ROCK-SOLID PASS** | All Must B0–B2 green **and** live B3 green on ship ISO **without guest-apply** |
| **PASS** | All Must B0–B2 green (live B3 optional if evidence pending) |
| **FAIL** | Any B0–B2 red |

Do **not** weaken a Must to get green. Fix the product or document a new Must ID if the bar was wrong.

---

## Must B0 — Gate stack (every PR)

| ID | Criterion |
|----|-----------|
| B0.1 | `check-profile.sh` PASSED |
| B0.2 | `test-p0-security.sh` 0 FAIL (≥44 OK) |
| B0.3 | `reliability-check.sh` PASSED (when ISO present) |
| B0.4 | `test-security.sh` PASSED |
| B0.5 | No `__pycache__` / `*.pyc` under airootfs |

---

## Must B1 — Known regression seals (tree — every PR)

| ID | Bug sealed | Prove |
|----|------------|-------|
| B1.1 | Auth-check false FAIL on Python 3.13 (`crypt` removed) | `libcrypt` + `ctypes` in `etheris-auth-check` |
| B1.2 | `etheris-perf` `HOME: unbound variable` under systemd | `: "${HOME:=/root}"` + unit `Environment=HOME=` |
| B1.3 | Doctor FAIL on VM CDROM `systemd-loop@*` | `is_benign_failed_unit` matches `systemd-loop@*` |
| B1.4 | Security audit false FAIL without sudo | `as_root` + SKIP path |
| B1.5 | Firefox preload leaves visible workspace window | `firefox_visible_on_ws` + scratchpad retries |
| B1.6 | ReGreet uses deprecated `cache.toml` only | Live + installer seed **`state.toml`**; no legacy cache in airootfs |
| B1.7 | Stock Sway shown beside Etheris | hide-stock-sway unit enabled + helper present |
| B1.8 | Blanket polkit wheel `YES` | Scoped rules + `AUTH_ADMIN_KEEP` for pacman/perf |
| B1.9 | World-writable OOBE state | No `chmod 777/666` in oobe/installer; `2770`/`660` |
| B1.10 | Live auth-setup resets passwords on install | Live Conditions + installer **mask** |
| B1.11 | Live NOPASSWD sudo left on install | Installer `rm` live sudoers + password wheel |
| B1.12 | Menu hover multi-output geometry (ignore `ox`) | `point_in_sheet` uses `ox + ow` (not `ow` alone) |
| B1.13 | Super+A / Super+D wrong targets | `$cc` control-center · `$menu` launcher |
| B1.14 | skel ↔ `home/etheris` drift | `diff -qr` clean (or prepare-profile) |
| B1.15 | Avahi masked while Warpinator expected | avahi enabled, not `/dev/null` |
| B1.16 | Duplicate `.desktop` basenames | check-profile gate |
| B1.17 | Installer greeter seed wrong format | Installer writes `state.toml` + Etheris (Sway) |
| B1.18 | Keymap injection via unsafe LAYOUT | charset validation `[a-z0-9_-]+` |
| B1.19 | set -u scripts launched by systemd missing HOME | All `etheris-*.service` that run shell tools set `Environment=` or tools default HOME |
| B1.20 | Docs/scripts teach broken `pgrep -x etheris-menu-hover` | Criteria/docs use `pgrep -af` |
| B1.21 | Menu sheet clipped off right edge (hardcoded `move position 890`) | `_sway_float_corner` uses focused output `rect` |
| B1.22 | Settings/glass recreate `blur=on` | CC / theme-apply / hub / `etheris_glass.want_blur` default **`blur=off`** |
| B1.23 | Session/CC/power Lock bypasses branded lock | Prefer `etheris-lock` before raw `swaylock` |
| B1.24 | `etheris ram idle-check` never arms | After `shift`, `cmd_ram "${1:-}"` (not `${2:-}`) |
| B1.25 | Missing `browser_preload` warms Firefox | `preload_enabled` uses `${v:-off}` |
| B1.26 | Hub bootstrap omits idle-safe preload | Bootstrap writes `browser_preload=off` |
| B1.27 | Install leaves rolling mirrors + stable channel | Installer runs `etheris-update channel stable` (or coherent rewrite) |
| B1.28 | Duplicate `.desktop` **Name=** (launcher dupes) | Unique `Name=` across share + local applications |
| B1.29 | Defaults duped / private window skips lean | `etheris-browsers` ≠ Defaults; Firefox private → `etheris-browser` |

---

## Must B2 — ISO artifact (when ISO present)

| ID | Criterion |
|----|-----------|
| B2.1 | `validate-iso.sh` 0 FAIL |
| B2.2 | Squashfs contains B1.1–B1.5 / B1.6 / B1.17 seals (spot-check extract) |

---

## Must B3 — Live bug battery (KVM — every bug / release bake)

| ID | Criterion | Pass rule |
|----|-----------|-----------|
| B3.1 | Cold boot → password-first ReGreet | Password field / auto Etheris (Sway) |
| B3.2 | Login → Sway + Waybar | Desktop screenshot |
| B3.3 | `etheris-auth-check` | **12 OK, 0 FAIL** (regression seal for B1.1) |
| B3.4 | `etheris doctor` | **0 FAIL** (sr0 WARN OK) |
| B3.5 | `etheris-perf.service` | **active** without inject |
| B3.6 | Overlay soak | ≥**10** Super+A / Super+D open/close; session held |
| B3.7 | `pgrep -af etheris-menu-hover` | running |
| B3.8 | No product-relevant failed units | doctor / `systemctl --failed` |
| B3.9 | No guest-apply for the claim | Verification statement |

---

## Fix policy

1. Prefer a **product fix** in tree.  
2. Re-run `./scripts/test-bugs.sh`.  
3. Live B3: use `scripts/test-bugs-live.sh` (or rock-solid live) on the ship ISO.  
4. Never mark ROCK-SOLID PASS with guest-apply.
