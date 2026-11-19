# Verification — Gaming / driver readiness audit (2026-11-19)

**Criteria:** strict (tree seals + honesty on physical GPU)

## Host inventory (Omarchy build machine — NOT Etheris guest)

| Check | Result |
|-------|--------|
| GPU | NVIDIA GP104 GTX 1070 `10de:1b81` |
| Module | `nvidia` 580.178.04 loaded |
| Steam (host) | installed |
| GameMode (host) | **not** installed |
| `vm.max_map_count` (host) | 1048576 |
| Etheris guest GPU row | **BLOCKED** (no DUT / passthrough) |

## Bugs found + fixed in Etheris tree

| Bug | Severity | Fix |
|-----|----------|-----|
| Live user not in `gamemode` group (ISO squashfs) | High | `etheris-ensure-gaming-groups` + `etheris-live-ready.service` |
| Missing NVIDIA DRM modeset modprobe | High | `/etc/modprobe.d/etheris-nvidia.conf` + drivers apply |
| Global `SDL_VIDEODRIVER=x11` in environment.d | High | Removed; Steam-only in `etheris-steam`; scrub on apply |
| No strict gaming gate | Medium | `etheris-gaming-setup doctor` |
| `test-bugs.sh` B3 flaky with eza/`ls -t` | Low | `/bin/ls` + `grep -a` |

## Still not claimable

- Physical Etheris install game launch on Pascal/AMD/Intel
- Suspend/resume on proprietary NVIDIA
- Hybrid PRIME laptops

Gate: `etheris-gaming-setup doctor` after rebake + `docs/HARDWARE-TEST-MATRIX.md` DUT row.
