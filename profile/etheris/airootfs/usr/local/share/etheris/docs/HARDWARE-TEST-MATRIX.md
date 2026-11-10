# Etheris OS — Hardware test matrix

**Rule:** Never mark physical GPU/CPU rows as tested from a VM virtio/QXL GPU alone.

Fill a row after each real test. Leave blank = untested.

| Date | Machine | CPU | GPU | PCI ID | Kernel | Driver pkg | Module | OpenGL | Vulkan | VA-API | Steam | Game test | S3 resume | Notes |
|------|---------|-----|-----|--------|--------|------------|--------|--------|--------|--------|-------|-----------|-----------|-------|
| | QEMU session | host passthrough N/A | virtio | — | | mesa | virtio-gpu | | | | | — | | Live desktop only |
| | | | NVIDIA Pascal | | | 580xx | nvidia | | | | | | | |
| | | | NVIDIA Turing+ | | | nvidia-open | nvidia | | | | | | | |
| | | | AMD RX 400+ | | | mesa | amdgpu | | | | | | | |
| | | | Intel HD/Iris/UHD/Xe/Arc | | | mesa | i915/xe | | | | | | | |

## Validation checklist (per machine)

- [ ] Cold boot + graphical login
- [ ] `etheris-hw` matches `lspci -nn -d ::03xx`
- [ ] Microcode package present; early initrd listed for installed systems
- [ ] Frequency scaling governor sensible (`schedutil` or vendor pstate)
- [ ] Temperature readable or honestly `unavailable`
- [ ] Correct driver module loaded
- [ ] Vulkan/OpenGL status accurate (no false advertising)
- [ ] Steam starts (account login optional)
- [ ] At least one real game if claiming gaming on that GPU
- [ ] Suspend/resume
- [ ] Post-`pacman -Syu` still boots (especially NVIDIA)

## Current milestone status

See `out/MILESTONE-HARDWARE-GAMING.md`.
