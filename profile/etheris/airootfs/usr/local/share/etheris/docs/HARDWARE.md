# Etheris OS — CPU & GPU hardware

Status: **foundation implemented in tree** (detection + open stack + Steam).  
Physical NVIDIA/AMD/Intel gaming certification: **not claimed** until matrix rows are filled from real hardware.

## Goals

- Broad **x86_64** Intel/AMD CPU support (Arch baseline — no `-march=native`, no forced AVX2).
- Automatic detection of GPUs by **PCI ID**, not marketing names alone.
- Open Mesa stack for AMD/Intel; NVIDIA driver branch selected by architecture.
- **Pascal mandatory path** → NVIDIA **580xx** legacy (AUR today — third-party).
- GT 1030 is recognized as Pascal when ID `1d01` — **not** a minimum spec bar.

## Tools

| Command | Purpose |
|---------|---------|
| `etheris-hw` / `etheris hardware` | CPU + GPU + API report |
| `etheris-drivers status\|recommend\|apply` | Driver plan / official package apply |
| `etheris-drivers pascal-guide` | 580xx AUR steps + warnings |
| `etheris-drivers pin-pascal` | IgnorePkg guard vs nvidia-open |
| `etheris-cpu-setup apply` | Balanced cpufreq defaults + microcode note |

PCI databases: `/usr/local/share/etheris/hardware/*.tsv`

## CPU

- Packages: `intel-ucode`, `amd-ucode` (ISO + installer).
- Installer writes early `initrd` lines for both ucode images when present.
- Defaults: **schedutil** when available; boost left enabled; no forced performance mode.
- Virtualization (VT-x / AMD-V) detected and reported; **not** required for desktop use.

## GPU driver policy

| Hardware | Path |
|----------|------|
| AMD RX 400+ / supported APUs | `amdgpu` + Mesa + `vulkan-radeon` + lib32 |
| Intel HD 4000+ / Iris / UHD / Xe / Arc | `i915`/`xe` + Mesa + `vulkan-intel` + media drivers |
| NVIDIA Turing+ | Official `nvidia-open` + utils + lib32 (via `etheris-drivers apply`) |
| NVIDIA Pascal / Volta (/ Maxwell best-effort) | AUR `nvidia-580xx-*` — **never** `nvidia-open` |
| Kepler and older | Best-effort / unsupported for gaming claims |

Proprietary NVIDIA on Wayland also needs DRM modeset (`/etc/modprobe.d/etheris-nvidia.conf`), then `mkinitcpio -P` + reboot. Without `nvidia_drm.modeset=1`, Sway/Gamescope/Steam are not game-ready.

Live ISO ships the **open** stack (Mesa/nouveau as kernel chooses). Proprietary NVIDIA is installed on the target system when appropriate — not forced onto every live boot (VM/QEMU friendliness).

## Risks / limitations

1. **Pascal 580xx is AUR-only** after Arch moved main packages to 590/open. Etheris guides + pins; does not vendor unsigned blobs into the ISO.
2. Steam + multilib **increase ISO size** and can raise RAM if Steam is left open (≤500 MB idle assumes Steam closed).
3. Hybrid graphics / PRIME / suspend: implement detection now; **physical validation pending**.
4. `build.sh` must keep `[multilib]` enabled (patched after copying archiso releng `pacman.conf`).

## Related

- [GAMING.md](GAMING.md)
- [DRIVER-RECOVERY.md](DRIVER-RECOVERY.md)
- [HARDWARE-TEST-MATRIX.md](HARDWARE-TEST-MATRIX.md)
