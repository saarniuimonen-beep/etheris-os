# UX fix verification — 2026-11-13

**ISO:** `out/etheris-2026.11.13-x86_64.iso`  
**SHA256:** `2ef781456e3b15dd4420edb33558aa00020c009e751ac458f4f978723458cbfd`  
**VM:** `qemu:///session` · `etheris-os` · TCG (BIOS SVM still disabled)  
**Apply pack:** `out/ux-fix-apply.tgz` · inject disk `out/ux-fix-inject.img`  
**KVM helper:** `scripts/vm-use-kvm.sh` (fails until BIOS SVM enabled)

## Squashfs checks (PASS)

| Item | Result |
|------|--------|
| `etheris-greeter` wrapper + Cairo env | Present / executable |
| `skip_selection = true`, Noto Sans, clock 30s | Present in `regreet.toml` |
| Greeter seat runs `etheris-greeter` | Present in `sway-config` |
| `GSK_RENDERER=cairo` on Settings/Wallpaper/Transfer/Perf/GPU/Power/Clock | Present |
| Settings Sound → `pavucontrol` | Present (`_open_sound`) |
| CC Animations starts/stops `etheris-motion` | Present |
| CC Brightness notifies when no backlight | Present |
| Launcher slim default + `launcher_icons=auto` (off on VM) | Present |

## Live QEMU (TCG)

| Check | Result |
|-------|--------|
| ReGreet shows Password + Login; password focused | PASS (`out/qemu-live-20261113-ux/boot-9.png`) |
| Desktop session after login | PASS (`boot-12.png` / `boot-15.png`) |
| Accel | TCG — still slow until BIOS SVM |

## Notes

- Guest remains **TCG-slow** until host BIOS enables AMD SVM; then run `~/etheris-os/scripts/vm-use-kvm.sh`.
- This ReGreet build still draws a User row with `skip_selection=true`, but focus lands on Password (goal met).
