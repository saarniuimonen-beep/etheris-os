# Etheris OS — Graphics driver recovery

Use a disposable test install before risky upgrades. Do not disable pacman signature checks.

## Symptoms

- Black screen / greetd loop after `pacman -Syu`
- `nvidia` module missing; `nouveau` unexpectedly loaded on a proprietary setup
- Steam/Vulkan broken after driver change
- Pascal system “upgraded” to `nvidia-open` (unsupported)

## Safe recovery (generic)

1. Boot an older kernel from the bootloader if available, **or** boot the Etheris live ISO.
2. Chroot the installed system (or use a TTY if the shell is reachable).
3. Inspect:
   ```bash
   etheris-hw gpu
   pacman -Q | grep -E 'nvidia|mesa|vulkan'
   lsmod | grep -E 'nvidia|nouveau|amdgpu|i915|xe'
   ```
4. Restore a coherent stack (examples below), regenerate initramfs, reboot.

```bash
sudo mkinitcpio -P
sudo bootctl update   # if using systemd-boot
```

## Pascal: after a bad nvidia-open install

```bash
sudo pacman -Rns nvidia nvidia-open nvidia-dkms nvidia-utils lib32-nvidia-utils || true
sudo etheris-drivers pin-pascal
# Rebuild AUR 580xx (review PKGBUILDs first)
# nvidia-580xx-utils → lib32-nvidia-580xx-utils → nvidia-580xx-dkms
sudo mkinitcpio -P
sudo reboot
```

If 580xx will not build for the new kernel: boot live ISO → chroot → install `linux-lts` + headers **or** hold the last working kernel until a fixed 580xx is available. **Do not** pretend `nvidia-open` fixes Pascal.

## Turing+: broken open module

```bash
sudo pacman -Syu nvidia-open nvidia-utils lib32-nvidia-utils
sudo mkinitcpio -P
sudo reboot
```

## AMD / Intel

Reinstall the open stack:

```bash
sudo pacman -Syu mesa vulkan-radeon vulkan-intel lib32-mesa lib32-vulkan-radeon lib32-vulkan-intel
```

## Still stuck

Boot live ISO → backup `/home` → reinstall to a disposable disk image in QEMU first when testing recovery procedures. Physical disk installs need an explicit user decision.
