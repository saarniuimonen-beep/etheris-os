# Etheris OS — Session log (continue here)

**Last updated:** 2026-11-19T21:00+0200  
**Version:** 0.1.0-alpha  
**Host:** Omarchy (Arch-like; builds via Podman `--network=host`; tests via `qemu:///session`)

Use this file to resume. Detail lives in the linked docs; this is the handoff.

---

## Status snapshot — CONTINUE HERE (2026-11-19 · Audio/net/BT refine)

| Item | Status |
|------|--------|
| Tree | PipeWire global sockets + `etheris-session-ready` + `etheris-volume` toasts |
| Waybar | volume scroll/mute · network tooltips · `custom/bluetooth` (`etheris-bt-status`) |
| Wi‑Fi | NM + iwd (no IP in iwd) · nm-applet · AutoEnable BT · blueman polkit |
| Seals | `scripts/test-connectivity-tree.sh` **22 OK** · check-profile PASS |
| Still | Physical Wi‑Fi/BT DUT rows open — rebake ISO to ship |

---

## Status snapshot — CONTINUE HERE (2026-11-19 · Game-ready ROCK-SOLID PASS)

| Item | Status |
|------|--------|
| ISO | `out/etheris-2026.11.19-x86_64.iso` |
| SHA256 | `b85e420473966437b3534e7c253d639e27305bd5725dd2b6cfcd45d393036a63` |
| Criteria | [`docs/GAME-READY-CRITERIA.md`](docs/GAME-READY-CRITERIA.md) · `scripts/test-game-ready.sh` / `test-game-ready-live.sh` |
| Host G0–G2 + G3 evidence | **32 OK, 0 FAIL** |
| Live G3 (no guest-apply) | **8 OK** · cow **2G** · `max_map_count=2147483642` · steam/wine/gamemode/mangohud/gamescope · `gamemode_group=yes` |
| Drivers (QEMU) | Virtio honest · llvmpipe · Vulkan no ICD (expected) |
| Evidence | [`out/VERIFICATION-GAME-READY-ROCKSOLID-20261119.md`](out/VERIFICATION-GAME-READY-ROCKSOLID-20261119.md) · `out/qemu-game-ready-20261119T182226Z/` |
| **Not claimed** | Physical GPU / real Steam titles / anti-cheat online — needs DUT matrix |

### Game-ready fixes this pass

| Fix | Why |
|-----|-----|
| Dropped `lib32-openal` | Arch removed package → ISO bake `target not found` |
| Hub Steam present/missing | Stopped always claiming “pre-installed” on lean installs |
| Template + hook (no airootfs `/usr/share` dupe) | `etheris/desktop/steam.desktop` + pacman hook / live-ready rewrite stock desktop |
| Modeset + GameMode group + no global SDL X11 | Wayland Steam/games path; doctor gate |

---

## Status snapshot — CONTINUE HERE (2026-11-19 · Extreme polish bake)

### ISO + gates

| Item | Status |
|------|--------|
| ISO | `out/etheris-2026.11.19-x86_64.iso` |
| SHA256 | `b85e420473966437b3534e7c253d639e27305bd5725dd2b6cfcd45d393036a63` |
| `validate-iso` | **30 OK** (packages/privacy/report/software/monitor/profiles/groups) |
| Host reliability / maturity | **21 OK** · **15 OK** |
| Rock-solid live | **11 OK, 0 FAIL** · greeter **53s** · auth **12 OK** · doctor **16 OK** |
| Evidence | [`out/VERIFICATION-POLISH-20261119.md`](out/VERIFICATION-POLISH-20261119.md) · `out/qemu-rocksolid-20261119T170252Z/` · `out/qemu-polish-20261119/` |

### Extreme polish shipped

| Area | Change |
|------|--------|
| Software Center | GTK filter · install/remove · installed counts · office group |
| Monitor | CLI + GTK live UI · session_pss gate |
| Privacy / report / packages | Richer CLI · doctor tooling section · report extras |
| Lock | Wallpaper fill + Neo-Aero indicator |
| Desktop consistency | Waybar `etheris` wordmark · glass blur default **off** (tokens) |
| validate-iso | Local extract now includes Alpha 0.4 binaries (fixed false FAIL) |

## Status snapshot — CONTINUE HERE (2026-11-19 · Bug criteria ROCK-SOLID PASS)

| Item | Status |
|------|--------|
| `docs/BUG-CRITERIA.md` · `scripts/test-bugs.sh` | **ROCK-SOLID PASS — 38 OK** (B0–B2 + B1.22–B1.29 seals) |
| Live B3 (no guest-apply) | **7 OK** · auth **12 OK** · doctor **0 FAIL** · perf/hover active · soak ×10 |
| ISO | `etheris-2026.11.19` · SHA256 `173b316bf047373a100b23b93fde678fa98002314a6930ac2b899d2350c63cf0` |
| Evidence | [`out/VERIFICATION-BUGS-ROCKSOLID-20261119.md`](out/VERIFICATION-BUGS-ROCKSOLID-20261119.md) · `out/qemu-bugs-20261119T174218Z/` |

Gate hygiene: host `__pycache__` no longer false-fails B0.1 (cleaned before profile/reliability).

---

### Follow-up (tree — post-bake, from explore P0/P1)

Fixed in tree after ISO bake (guest-apply: `out/p0-followup-apply.tgz`):

| Fix | Detail |
|-----|--------|
| Lock routing | CC / power-menu / hub → `etheris-lock` (+ variant tokens) |
| Settings seeds | blur=`off`, `browser_preload=off` (CC / theme-apply / hub) |
| `etheris ram idle-check` | argv was `${2:-}` after shift → `${1:-}` |
| browser preload default | missing key → **off** |
| Desktop dupes | Browsers vs Defaults names; Firefox private → `etheris-browser` |
| Overview click | Waybar → `etheris-overlay menu …` |
| OOBE | `ETHERIS_SKIP_OOBE=1` honored; default theme `ocean-glass` |
| Installer | rewrite channel/mirrors via `etheris-update channel stable` |
| Foot palettes | distinct dark/light from both token files |
| Update locks | channel/refresh acquire lock |

**Still needs rebake** to ship without inject. Live ISO `2026.11.19` is otherwise rock-solid.

### Next

1. Guest-apply `out/p0-followup-apply.tgz` (+ optional `out/cc-monitor-apply.tgz`) or rebake.  
2. Owner soak Software Center Install on disk install.  
3. Keep website local · defer Secure Boot signed / public publish.

