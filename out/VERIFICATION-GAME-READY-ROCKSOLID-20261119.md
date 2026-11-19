# Game-ready / drivers — ROCK-SOLID PASS (2026-11-19)

**Criteria:** [`docs/GAME-READY-CRITERIA.md`](../docs/GAME-READY-CRITERIA.md)  
**ISO:** `out/etheris-2026.11.19-x86_64.iso`  
**SHA256:** `10ea77d5b2c183341b85635a9f10693bd102f02b620cf809170e08c394482265`  
**Guest-apply:** none

## Verdict

**ROCK-SOLID PASS** for stack / drivers honesty / live ISO gaming readiness on KVM.

**Not claimed:** physical GPU acceleration, real Proton title launch, anti-cheat online match, Secure Boot + proprietary NVIDIA. Fill [`docs/HARDWARE-TEST-MATRIX.md`](../docs/HARDWARE-TEST-MATRIX.md) DUT rows for those.

## Host gates

| Gate | Result |
|------|--------|
| `scripts/test-game-ready.sh` | **32 OK, 0 FAIL** → `out/game-ready-20261119T182422Z` |
| Nested `test-bugs.sh` (G0.3) | PASSED |
| G0–G2 Musts | all green |

## Live G3 (`out/qemu-game-ready-20261119T182226Z`)

| Check | Evidence |
|-------|----------|
| G3.1 hw/drivers | Virtio GPU honest; OpenGL llvmpipe; Vulkan no ICD; `DRV_RC=0` (`04-drivers.png`) |
| G3.2 gaming-setup | `max_map_count=2147483642`, `steam=yes`, `gamemode_group=yes`, `GS_RC=0` (`05-gaming-setup.png`) |
| G3.3–G3.4/G3.7 | `wine-11.22`; `gamemoderun` / `mangohud` / `gamescope` / `steam` on PATH (`06-tools.png`) |
| G3.5–G3.6 | cow **2 GiB** (`2147483648`); `vm.max_map_count=2147483642` (`07-space-sysctl.png`) |
| G3.8–G3.9 | No guest-apply; no physical/title overclaim |

## Fixes landed this pass

- Dropped vanished Arch package `lib32-openal` (broke ISO bake)
- Hub `etheris gaming` reports Steam present/missing (no always “pre-installed”)
- Removed airootfs duplicate `steam.desktop` basename (kept `/usr/local` → `etheris-steam`)
- Formal criteria + `scripts/test-game-ready.sh` / `test-game-ready-live.sh`

## Reproduce

```bash
./scripts/test-game-ready.sh out/etheris-2026.11.19-x86_64.iso
./scripts/test-game-ready-live.sh out/etheris-2026.11.19-x86_64.iso
ETHERIS_GAME_READY_EVIDENCE=out/qemu-game-ready-… ./scripts/test-game-ready.sh out/etheris-2026.11.19-x86_64.iso
```
