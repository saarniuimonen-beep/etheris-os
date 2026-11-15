# Verification — Bug criteria rock-solid (2026-11-15)

**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `2783b15843106eb920e80fcb66fb7b725c9065439eef90e0114021a7c337326c`  
**Domain:** `etheris-os` @ `qemu:///session` (KVM) · **no guest-apply**  
**Criteria:** [`docs/BUG-CRITERIA.md`](../docs/BUG-CRITERIA.md)  
**Host runner:** `scripts/test-bugs.sh`  
**Live:** `scripts/test-bugs-live.sh` · evidence `out/qemu-bugs-20261115T201952Z/`

---

## Host / ISO (B0–B2)

| Gate | Result |
|------|--------|
| B0.1–B0.5 gate stack | **PASS** |
| B1.1–B1.21 regression seals | **PASS** (29 OK host run before bake; post-bake includes B1.21) |
| B2.1 validate-iso | **PASS** |
| B2.2 squashfs seals | **PASS** |

## Live B3

| ID | Result | Evidence |
|----|--------|----------|
| B3.1 Password-first greeter | **PASS** | `01-greeter.png` — Password field + auto Etheris (Sway) |
| B3.2 Desktop | **PASS** | login → Sway/Waybar |
| B3.3 `etheris-auth-check` | **PASS — 12 OK, 0 FAIL** | `13-auth2.png` |
| B3.4 `etheris doctor` | **PASS — 0 FAIL, 2 WARN** | `11-doctor-clean.png` · `doctor: PASSED` |
| B3.5 `etheris-perf` | **PASS active** | `05-probe.png` |
| B3.6 soak ×10 Super+A / Super+D | **PASS** | `soak-01…10-*.png` |
| B3.7 `menu-hover` | **PASS** | `pgrep -af` → python3 …/etheris-menu-hover |
| B3.8 product failed units | **PASS** | doctor ignores benign `systemd-loop@*sr0*` |
| B3.9 no guest-apply | **PASS** | claim on bake only |

## Bug found → fixed this pass

| Bug | Seal |
|-----|------|
| Menu sheet clipped off right edge (hardcoded `move position 890`) | **B1.21** — `_sway_float_corner` uses focused output `rect`; verified Menu fully on-screen (`soak-08-menu.png`) |

## Verdict

**ROCK-SOLID PASS** for bug criteria on bake `2783b158…`: all known-regression seals green, live auth/doctor/perf/hover/soak green, Menu clip fixed and shipped, **no guest-apply**.