```bash
cd ~/etheris-os
tail -3 out/SHA256SUMS
virsh -c qemu:///session start etheris-os
# live: etheris / etheris · Super+A Menu · etheris software-center · etheris monitor ui
```

---

## Prior — CONTINUE HERE (2026-11-15 · Idle RAM ≤500 MiB ROCK-SOLID PASS)

### Idle RAM criteria (extremely strict)

| Item | Status |
|------|--------|
| `docs/IDLE-RAM-CRITERIA.md` · `scripts/measure-idle-ram.sh` | **PASS** |
| Pre-fix (2× before fix) | A **167 MiB** (after pkill) · B **972 MiB OVER** (warm Firefox) |
| Fix | `browser_preload=off` default · lean Super+B kept · idle-check requires `firefox: no` |
| Post-fix cold boots (no guest-apply) | A **169 MiB** · B **169 MiB** · both OK |
| IR4 | auth **12 OK** · nftables/NM **active** · PipeWire · Menu Super+A · launcher Super+D |
| ISO | `out/etheris-2026.11.15-x86_64.iso` · SHA256 `eb677f92d3d6a336b1eca3f6b8f64de4e649badabf22c17366468c3a4b05dfd6` |
| Evidence | [`out/VERIFICATION-IDLE-RAM-ROCKSOLID-20261115.md`](out/VERIFICATION-IDLE-RAM-ROCKSOLID-20261115.md) · `out/qemu-idle-ram-verify-20261115T203447Z/` |

## Status snapshot — CONTINUE HERE (2026-11-15 · Bug criteria ROCK-SOLID PASS)

### Bug criteria (extremely strict)

| Item | Status |
|------|--------|
| `docs/BUG-CRITERIA.md` · `scripts/test-bugs.sh` | **PASS — host B0–B2 green** |
| Live B3 | **PASS** — password-first · auth **12 OK** · doctor **0 FAIL** · perf active · hover · 10× soak |
| Menu clip bug (hardcoded X=890) | **Fixed** (B1.21) · shipped in ISO |
| ISO | `2783b15843106eb920e80fcb66fb7b725c9065439eef90e0114021a7c337326c` |
| Evidence | [`out/VERIFICATION-BUGS-ROCKSOLID-20261115.md`](out/VERIFICATION-BUGS-ROCKSOLID-20261115.md) · `out/qemu-bugs-20261115T201952Z/` |


## Status snapshot — CONTINUE HERE (2026-11-15 · Security criteria PASS)

### Security criteria (stricter / rock-solid)

| Item | Status |
|------|--------|
| `docs/SECURITY-CRITERIA.md` · `scripts/test-security.sh` | **PASS — 22 OK, 0 FAIL** |
| ISO | `49ee87b5…` (validate-iso **30 OK**) |
| Live auth-check / sshd masked | **PASS** |
| Audit hardening in ISO | sshd masked · forward drop · no :22 · `as_root` |

Evidence: [`out/VERIFICATION-SECURITY-20261115.md`](out/VERIFICATION-SECURITY-20261115.md)

## Prior — Rock-solid reliability PASS

### Rock-solid reliability (stricter than prior smoke)

| Item | Status |
|------|--------|
| Criteria | [`docs/RELIABILITY-CRITERIA.md`](docs/RELIABILITY-CRITERIA.md) + [`docs/STABILITY-CRITERIA.md`](docs/STABILITY-CRITERIA.md) R1–R11 |
| Host `reliability-check.sh` | **21 OK, 0 FAIL** (P0 ≥44 · bash -n · py_compile · ISO squashfs markers) |
| ISO | `out/etheris-2026.11.15-x86_64.iso` · SHA256 `49ee87b5e8db6c309e4f051873d82ae7c6036b51e9f13e2f5de7ff9c3625fc25` |
| Live 15× soak · auth 12/12 · doctor 0 FAIL · perf active · swap 0 · 2nd cold boot | **PASS** · **no guest-apply** |
| Evidence | [`out/VERIFICATION-STABILITY-ROCKSOLID-20261115.md`](out/VERIFICATION-STABILITY-ROCKSOLID-20261115.md) · `out/qemu-rocksolid-20261115T195200Z/` |


## Status snapshot — CONTINUE HERE (2026-11-15 · Maturity STRICT PASS)

### Maturity STRICT (rock-solid Must)

| Item | Status |
|------|--------|
| `docs/MATURITY-CRITERIA.md` | **Strict** — no CONDITIONAL PASS; soak · doctor · units Must |
| `scripts/maturity-check.sh` | **PASS — 15 OK** |
| Live M2/M3 (guest-apply) | **PASS** — doctor 0 FAIL · auth×2 · 5× Menu/launcher soak |
| Evidence | [`out/VERIFICATION-MATURITY-STRICT-20261115.md`](out/VERIFICATION-MATURITY-STRICT-20261115.md) |

### Reliability criteria + product fixes

| Item | Status |
|------|--------|
| `docs/RELIABILITY-CRITERIA.md` · `scripts/reliability-check.sh` | **Added** · host **11 OK** |
| R3.6 `etheris doctor` (guest-apply) | **PASS** — 9 OK / 0 FAIL / 2 WARN |
| R3.7 product-relevant failed units | **PASS** — `systemd-loop@*` WARN only |
| `etheris-perf` HOME unbound | **Fixed** — `: "${HOME:=/root}"` + unit `Environment=HOME=/root` · live **active** |

Evidence: [`out/VERIFICATION-RELIABILITY-CRITERIA-20261115.md`](out/VERIFICATION-RELIABILITY-CRITERIA-20261115.md) · `out/qemu-reliability-criteria-20261115/`  
**Next bake:** ship perf/doctor/security without inject.

### Stability criteria + product fixes

| Item | Status |
|------|--------|
| `docs/STABILITY-CRITERIA.md` | **Added** (A1–A9 · B1–B11) |
| `scripts/test-stability.sh` | **PASS — 5 OK, 0 FAIL** |
| `check-profile` keybind Must | Super+A Menu · Super+D launcher · Waybar Menu |
| Firefox preload B11 | **Fixed in tree** (`firefox_visible_on_ws`) |
| Maturity F1/F2/F3 | **Fixed in tree** — live doctor PASS via guest-apply; rebake to ship |

Evidence: [`out/VERIFICATION-STABILITY-CRITERIA-20261115.md`](out/VERIFICATION-STABILITY-CRITERIA-20261115.md)

### Maturity test + criteria (full L0–L3 + doctor)

