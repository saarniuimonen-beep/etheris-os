# Etheris OS — Hardware test matrix

**Rule:** Never mark physical GPU/CPU rows as tested from a VM virtio/QXL GPU alone.

Fill a row after each real test. Leave blank = untested.

| Date | Machine | CPU | GPU | PCI ID | Kernel | Driver pkg | Module | OpenGL | Vulkan | VA-API | Steam | Game test | S3 resume | Notes |
|------|---------|-----|-----|--------|--------|------------|--------|--------|--------|--------|-------|-----------|-----------|-------|
| 2026-11-15 | QEMU `qemu:///session` | host | virtio-vga | — | guest Arch | mesa | virtio_gpu | OK (live) | N/A claim | N/A | not claimed | — | untested | Live smoke + greeter; **not** physical GPU proof |
| 2026-11-13 | QEMU persist E2E | host | virtio | — | guest | mesa | virtio_gpu | OK | — | — | — | — | — | Install persistence PASS (see out/VERIFICATION-INSTALL-PERSISTENCE*) |
| 2026-11-15 | **Host inventory** (Omarchy build machine) | — | NVIDIA GP104 GTX 1070 | `10de:1b81` | host kernel | (host stack) | nvidia/nouveau TBD | host-only | host-only | — | — | — | — | **Not an Etheris guest test** — Pascal present on build host; Etheris gaming on this GPU still needs a real install/passthrough row |
| 2026-11-15 | *(physical Etheris)* | — | NVIDIA Pascal | `10de:1b81` candidate | — | 580xx | nvidia | — | — | — | — | — | — | **BLOCKED** — no Etheris-on-DUT run this session (host inventory ≠ guest proof) |
| 2026-11-15 | *(physical Etheris)* | — | NVIDIA Turing+ | — | — | nvidia-open | nvidia | — | — | — | — | — | — | **BLOCKED** — no DUT |
| 2026-11-15 | *(physical Etheris)* | — | AMD RX 400+ | — | — | mesa | amdgpu | — | — | — | — | — | — | **BLOCKED** — no DUT |
| 2026-11-15 | *(physical Etheris)* | — | Intel HD/Iris/UHD/Xe/Arc | — | — | mesa | i915/xe | — | — | — | — | — | — | **BLOCKED** — no DUT |

**Alpha closure:** QEMU + honesty rows complete. Physical certification remains a **Beta/1.0** hard gate — do not advertise GPU/gaming on real silicon until a DUT row is filled.

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
