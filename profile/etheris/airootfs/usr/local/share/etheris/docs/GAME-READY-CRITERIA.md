# Etheris OS — Game-ready / drivers criteria (extremely strict)

**Rule:** Claim **game-ready PASS** / **rock-solid game-ready** only when every **Must** below is green with evidence.  
**Related:** [`GAMING.md`](GAMING.md) · [`HARDWARE.md`](HARDWARE.md) · [`HARDWARE-TEST-MATRIX.md`](HARDWARE-TEST-MATRIX.md) · [`BUG-CRITERIA.md`](BUG-CRITERIA.md)  
**Runner:** `scripts/test-game-ready.sh`

---

## Verdict

| Verdict | Meaning |
|---------|---------|
| **ROCK-SOLID PASS** | All Must G0–G2 green **and** live G3 green on ship ISO **without guest-apply** |
| **PASS** | All Must G0–G2 green (G3 optional if evidence pending) |
| **FAIL** | Any G0–G2 red |

**Never** claim physical GPU / real-title gaming certification from virtio/QEMU alone ([`HARDWARE-TEST-MATRIX.md`](HARDWARE-TEST-MATRIX.md)).

Do **not** weaken a Must to get green.

---

## Must G0 — Gate stack

| ID | Criterion |
|----|-----------|
| G0.1 | `check-profile.sh` PASSED |
| G0.2 | `test-p0-security.sh` 0 FAIL (≥44 OK) |
| G0.3 | `test-bugs.sh` host B0–B2 PASSED (when ISO present) |
| G0.4 | No anti-cheat **bypass** strings/tools under airootfs |

---

## Must G1 — Tree seals (every PR)

| ID | Bug sealed / requirement | Prove |
|----|--------------------------|-------|
| G1.1 | Live Steam needs cow space | `profiledef` `cow_spacesize=2G` + `etheris-live-ready` remount if &lt;1 GiB |
| G1.2 | Proton map count | `vm.max_map_count` ≥ 1048576 in `99-etheris-gaming.conf` |
| G1.3 | Multilib for Steam/lib32 | `build.sh` enables `[multilib]` |
| G1.4 | Live ISO ships gaming stack | `packages.x86_64` includes steam, steam-devices, gamemode(+lib32), mangohud(+lib32), gamescope, wine(+mono/gecko), winetricks, vkd3d(+lib32), protontricks, umu-launcher, lib32-mesa, vulkan ICDs |
| G1.5 | Disk installs lean by default | Installer `ETHERIS_INSTALL_GAMING` defaults **0**; reads `gaming-packages.list` when =1 |
| G1.6 | Launch path | `etheris-steam` + `/usr/local/share/applications/steam.desktop` → `etheris-steam`; template `/usr/local/share/etheris/desktop/steam.desktop`; pacman hook + `etheris-ensure-gaming-groups` rewrite package `/usr/share` copy; **no** airootfs `/usr/share/.../steam.desktop` (duplicate basename) |
| G1.7 | Setup helpers | `etheris-gaming-setup`, `etheris-hw`, `etheris-drivers`, Pascal guard present |
| G1.8 | Pascal never nudged to nvidia-open | drivers plan: pascal → `pascal-legacy-aur`; refuse open when 580xx pin |
| G1.9 | HW honesty | `etheris-hw` header/docs: no invented values; PCI TSVs present |
| G1.10 | Hub gaming honesty | `etheris gaming` reports Steam **present/missing** from `command -v steam` (no always “pre-installed”) |
| G1.11 | Package lists coherent | `groups/gaming.list` ≡ `gaming-packages.list` |
| G1.12 | Docs | `GAMING.md` + `HARDWARE.md` + `DRIVER-RECOVERY.md` + this criteria |
| G1.13 | No vanished Arch pkgs | `packages.x86_64` / gaming lists must not list `lib32-openal` (dropped upstream) |
| G1.14 | Live GameMode group | `etheris-ensure-gaming-groups` + `etheris-live-ready.service` ExecStart |
| G1.15 | NVIDIA Wayland modeset | `/etc/modprobe.d/etheris-nvidia.conf` has `nvidia_drm modeset=1` |
| G1.16 | No global SDL X11 poison | `etheris-gaming-setup` `write_env` must **not** set `SDL_VIDEODRIVER=x11`; `etheris-steam` may set it locally |
| G1.17 | Gaming doctor | `etheris-gaming-setup doctor` exists and checks steam/gamemode/map/xwayland/vulkan/SDL |
| G1.18 | Xwayland on live ISO | `xorg-xwayland` in `packages.x86_64` |
| G1.19 | Soft-install gaming path | `etheris-packages` gaming install enables multilib + joins `gamemode` group |
| G1.20 | Skel + install overlays | skel `environment.d` (no global SDL X11) + MangoHud.conf; pacman hook restores `steam.desktop`; installer copies gaming sysctl + nvidia modprobe |

---

## Must G2 — ISO artifact (when ISO present)

| ID | Criterion |
|----|-----------|
| G2.1 | Squashfs has `etheris-steam`, `etheris-hw`, `etheris-drivers`, `etheris-gaming-setup` |
| G2.2 | Squashfs has `steam` binary (or steam launcher path), `99-etheris-gaming.conf`, `gaming-packages.list` |
| G2.3 | Squashfs `steam.desktop` under `/usr/local/share/applications` uses `etheris-steam` |
| G2.4 | Squashfs `etheris gaming` hub detects Steam present/missing (not always “pre-installed”) |
| G2.5 | Squashfs has `etheris-nvidia.conf` + `etheris-ensure-gaming-groups` + live-ready ExecStart |

---

## Must G3 — Live battery (KVM — every game-ready bake)

| ID | Criterion | Pass rule |
|----|-----------|-----------|
| G3.1 | `etheris-hw` / `etheris-drivers status` | Exit 0; no crash; virtio reported honestly |
| G3.2 | `etheris-gaming-setup status` | Exit 0; prints max_map_count / steam yes\|no |
| G3.3 | `wine --version` | Present on live ISO |
| G3.4 | Tools on PATH | `gamemoderun`, `mangohud`, `gamescope` (or package provide) |
| G3.5 | Live cow / free space | cow ≥1 GiB **or** home free ≥400 MiB (Steam guard threshold) |
| G3.6 | `sysctl vm.max_map_count` | ≥ 1048576 |
| G3.7 | `steam` binary present on live | `command -v steam` |
| G3.8 | No guest-apply | Verification statement |
| G3.9 | Honesty | Evidence must **not** claim physical GPU/Steam game PASS |

---

## Explicitly out of scope for ROCK-SOLID game-ready (Alpha)

- Physical NVIDIA/AMD/Intel DUT rows  
- Real Proton title launch / anti-cheat online match  
- Steam account login  
- Secure Boot + proprietary NVIDIA

Those require filled [`HARDWARE-TEST-MATRIX.md`](HARDWARE-TEST-MATRIX.md) DUT rows.