| Gate | Result |
|------|--------|
| Criteria | [`docs/MATURITY-CRITERIA.md`](docs/MATURITY-CRITERIA.md) · `scripts/maturity-check.sh` **PASSED** |
| L0/L1 | **PASS** |
| L2/L3 desktop Must | **PASS** (greeter/Menu/launcher/auth/nftables) |
| M3.6/M3.7 doctor | **PASS** after guest-apply (ISO bake still needs rebake to ship) |

Reports: [`out/VERIFICATION-MATURITY-20261115.md`](out/VERIFICATION-MATURITY-20261115.md) · [`out/VERIFICATION-MATURITY-CRITERIA-20261115.md`](out/VERIFICATION-MATURITY-CRITERIA-20261115.md)

### Reliability test (Alpha 0.2 L0–L3 retest)

| Gate | Result |
|------|--------|
| L0 profile + P0 | **PASS** (profile + 30 OK) |
| L1 `validate-iso` | **PASS** (23 OK) |
| L2 UEFI smoke | **PASS** (boot menu; OVMF 4m path fixed in `test-iso-smoke.sh`) |
| Password-first greeter | **PASS** (cold live) |
| Desktop + Super+A/D | **PASS** |
| `etheris-auth-check` | **12 OK / 0 FAIL** |
| nftables + hide-sway + regreet-cache + menu-hover | **active / running** |

Report: [`out/VERIFICATION-RELIABILITY-SMOKE-20261115-retest.md`](out/VERIFICATION-RELIABILITY-SMOKE-20261115-retest.md) · shots `out/qemu-reliability-smoke-20261115-retest/`

### Stability test (Beta 0.5)

| Gate | Result |
|------|--------|
| L0 profile + P0 | **PASS** (14 + 30 OK) |
| L1 `validate-iso` | **PASS** (23 OK) |
| Channel soak scaffold | **PASS** — `out/channel-soak-20261115T185121Z/` |
| Live desktop 5× Menu/launcher | **PASS** — session held |
| Password-first greeter | **PASS** (cold boot) |
| `etheris-auth-check` ×2 | **12 OK / 0 FAIL** |
| nftables + hide-sway + sway/waybar/hover | **active / running** |

Report: [`out/VERIFICATION-STABILITY-20261115.md`](out/VERIFICATION-STABILITY-20261115.md) · shots `out/qemu-stability-20261115/`

### Prior stretch — remaining gates closed

| Item | Status |
|------|--------|
| LUKS install + unlock E2E | **PASS** — [`out/VERIFICATION-LUKS-E2E-20261115.md`](out/VERIFICATION-LUKS-E2E-20261115.md) |
| Neo-Aero D2/D3 | **Done (tree)** — lock/launcher/CC/profiles/monitor |
| Secure Boot Alpha | **Done as unsupported** — OVMF secboot probe + plan |
| Hardware matrix honesty | **Done** — QEMU + host inventory; physical DUT **BLOCKED** |
| Channel validate/soak scaffold | **Done** — `out/channel-soak-20261115T183848Z/` (+ re-run `…T185121Z`) |
| Build image pin | **Done** — `out/build-image.pin` |
| P0 | **30 OK** |

Rollup: [`out/VERIFICATION-REMAINING-GATES-20261115.md`](out/VERIFICATION-REMAINING-GATES-20261115.md)

### ISO (current)

| ISO | SHA256 | Notes |
|-----|--------|-------|
| `out/etheris-2026.11.15-x86_64.iso` | `79106f8b47177585a113075d79153141e13ccbfd97363911768318e1ecb8b105` | Phase impl · reliability + stability PASS · LUKS E2E PASS |

### Still open (honest — not claimable without DUT / owner)

- Physical Etheris-on-DUT GPU rows (≥3)  
- Secure Boot **signed** images / “supported” claim  
- Multi-day operator channel soak  
- Rebake to ship `etheris-lock` CSS on live ISO  
- **1.0** release / `PUBLISH-APPROVAL`  

---

## Prior — Phases 0.2→1.0 scaffolding

### Done this stretch (beyond Alpha 0.2 Critical)

| Area | Deliverable |
|------|-------------|
| 0.2 tail | `INSTALLER-FAILURE-MODES.md`, `UPDATE-RECOVERY.md` + update locks, HW matrix QEMU rows, `pin-build-image.sh` |
| 0.3 | `LUKS-PLAN` / `SECURE-BOOT-PLAN` / `SELINUX-STUDY` / `SECURITY-UPDATES` (**plans only** — no LUKS/SB merge) |
| 0.4 | `etheris-packages` groups · `etheris software` · `etheris-report` · `etheris privacy` |
| Beta | `RECOVERY.md` · `REPRODUCIBILITY.md` · `RELEASE-PREP-1.0.md` |
| Neo-Aero | DESIGN.md glossary (D0); tokens already synced (D1) |

### Still open (needs HW / long E2E / GTK)

- LUKS installer implementation + E2E  
- Secure Boot prototype on OVMF  
- Physical GPU matrix rows  
- GTK Software Center / CC Privacy tile  
- Neo-Aero D2–D3 chrome  
- Install persistence E2E re-run on `37566bb8…`

---

## Prior — Alpha 0.2 Critical impl

### Done (tree — needs rebake for ISO proof)

| Item | Change |
|------|--------|
| `scripts/validate-iso.sh` | L1 squashfs gates + SHA256SUMS update |
| Password-first greeter | Seed **`/var/lib/regreet/state.toml`** (upstream CACHE_PATH); drop wrong `cache.toml`/`cache.json` |
| `etheris doctor` | New `etheris-doctor` + hub `etheris doctor` |
| Token SoT | phase-2 → share JSON **panel 28/0**; skel **`blur=off`**; prepare-profile syncs |
| Gaming leaner | Installer default **`ETHERIS_INSTALL_GAMING=0`** (opt-in `=1`); live ISO still ships stack |

**Root cause (greeter):** ReGreet reads `/var/lib/regreet/state.toml` with `last_user` + `[user_to_last_sess]` keyed by desktop **Name=** (`Etheris (Sway)`), not `cache.toml` with path fields.

**Still not claimed:** LUKS / Secure Boot / SELinux / Software Center · install E2E re-run on this ISO

**Gates:** profile PASSED · P0 30 OK · **validate-iso 15 OK** · greeter password-first **PASS** (screenshots)

### ISO

| ISO | SHA256 | Notes |
|-----|--------|-------|
| `out/etheris-2026.11.15-x86_64.iso` | `37566bb8dce73bc2f2ef31ce29c331bf447b2e72e8d9f48e724a7ddabdb8d4d4` | Alpha 0.2 Critical · validate-iso + password-first |

