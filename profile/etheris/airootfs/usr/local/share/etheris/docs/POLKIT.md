# Etheris OS — Polkit authorization

**Priority:** Wheel members must administer the desktop without a blanket root grant.

## Policy summary

| Surface | Mechanism |
|---------|-----------|
| Terminal (`sudo`) on **installed** systems | Password required — `%wheel ALL=(ALL:ALL) ALL` in `/etc/sudoers.d/wheel` |
| Terminal (`sudo`) on **live ISO** | NOPASSWD — `/etc/sudoers.d/etheris` (**live only**; never copied to disk installs) |
| GUI / D-Bus admin | `/etc/polkit-1/rules.d/49-etheris-wheel.rules` (from `usr/local/share/etheris/polkit/`) |

The polkit rule **never** returns `YES` for every action. Unlisted actions use upstream defaults (usually `AUTH_ADMIN`).

## Permitted polkit actions

### A. NetworkManager (`YES` for active wheel)

- `org.freedesktop.NetworkManager.network-control`
- `org.freedesktop.NetworkManager.enable-disable-network`
- `org.freedesktop.NetworkManager.enable-disable-wifi`
- `org.freedesktop.NetworkManager.enable-disable-wwan`
- `org.freedesktop.NetworkManager.enable-disable-bluetooth`
- `org.freedesktop.NetworkManager.wifi.scan`
- `org.freedesktop.NetworkManager.settings.modify.own`
- `org.freedesktop.NetworkManager.settings.modify.system`
- `org.blueman.*` (pair / power without password for wheel)

### B. Timedate (`YES` for active wheel)

- `org.freedesktop.timedate1.set-timezone`
- `org.freedesktop.timedate1.set-ntp`
- **Not granted:** `set-time` (requires authentication)

### C. Locale / keymap (`YES` for active wheel)

- `org.freedesktop.locale1.set-locale`
- `org.freedesktop.locale1.set-keymap`
- `org.freedesktop.locale1.set-x11-keymap`

### D. Hostname (`YES` for active wheel)

- `org.freedesktop.hostname1.set-hostname`
- `org.freedesktop.hostname1.set-static-hostname`
- `org.freedesktop.hostname1.set-pretty-hostname`

### E. First-boot helpers (`YES` for active wheel)

No interactive password — avoids OOBE faillock traps when applying keyboard / writing OOBE state:

| Program | Used by |
|---------|---------|
| `/usr/local/bin/etheris-keymap-apply` | OOBE / Settings keyboard persistence (vconsole + greeter + localectl) |
| `/usr/local/bin/etheris-oobe-helper` | First-boot state transitions when directory is not wheel-writable |

### F. Other helpers / pacman (`AUTH_ADMIN_KEEP`)

Requires administrator authentication (password), then keeps authorization briefly:

| Program | Used by |
|---------|---------|
| `/usr/local/bin/etheris-perf` | Performance manager apply |
| `/usr/local/bin/etheris-immutable` | Immutable mode helpers |
| `/usr/bin/pacman` | Defaults / package installs from GUI |

Any other `pkexec` program is **not** specially allowed.

## Explicitly not granted

- Blanket `Result.YES` for all polkit actions
- Arbitrary `pkexec` of shell/scripts outside the allow-list
- UDisks destructive ops, libvirt, systemd unit control beyond package defaults
- Live NOPASSWD sudo on installed systems

## Files

- Source of truth: `profile/.../usr/local/share/etheris/polkit/49-etheris-wheel.rules`
- Live image: `etc/polkit-1/rules.d/49-etheris-wheel.rules` (kept in sync)
- Installer copies the share rule onto the target root
