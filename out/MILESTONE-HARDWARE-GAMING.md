# Milestone — CPU / GPU / Gaming foundation

Date: 2026-11-08  
Version: 0.1.0-alpha (tree changes; **ISO rebuild required**)

## Verdict

**In-tree foundation landed and ISO rebuilt.** Detection, open GPU stack, Steam/multilib gaming packages, Pascal 580xx guidance + pins, CPU microcode/power defaults, and recovery docs are present.

**ISO:** `out/ethereal-2026.11.08-x86_64.iso` (~1.8 GiB)  
**SHA256:** `2a42e2fa7b929ef143bd0776870460a4af7df14598deb7430a0a0132aa466249`

**Not acceptance-complete:** no physical NVIDIA Pascal / AMD RX / hybrid matrix rows yet; QEMU live re-smoke of Steam not run in this milestone.

## Gap analysis (before → after)

| Requirement area | Before | After this milestone |
|------------------|--------|----------------------|
| CPU microcode packages | Present on ISO | Still present; installer now writes early ucode initrd |
| CPU detection / power defaults | None | `ethereal-hw`, `ethereal-cpu-setup`, oneshot service |
| GPU PCI detection | None | TSV DBs + `ethereal-hw` / `ethereal-drivers` |
| NVIDIA Pascal | None | Detect + AUR 580xx guide + IgnorePkg pin + pacman hook warn |
| NVIDIA Turing+ | None | `ethereal-drivers apply` → `nvidia-open` path |
| AMD/Intel Mesa | mesa + vulkan-* | + lib32, media, tools |
| multilib / Steam | Disabled / absent | Enabled; Steam + GameMode + MangoHud + Gamescope |
| Recovery docs | None | `docs/DRIVER-RECOVERY.md` |
| Hardware test matrix | None | Template only |

## Files changed (high level)

- `profile/ethereal/packages.x86_64` — gaming + GPU + CPU helpers
- `profile/ethereal/pacman.conf` + `airootfs/etc/pacman.conf` — `[multilib]`
- `build.sh` — keep multilib after releng pacman.conf copy
- `usr/local/bin/ethereal-hw`, `ethereal-drivers`, `ethereal-cpu-setup`, `ethereal-nvidia-pascal-guard`
- `usr/local/share/ethereal/hardware/*.tsv` — PCI ID databases
- `ethereal` CLI + installer package/microcode/overlay updates
- Docs: `HARDWARE.md`, `GAMING.md`, `DRIVER-RECOVERY.md`, `HARDWARE-TEST-MATRIX.md`

## Packages added

`mesa-utils`, `vulkan-icd-loader`, `vulkan-tools`, `intel-media-driver`, `libva-intel-driver`, `libva-utils`, `lib32-mesa`, `lib32-vulkan-*`, `steam`, `gamemode`, `lib32-gamemode`, `mangohud`, `lib32-mangohud`, `gamescope`, `bluez`, `bluez-utils`, `lm_sensors`, `cpupower`

**Not** added to ISO by default: `nvidia-open` / `nvidia-580xx` (selected on target via `ethereal-drivers`).

## What was tested

- Host smoke: `ethereal-hw` on Fedora host (Intel Iris Xe `8086:9a49`) — classify + OpenGL strings OK
- `ethereal-drivers recommend` on that host — Intel package plan, `NVIDIA_PLAN=none`
- Bash `-n` on new scripts
- Arch container: confirmed Steam + lib32\* + `nvidia-open` package names exist when `[multilib]` enabled

## Untested / blocked

- Full ISO rebuild with new package set (required next)
- Live QEMU boot with Steam present
- Installer end-to-end on disposable qcow2
- Any physical NVIDIA Pascal / Turing / AMD RX / hybrid laptop
- Actual Proton game launch
- DKMS 580xx build (AUR; third-party)

## Risks

1. ISO size & idle RAM pressure if Steam is left running (≤500 MB target assumes Steam closed).
2. Pascal depends on AUR 580xx maintenance — Ethereal pins/guards but cannot vendor it as official Arch.
3. `build.sh` disk headroom (~27 GiB free at milestone time) may be tight for Steam-expanded work tree.
4. Broad NVIDIA/kernel upgrades remain a breakage risk — recovery doc is mandatory reading.

## Rebuild required?

**Done** — `ethereal-2026.11.08-x86_64.iso` includes this milestone.

### Rebuild attempts (same day)

1. Failed: nested quotes in `build.sh` multilib sed (fixed).
2. Failed: `steam` → `lsb-release` conflict with airootfs `/etc/lsb-release` (fixed via pacman PostTransaction hook + remove static file).
3. **Succeeded** after hook fix (~13 min).

## Current ISO still bootable?

Previous `2026.11.07` kept as fallback. New `2026.11.08` produced successfully; live QEMU verification of Steam/hardware tools still pending.