Evidence: [`out/VERIFICATION-ALPHA02-CRITICAL-20261115.md`](out/VERIFICATION-ALPHA02-CRITICAL-20261115.md) · `out/qemu-alpha02-greeter-20261115/`

### Next

```bash
# Optional: login → etheris doctor · Super+A/D on this bake
# Then Alpha 0.3 prep (LUKS research only) when ready
```
### Prior — Menu polish (2026-11-15 afternoon)

Hot-patched + verified on `etheris-os` VM — evidence `out/qemu-menu-polish-20261115/`.  
Previous ISO bake-2 `682bc46e…` had chrome only (Menu polish was tree-only until this rebake).


## Prior snapshot — 2026-11-13 night (install persistence)

### Rebake + KVM + install persistence E2E — **DONE**

**ISO:** `out/etheris-2026.11.13-x86_64.iso`  
**SHA256:** `ebb52857a123dbc9e01539a905e13f3cb2b90f3aaa748673cc903a1932247f0a`  
**KVM:** host SVM on · `scripts/vm-use-kvm.sh` applied · guest `-accel kvm`  
**E2E report:** [`out/VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md`](out/VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md)

| Gate | Result |
|------|--------|
| Password after cold reboot | **PASS** (`demo`/`demo` greeter → desktop) |
| Keyboard (console `fi`) | **PASS** |
| Timezone Helsinki + NTP | **PASS** |
| Locale | **PASS** |
| NM autoconnect | **PASS** |
| Bootloader `etheris.conf` | **PASS** |
| Display save | N/A (not saved) |

**Shipped in this ISO:** auth-check libxcrypt/`ctypes`; hide stock Sway on **live** via `etheris-hide-stock-sway` hook.  
**In tree for next bake:** installer copies `etheris.desktop` + hide sway + ReGreet cache (installed systems were missing Etheris session).  
**Open:** OOBE polkit interactive auth fragility; ReGreet password card needs a submit before it appears.

### Prior — Agent 1 reliability smoke (superseded ISO `107e6538…`)

**ISO:** `out/etheris-2026.11.13-x86_64.iso` (earlier same-day)  
**SHA256:** `107e65381737c8ce05eeed4150fa6df8f8b4ecefb6d04be5946df8ef27c157c2`

**Live results:**
- Boot → ReGreet → **desktop PASS** (Waybar + Sway)
- Flow/reliability bits confirmed in squashfs + guest
- **`nftables` is-active** (RemainAfterExit working)

**Found during smoke → fixed in tree (next bake):**
- `etheris-auth-check` false FAIL on Python 3.13 (`crypt` removed) → libcrypt ctypes (**live-verified 12 OK** after guest-apply)
- Greeter offering stock **Sway** beside **Etheris (Sway)** → hide stock `sway.desktop`

**Report:** [`out/VERIFICATION-RELIABILITY-SMOKE-20261113.md`](out/VERIFICATION-RELIABILITY-SMOKE-20261113.md)  
**Screenshots:** `out/qemu-reliability-smoke-20261113/`

### Auth-check `crypt` false-FAIL — **FIXED + LIVE-VERIFIED** (2026-11-13 ~20:30)

| Item | Status |
|------|--------|
| Bug | Python 3.13+ has no stdlib `crypt` → `etheris-auth-check` reported password mismatch (false FAIL) |
| Fix | `profile/.../etheris-auth-check` verifies via **libxcrypt/`ctypes`** (stdlib `crypt` fallback); ImportError never counts as bad password |
| Live retest | Guest-applied over QEMU `10.0.2.2` HTTP → **`12 OK, 0 FAIL, 0 SKIP`** (password matches) |
| P0 | `./scripts/test-p0-security.sh` still **30 OK** |
| Ship | **In tree** — needs next ISO rebake (reliability ISO `107e6538…` still has old checker) |
| Note | Live `airootfs` overlay hit **100%** during session (cow 2G); free cache before large guest writes |
| Agent 2 QA | `~/etheris-os-agent2` branch `agent2/flow-foundation` → `design/agent-2/qa/POST-REBAKE-REPORT.md` · screenshots `out/qemu-agent2-qa-20261113/` |

### Reliability rebake — **LIVE SMOKE PASS** (2026-11-13 ~19:54–20:20)

| Item | Status |
|------|--------|
| ISO SHA256 | `107e65381737c8ce05eeed4150fa6df8f8b4ecefb6d04be5946df8ef27c157c2` |
| Boot → desktop | **PASS** (TCG) |
| Flow tokens / theme-apply / DND restore / winctl overlay / nftables RemainAfterExit | **In ISO** + content-verified |
| `nftables` is-active | **PASS** |
| Auth-check `crypt` FAIL on Py3.13 | **Fixed + live-verified** (see above) — next bake to ship |
| Hide stock `sway.desktop` | **Fixed in tree** — next bake |
| Evidence | [`out/VERIFICATION-RELIABILITY-SMOKE-20261113.md`](out/VERIFICATION-RELIABILITY-SMOKE-20261113.md) · `out/qemu-reliability-smoke-20261113/` · Agent 2 `out/qemu-agent2-qa-20261113/` |

### Reliability / maturity pass — **baked + live** (follow-ups in tree)

| Item | Status |
|------|--------|
| DND restore after login | `etheris-notifications restore-dnd` + sway/session |
| Window controls / overlay mutex | safer `etheris-winctl`; Super+Shift+A via overlay |
| Overview/notifications prefer Rofi | wofi fallback kept |
| Alt+Tab focus edge case | fixed when focus has no pid |
| First-login guide | auto once on installed systems (live no-op) |
| nftables status honesty | `RemainAfterExit=yes` drop-in |
| Evidence | [`out/VERIFICATION-RELIABILITY-20261113.md`](out/VERIFICATION-RELIABILITY-20261113.md) |

### Etheris Flow M1 — **in latest ISO** + live

| Item | Status |
|------|--------|
| Design system entry | [`docs/FLOW.md`](docs/FLOW.md) · Agent 1 plan [`docs/AGENT1-M1-FLOW-HANDOFF.md`](docs/AGENT1-M1-FLOW-HANDOFF.md) |
| Reliability fixes | `animations=` → GTK + reduced-motion CSS; Settings/CC force re-apply; UI font → Noto Sans (Outfit if installed) |
| Evidence | [`out/VERIFICATION-FLOW-M1.md`](out/VERIFICATION-FLOW-M1.md) · reliability smoke (squashfs + desktop) |

