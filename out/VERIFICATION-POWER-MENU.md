# Verification — Etheris power menu + ISO bake

**Date:** 2026-11-08  
**Host:** Fedora · VM `ethereal-os` (`qemu:///session`)  
**ISO:** `out/ethereal-2026.11.08-x86_64.iso`  
**SHA256:** `df526513c3204f58bad302d6c6c83f887387aee399dbd7aa4d2b3e0ec24887a2`

## What was verified

| Check | Result |
|-------|--------|
| `ethereal-power-menu` in tree + `profiledef.sh` mode 755 | Pass |
| Packages: `gtk4`, `python-gobject`, `imagemagick` | Pass |
| Inject path + installed VM: menu UI (5 big buttons) | Pass (`verification-power-menu/05`, `10`) |
| Shortcut `Super+Shift+E` → `ethereal logout-menu` → GTK menu | Pass |
| Buttons: LOCK · SLEEP · LOG OUT · REBOOT · SHUTDOWN | Present |
| Esc cancels | Pass |
| ISO squashfs contains `ethereal-power-menu` + updated `ethereal` | Pass (unsquashfs extract) |
| ISO copied to libvirt images path | Pass |

## Screenshots

See `out/verification-power-menu/`.

## Notes / caveats

- **Blur:** one-shot `grim` + ImageMagick frosted backdrop (not permanent compositor blur). Panel setting `blur=off` stays; force solid with `ETHEREAL_POWER_BLUR=0`.
- **VM GPU noise:** launching from a foot terminal may log radv/Vulkan init failures on virtio-gpu; menu still paints via fallback. Not a host/physical issue.
- **GTK4:** deprecation warnings for `StyleContext` APIs (cosmetic).
- **Idle RAM:** menu process is transient; should not affect ≤500 MiB idle target when closed.
- Build terminal metadata stalled during SquashFS; ISO mtime + baked binaries confirm success. `SHA256SUMS` regenerated after bake.
