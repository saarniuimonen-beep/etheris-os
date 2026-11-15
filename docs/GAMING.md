# Etheris OS — Gaming & Steam

## Default stack

**Live ISO** still ships the Steam/Proton stack for try-before-install.

**Disk installs are lean by default** (no Steam). Opt in with `ETHERIS_INSTALL_GAMING=1` during `etheris-installer` / `--auto`.

Package list source of truth: `/usr/local/share/etheris/gaming-packages.list`

- **Steam** + **steam-devices** (controller udev rules)
- **Proton** via Steam Play (Valve builds are downloaded by Steam — not Arch packages)
  - `etheris-gaming-setup` seeds Steam Play → Proton Experimental for Windows titles
  - First `etheris-steam` launch queues Proton Experimental, Hotfix, 9.0 + Steam Linux Runtime
- Official **Proton EasyAntiCheat** + **BattlEye** runtimes (same first-launch queue)
- **Wine** + **wine-mono** + **wine-gecko** + **winetricks** + **zenity** / **cabextract**
- **vkd3d** / **lib32-vkd3d** (D3D12 translation helpers)
- **protontricks**, **umu-launcher** (Proton prefixes + non-Steam Proton)
- Vulkan + Mesa ICDs (Intel/AMD) + **lib32** graphics/audio/net/font libs
- **GameMode**, **MangoHud**, **Gamescope**
- GStreamer base/good/bad + **gst-libav** (launcher / in-game video)
- PipeWire audio, Bluetooth (`bluez`)
- `vm.max_map_count` raised for Proton/Wine (`99-etheris-gaming.conf`)

Launchers: Steam desktop entry + `etheris` menu → Steam (`etheris-steam`).

Helpers: `etheris-gaming-setup` (`status` / `force` / `runtimes` / `steamplay`).

## Anti-cheat (honest)

Proton supports **Easy Anti-Cheat** and **BattlEye** when the **publisher enables Linux/Proton** for that game. Etheris installs OS deps and queues Valve’s official runtimes. It does **not** ship bypasses.  
Check [Are We Anti-Cheat Yet?](https://areweanticheatyet.com/) / ProtonDB per title.

## Proton-GE

Optional **third-party** user install (AUR / upstream). Not an official Arch or Etheris package. Prefer Steam’s Proton + Steam Linux Runtime for EAC/BattlEye titles that support Linux.

## NVIDIA notes

- Pascal → **580xx** proprietary stack (`etheris-drivers pascal-guide`).
- Turing+ → `nvidia-open` matching userspace (`etheris-drivers apply`).
- Nouveau is not the gaming path.

## Other limitations

- QEMU Steam window ≠ physical GPU proof.
- Controllers: `steam-devices` + kernel xpad/hid; Bluetooth via `bluetoothctl`.
- Live ISO uses `cow_spacesize=2G` so Steam can bootstrap.
- Prefer `etheris-steam` (space/DNS checks; log: `~/.local/state/etheris/steam.log`).

## Quick checks

```bash
etheris gaming
etheris-gaming-setup status
wine --version
winetricks list-installed   # after a prefix exists
etheris-hw gpu
vulkaninfo --summary | head
etheris-steam
# launch options:
#   gamemoderun %command%
#   mangohud %command%
# re-queue Proton + anti-cheat tools:
#   etheris-gaming-setup runtimes
```

## Related

- [HARDWARE.md](HARDWARE.md)
- [DRIVER-RECOVERY.md](DRIVER-RECOVERY.md)