### Live smoke — maturity ISO **PASS** (TCG, ~19:18–19:30)

| Check | Result |
|-------|--------|
| Boot → Etheris/Sway + Waybar + Firefox | **PASS** (~210 s TCG) |
| MOTD / `BUILD_ID=rolling-lag14` / RGB 755 / avahi active | **PASS** |
| greetd + ReGreet + `etheris.desktop` | **PASS** |
| Evidence | [`out/VERIFICATION-MATURITY-SMOKE-20261113.md`](out/VERIFICATION-MATURITY-SMOKE-20261113.md) · `out/qemu-maturity-smoke-20261113/` |

**Follow-ups since maturity smoke:** polkit share path shipped in reliability bake; auth-check privileged probes + **libcrypt ctypes** fix live-verified 20:30 (next bake to ship). P0 **30 OK**.

### Maturity rebake — **baked into ISO** (2026-11-13 ~19:14)

| Item | Status |
|------|--------|
| MOTD (Sway-only; no fake DE picker) | **In ISO** + live-verified |
| `BUILD_ID=rolling-lag14` ↔ channels | **In ISO** + live-verified |
| Avahi unmasked (Warpinator) | **In ISO** + live-verified |
| RGB tools 755 + profiledef | **In ISO** + live-verified |
| On-ISO docs / auth-check greetd (not SDDM) | **In ISO** + live-verified |
| Squashfs spot-check | **PASS** — [`out/VERIFICATION-MATURITY-20261113.md`](out/VERIFICATION-MATURITY-20261113.md) |

### Host / accel

- **SVM disabled in BIOS** → guest is **TCG** (everything feels glacial). Enable AMD SVM, reboot host, then: `~/etheris-os/scripts/vm-use-kvm.sh`
- `build.sh` uses Podman `--network=host` (bridge DNS broken on this host).

### Latest ISO (reliability rebake; same-day)

| Item | Value |
|------|--------|
| File | `out/etheris-2026.11.13-x86_64.iso` (~2.1 GiB) |
| SHA256 | `b85e420473966437b3534e7c253d639e27305bd5725dd2b6cfcd45d393036a63` |
| Libvirt image | hardlinked at `~/.local/share/libvirt/images/etheris-2026.11.13-x86_64.iso` |
| Console log | `out/build-reliability-20261113T174758Z.console.log` |
| Reports | reliability smoke + Agent 2 post-rebake QA · prior maturity SHA `3e5d1fc5…` superseded |

### UX fixes shipped in this ISO

- ReGreet: Cairo via `etheris-greeter`, `skip_selection=true`, Noto Sans, focus CSS, TUI fallback, lighter clock
- All core GTK Etheris apps: `GSK_RENDERER=cairo`
- Settings Sound → `pavucontrol`; CC Animations starts/stops `etheris-motion`; brightness honesty; Transfer missing-tool notifies
- Launcher: **slim** default, `launcher_icons=auto` (off on VMs)

### Idle RAM (morning measure, still valid metric)

| Check | Result |
|-------|--------|
| Idle **no** Firefox | **PASS — session_pss ≈ 124 MiB** |

### Install persistence (priority — 2026-11-13)

Gates in [`docs/INSTALL-PERSISTENCE.md`](docs/INSTALL-PERSISTENCE.md): password, keyboard, timezone, locale, network autoconnect, display layout, bootloader after updates.  
Code: installer keymap + btrfs `rootflags=subvol=@`, NM iwd + timesyncd, scoped polkit, live-only `etheris-auth-setup`, `etheris-keymap-apply`, `etheris-display`, bootctl pacman hook.  
Checklist: [`out/VERIFICATION-INSTALL-PERSISTENCE.md`](out/VERIFICATION-INSTALL-PERSISTENCE.md) — **needs cold-reboot E2E after next ISO bake**.

### Next (ordered)

1. Optional rebake to ship **installer** `etheris.desktop` + hide-sway + ReGreet cache seed
2. Harden OOBE keymap apply (no interactive polkit / faillock trap)
3. ReGreet: show password row without dummy submit; keep website local

### Quick resume commands

```bash
cd ~/etheris-os
cat out/SHA256SUMS
# latest ISO: ebb52857a123dbc9e01539a905e13f3cb2b90f3aaa748673cc903a1932247f0a
./scripts/vm-use-kvm.sh   # already KVM if SVM on
virsh -c qemu:///session start etheris-os
virt-viewer --connect qemu:///session --attach etheris-os &
# installed E2E disk: etheris-persist-e2e.qcow2 · demo / demo
# live: etheris / etheris — prefer session "Etheris (Sway)"
```

---

## Where things live

| Path | Purpose |
|------|---------|
| `~/etheris-os/` | Project root |
| `profile/etheris/` | Archiso profile + airootfs |
| `build.sh` | Podman + mkarchiso (**multilib**; pacman cache in `work/pacman-cache`) |
| `out/etheris-2026.11.13-x86_64.iso` | **Latest ISO** (idle Pss + UX/login/Cairo/launcher) |
| `out/SHA256SUMS` | ISO checksums |
| `out/VERIFICATION-IDLE-RAM.md` | Idle/perf QEMU evidence (2026-11-12) |
| `docs/IMMUTABLE.md` · `docs/INTEGRATION-REPORT.md` · `docs/PERFORMANCE-MANAGER.md` | Updated |
| `design/phase-2/` | Etheris blueprint + previews (not OS) |
| `MASTER-CHECKLIST.md` | Phase status |
| `SESSION-LOG.md` | **This handoff** |
| `website/` | Local-only official site preview |

### VM (libvirt user session)

```text
Connection: qemu:///session
Domain:     etheris-os
State:      running (as of 2026-11-12T17:34 — may be left up; destroy/shutdown OK)
RAM:        3584 MiB (3670016 KiB)
Boot:       cdrom then hd
Disk:       ~/.local/share/libvirt/images/etheris-os.qcow2
Inject:     ~/.local/share/libvirt/images/etheris-inject.img
ISO:        ~/.local/share/libvirt/images/etheris-2026.11.12-x86_64.iso
            (= out/etheris-2026.11.12-x86_64.iso)
Prior E2E:  ~/.local/share/libvirt/images/etheris-e2e-stage1.qcow2  (demo/demo)
WP-S5 live: ~/.local/share/libvirt/images/etheris-wps5-live.qcow2
```

Live login: `etheris` / `etheris`  
Installed E2E login: `demo` / `demo`

**Try on live desktop:**
- Super+D / Super+Space · Rofi Etheris launcher (Wide/Slim)
- Super+A Control Center · Super+N notifications
- Super+W overview · Super+, Settings · Super+Shift+A window menu
- Super+B browser · Super+Return terminal · Super+I AI agent
- Super+Shift+E power menu · `etheris ram` · `etheris ram idle-check`
- `etheris-perf get` · `etheris-immutable status`
- Settings → Shell → Panel position (Top / Bottom dock) · Launcher style
- `etheris-wallpaper` · `etheris-transfer` · `etheris-browsers` · `etheris-defaults` · `etheris-timezone`

---

## What we accomplished — 2026-11-09 evening (branding · gaming · browser · re-bake)

### E1. Trademark-safe rename → **Etheris OS**

Iterative clearance (rejected Ethereal / Eclipse / Galaxy / Elixir / Ether / Flow / Endor / Evo / Entreal / Etherglow / Etherix). Chose **Etheris**.

| Item | Detail |
|------|--------|
| Tree | Project `etheris-os`; airootfs bins/docs/design renamed from ethereal→etherglow→etherix→etheris |
| Live brand | `/etc/issue`, greeter, wallpapers paths, share tree under `/usr/local/share/etheris` |
| Libvirt | Domain/XML/images/NVRAM aligned to `etheris-os` |
| Constraint | Free/OSS + website OK; coined name; no anti-cheat bypass tooling |

### E2. Steam / gaming / anti-cheat + Defaults installs

| Item | Detail |
|------|--------|
| Policy | Legit Steam Play + Valve Proton / EAC / BattlEye **runtimes only** — never bypasses |
| Scripts | `etheris-gaming-setup` (steamplay / runtimes / status); `etheris-steam` (safer CEF, runtimes, xdg-mime) |
| Packages | Extra lib32 deps (`freetype2` / `curl` / `dbus` / `fontconfig`); dropped vanished `lib32-openal` again |
| Defaults fix | GUI pacman elevation: `pkexec` → `sudo -n` → foot; `etheris-defaults-ui` AlertDialog errors; AUR lag=0 |
| Apply pack | `out/gaming-defaults-apply.tgz` (live inject if needed) |
| Docs | `docs/GAMING.md` synced |

### E3. Browser lean RAM + &lt;1 s open (warm path)

| Item | Detail |
|------|--------|
| Goal | No wasteful browser RAM; Super+B under ~1 s after login |
| Reality | True virgin Firefox cold start is multi-second; **warm scratchpad preload** is the supported path |
| Policies | `/etc/firefox/policies/policies.json` — `about:blank` start, 2 content processes, no onboarding/telemetry fluff, capped memory caches |
| Launcher | `etheris-browser` — earlier/reliable preload, race wait, `--status`, `browser_preload=on\|off`, skip if MemAvailable &lt; ~640 MiB |
| Session | Preload ~0.35 s after login; timezone/guide deferred to ~2.5 s / auto-tz ~12 s so preload gets CPU |
| Settings | `browser_preload=on`, `default_browser=firefox` in skel + live user settings |
| Perf doc | `design/phase-2/PERFORMANCE.md` — idle ~500 MiB **before** warm Firefox (~300–450 MiB when preloaded) |
| Apply pack | `out/browser-ram-apply.tgz` · bench helper `out/bench-browser.sh` |
| Existing | `99-etheris-ram.conf` · `99-etheris-snappy.conf` · zram · `MALLOC_ARENA_MAX=2` unchanged |

### E4. ISO re-bake (23:17)

| Item | Result |
|------|--------|
| Disk | Host free space recovered (~119 GiB avail) after earlier ~97% full block |
| Fail #1 | `rm` of root-owned `work/mkarchiso` needed `sudo rm -rf` |
| Fail #2 | `lib32-openal` **target not found** (Arch dropped it) — removed from `packages.x86_64`, `gaming-packages.list`, installer |
| `./build.sh` | **PASS** → `out/etheris-2026.11.09-x86_64.iso` (~2.1 GiB) |
| SHA256 | `b85e420473966437b3534e7c253d639e27305bd5725dd2b6cfcd45d393036a63` |
| Verified in airootfs | lean Firefox policies · `sleep 0.35; etheris-browser --preload` · `browser_preload` in etheris-browser |

---

## What we accomplished — 2026-11-09 earlier (Etheris shell + apps)

### 1. Panel placement — top floating vs bottom dock

| Item | Detail |
|------|--------|
| Setting | Shell → **Panel position**: Top panel (`floating`) / Bottom dock (`dock`) |
| Top | Existing Etheris Waybar: workspaces, title, winctl, status |
| Bottom | Centered island dock: launcher + Files/Term/Set pins + workspaces + clock + status; taller/rounder; no title/winctl chrome |
| Wiring | `etheris-shell-layout`, Settings, Control Center, waybar style template |

### 2. Gaming stack (Steam / Wine / Proton essentials)

Steam was already on the live ISO; today made it default on disk installs too and expanded the legit runtime stack (**no anti-cheat bypasses**).

| Item | Detail |
|------|--------|
| Install default | Steam + gaming packages on disk installs; lean opt-out `ETHERIS_INSTALL_GAMING=0` |
| Added packages | `steam-devices`, `lib32-pipewire`, `lib32-alsa-plugins`, `protontricks`, `umu-launcher` |
| Wine / Proton | `wine`, `wine-mono`, `wine-gecko`, `winetricks`, `zenity`, `cabextract`, `vkd3d` / `lib32-vkd3d`, common `lib32-*` game libs, GStreamer set |
| Sysctl | `vm.max_map_count` raised for Proton/Wine (`99-etheris-gaming.conf`) |
| Groups | Users get `gamemode` group |
| Docs | `docs/GAMING.md` |
| Build note | Dropped `lib32-openal` — Arch no longer ships it; Steam/Wine still build |

### 3. Etheris application launcher (Rofi Kickoff-style)

| Item | Detail |
|------|--------|
| Engine | **Rofi** (not wofi) for main launcher |
| UX | Opens on **Pinned**; tabs: Pinned · Apps · Run · Windows |
| Theme | Etheris glass via `etheris-theme-apply`; prompt branded **Etheris**; Papirus icons |
| Branding | Panel wordmark **Etheris**; wofi prompts capitalized consistently |
| Style option | Settings → Shell → Application launcher: **Wide** (680px, default) / **Slim** (380px); also Control Center toggle |
| Files | `etheris-launcher` · `share/etheris/rofi/{etheris,etheris-slim}.rasi` · `favorites.mode` |

### 4. Etheris Wallpapers (GTK4 switcher + light file manager)

| Item | Detail |
|------|--------|
| App | `etheris-wallpaper` |
| Sources | My Wallpapers · Pictures · Etheris Library · Browse files |
| Formats | JPG/PNG/WebP/GIF/BMP/SVG/TIFF/JXL/AVIF thumbnails (cached, async) |
| Import | Add files, import folder, drag-and-drop |
| Nav | Up / path bar folder browsing |
| Apply | Fixed so wallpaper actually refreshes on select |

### 5. File transfers

| Item | Detail |
|------|--------|
| Hub | **Etheris Transfers** — `etheris-transfer` |
| LAN | Warpinator |
| Bluetooth | Blueman + `bluez-obex` (OBEX on login) |
| Shares | `gvfs-smb`, `gvfs-nfs`, existing MTP |
| Firewall | Warpinator ports + mDNS; Avahi enabled |
| Docs | `docs/TRANSFERS.md` |

### 6. Etheris Files Places + Etheris GTK look

| Item | Detail |
|------|--------|
| Standard dirs | Wired reliable `xdg-user-dirs` creation on login |
| Places | Home, Desktop, Documents, Downloads, Music, Pictures, Videos, Public, Templates |
| Extra Places | **Wallpapers**, **Screenshots** |
| Look | Glass toolbars/path bar, rounded Places, selection pads, CSD chrome matching Atmosphere |
| Defaults | Larger icons/thumbnails, icon view, ~980×620 |

### 7. Custom login (ReGreet)

| Item | Detail |
|------|--------|
| Greeter | Switched tuigreet → **ReGreet** (GTK4) on minimal Sway seat |
| Style | Glass login card, Etheris wallpaper, clock/greeting (`/etc/greetd/regreet.css`) |
| Auth | Still greetd + PAM |
| Fallback | `etheris-greeter-tui` |
| Docs | `docs/LOGIN.md` |

### 8. ISO bake + VM verification

| Item | Result |
|------|--------|
| `./build.sh` | **PASS** → `out/etheris-2026.11.09-x86_64.iso` |
| SHA256 | `b85e420473966437b3534e7c253d639e27305bd5725dd2b6cfcd45d393036a63` |
| VM | CDROM boot of 2026.11.09 ISO; virt-viewer session |
| Evidence | `out/verification-etheris-desktop-vm-login.png` · `out/verification-etheris-desktop-vm-desktop.png` |
| Glass honesty | Translucent Etheris surfaces yes; **true blur no** (`blur=off`) |

### 9. Browser warm-start (Firefox felt ~5s)

| Item | Detail |
|------|--------|
| Cause | Cold Firefox + RAM-starved guest (~2.5 GiB thrashing swap) |
| Fix | `etheris-browser` warm wrapper; session preload ~1s after login; first-run policy strip |
| VM RAM | Raised toward ~3.5 GiB |
| Bind | **Super+B** |
| Result | Warm open ~**230 ms** in live session (vs ~5 s cold) |

### 10. Etheris Browsers (on-demand installs)

Not all browsers baked into ISO (size/RAM). Manager installs on demand:

| Source | Browsers |
|--------|----------|
| Arch repos | Chromium, Vivaldi, LibreWolf, GNOME Web, Falkon, qutebrowser |
| AUR (builds on machine) | Chrome, Edge, Zen, others as cataloged |

| Item | Detail |
|------|--------|
| Apps | `etheris-browsers` / `etheris-browsers-ui` |
| Entry | Settings → Browsers, Control Center, launcher |
| VM note | Forced Cairo when GTK UI crashed on virtio software renderer; CLI fallback kept |

### 11. Etheris Defaults (browser / terminal / AI agent)

| Item | Detail |
|------|--------|
| UI | Polished floating GTK defaults app — rail + accent hero + glass cards |
| Tabs | **Browser** (Super+B) · **Terminal** (Super+Return) · **AI Agent** (Super+I) |
| Agents | ChatGPT / Claude / Gemini / Copilot / Ollama / … via `etheris-agent` |
| Launcher | Pinned as “Etheris Defaults” |
| Also | Settings → Defaults · Control Center |

### 12. First-login timezone — city-precise + travel auto

| Item | Detail |
|------|--------|
| App | `etheris-timezone` — OOBE / first-login city-precise picker |
| Globe | Three.js WebGL globe + city search (`share/etheris/timezone/`) behind WebKit |
| VM reality | WebKit/WebGL unreliable on virtio → Etheris **GTK search UI** with hub cities pinned |
| Travel | `etheris-timezone-auto` — IP/geolocation country change → set timezone + notify (on by default; toggle in picker) |
| Live overlays | `out/timezone-apply.tgz` · `out/tz-polish-apply.tgz` (and related injects) |

### Post-bake live injects

**Latest 23:17 ISO** should include branding + gaming/Defaults + lean browser warm path from airootfs. Older live guests can still use:

- `out/browser-ram-apply.tgz` · `out/gaming-defaults-apply.tgz`
- Older: `out/browser-fast-apply` / `browser-fast.tgz` · `out/browsers-apply.tgz` · `out/defaults-apply.tgz`
- `out/ui-launcher-apply.tgz` · `out/timezone-apply.tgz` · `out/tz-polish-apply.tgz`

---

## What we accomplished earlier (2026-11-08 night → SESSION-LOG v1)

Kept for continuity; details were verified on WP-S5 ISO.

### A. Steam + snappy live (pre–WP-S5)

**Root cause:** archiso overlay `cow_spacesize` = **256 MiB** → Steam needs ≥250 MiB free.

| Fix | Detail |
|-----|--------|
| Live overlay | `kernel_params=('cow_spacesize=2G')` in `profiledef.sh` |
| Safety remount | `etheris-live-ready.service` remounts cowspace to 2G if still &lt;1 GiB |
| Launcher | `etheris-steam` — free-space + DNS checks, CEF `-no-cef-sandbox`, logs under `~/.local/state/etheris/steam.log` |
| Zram | `zram-generator` + config; guest RAM raised for Steam |

**Snappy defaults:** `animations=off`; theme-apply session stamp; PNG wallpapers preferred; deferred OOBE/guide; waybar 15–30 s; `99-etheris-snappy.conf`.

### B. Etheris WP-S5

Settings (`etheris-settings` · Super+,), workspace overview (Super+W), optional widgets (`widgets=off|clock`), decorations honesty doc, shell-layout wiring. Verified on disposable live VM — report `out/VERIFICATION-WP-S5-SETTINGS.md`.

---

## Critical technical notes

- OOBE must **never** call interactive `sudo` (breaks foot TUI). Use `sudo -n` or user-writable paths.
- State dir: installer `chmod 777` / state `chmod 666` so first login can mark `done`.
- Arch **nvidia 590+** dropped Pascal → AUR `nvidia-580xx-*` only.
- `build.sh` enables `[multilib]`; Steam → lsb-release hook for branding.
- **Sway = compositor**; Quickshell (if ever) = shell only. Keep Sway fallback. **No dual panel.**
- Prefer **PNG** wallpapers at runtime (SVG source OK); glycin-svg was ~30 MiB RSS.
- Live Steam needs `cow_spacesize=2G` + preferably ≥3.5–4 GiB guest RAM / zram.
- Cleaning `work/mkarchiso` after rootful/rootless podman may need:  
  `podman run --rm -v ~/etheris-os/work:/work:Z alpine rm -rf /work/mkarchiso`
- Keep ≥20 GiB free on `/home` before `./build.sh` (SquashFS + overlay peak).
- Power menu: transient GTK4; virtio-gpu may log Vulkan noise (harmless). `ETHERIS_POWER_BLUR=0` for solid backdrop.
- Do **not** claim every app has identical window chrome (CSD vs SSD honesty).
- Glass ≠ blur: translucent surfaces ship; true compositor blur does not on stock Sway.
- Anti-cheat: ship Proton/Wine/runtime deps only — **never** bypass tools.
- WebKitGTK on virtio software GL is flaky; keep GTK fallbacks for timezone / heavy WebKit UIs.
- Firefox cold start cannot hit &lt;1 s in this VM; warm-preload + reuse is the practical path.

---

## Suggested next session

**Primary (2026-11-15 handoff):** rebake → attach `etheris-2026.11.15` ISO → live-verify Quick/Session frost + thin bar (see **CONTINUE HERE** at top).

Then, if chrome soaks clean:
1. Boot branding / Defaults / Super+B warm (`etheris-browser --status`).
2. Owner soak ReGreet + launcher + Files Places.
3. **WP-S6** idle RSS/CPU (Waybar/mako/sway only, before browser preload).
4. Optional Quickshell Path B behind `shell=quickshell` (ADR gates).
5. Soak decorations; expand WP-S4 motion only after.

### Quick resume commands

```bash
cd ~/etheris-os
# see top-of-file CONTINUE HERE (2026-11-15) for rebake + chrome verify
df -h .
tail -5 out/SHA256SUMS
virsh -c qemu:///session start etheris-os
virt-viewer --connect qemu:///session --attach etheris-os &
# live: etheris / etheris · Super+A Quick · Super+Shift+E Session
```

---

## Key code touchpoints

| Area | Files |
|------|--------|
| Panel top/dock | `etheris-shell-layout` · waybar config/style · Settings Shell |
| Frosted glass | `share/etheris/lib/etheris_glass.py` · Quick + Session |
| Rofi launcher | `etheris-launcher` · `share/etheris/rofi/*` |
| Wallpapers | `etheris-wallpaper` |
| Transfers | `etheris-transfer` · Warpinator / Blueman / gvfs |
| Files Etheris | GTK templates · PCManFM skel · xdg-user-dirs / bookmarks |
| Login | `/etc/greetd/*` · `regreet.css` · `etheris-greeter-tui` |
| Browser warm / lean | `etheris-browser` · `/etc/firefox/policies/policies.json` · session preload · `browser_preload` |
| Browsers manager | `etheris-browsers` · `etheris-browsers-ui` · `browsers/catalog.json` |
| Defaults | `etheris-defaults` · `etheris-defaults-ui` · `defaults/catalog.json` (pkexec elevation) |
| AI agent | `etheris-agent` |
| Timezone | `etheris-timezone` · `etheris-timezone-auto` · `share/etheris/timezone/` |
| Settings / Quick | `etheris-settings` · `etheris-control-center` |
| Gaming | `packages.x86_64` · `etheris-steam` · `etheris-gaming-setup` · `99-etheris-gaming.conf` |
| Overview / widgets | `etheris-workspace-overview` · `etheris-widgets` · `etheris-widget-clock` |
| Window controls | `etheris-winctl` · Waybar `custom/winctl` |
| Motion (WP-S4) | `etheris-motion` (only if animations=on) |
| Theme apply | `etheris-theme-apply` (session stamp) |
| Tokens / GTK CSD | `share/etheris/design/templates/gtk.css.tmpl` |
| Overlay mutex | `etheris-overlay` |
| Session / power | `etheris-power-menu` · `etheris logout-menu` |
| Live cow | `profiledef.sh` `kernel_params` · `etheris-live-ready.service` |
| Zram | `zram-generator` · `/etc/systemd/zram-generator.conf` |
| Session / OOBE | `etheris-session` · `etheris-oobe` |
| Installer (M5) | `etheris-installer` |

---

## What we accomplished — 2026-11-10 (rename verify · Performance Manager · release prep start)

### Rename Stage C

- Audit: only historical Ethereal/Etherglow/Etherix mentions in `SESSION-LOG.md`
- User-facing tree consistently **Etheris** (os-release, ReGreet, boot menus, ISO name, apps)
- Report: `docs/RENAME-VERIFICATION.md` — **PASS**
- Host leftover libvirt filenames `ethereal-*` noted (outside repo)

### Stage D — Performance Manager + GPU Manager

| Piece | Path |
|-------|------|
| CLI engine | `usr/local/bin/etheris-perf` |
| GPU CLI | `usr/local/bin/etheris-gpu` |
| GTK Performance Manager | `usr/local/bin/etheris-performance` |
| GTK GPU Manager | `usr/local/bin/etheris-gpu-manager` |
| Settings page | Settings → Performance |
| Quick Settings | Control Center → Performance profile |
| Boot apply | `etheris-perf.service` |
| Docs | `docs/PERFORMANCE-MANAGER.md` |
| Live apply pack | `out/perf-gpu-apply.tgz` |

Profiles: `maximum` · `balanced` · `quiet` · `powersave` (safe interfaces only).

Host smoke: `etheris-perf capabilities|monitor` ran on Fedora (intel_pstate). Guest ISO not yet rebaked with these binaries.

### Public release / website

- In progress: static site under `website/` (local only)
- No git remote / visibility / DNS / public deploy without owner approval
