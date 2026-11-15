# Install persistence — cold-reboot E2E (2026-11-13)

**Host:** Omarchy · `qemu:///session` · **KVM** (`-accel kvm`, host-passthrough)  
**ISO:** `out/etheris-2026.11.13-x86_64.iso`  
**SHA256:** `ebb52857a123dbc9e01539a905e13f3cb2b90f3aaa748673cc903a1932247f0a`  
**Disk:** `~/.local/share/libvirt/images/etheris-persist-e2e.qcow2` (30 G)  
**Evidence:** `out/qemu-persist-e2e-20261113/` · `final-persist-results.txt`

## Bake notes

| Item | Result |
|------|--------|
| Auth-check libcrypt/`ctypes` | **In ISO** (verified in build airootfs) |
| Hide stock `sway.desktop` | **In live ISO** via pacman hook `etheris-hide-stock-sway` |
| First bake attempt | **FAIL** — preseeded `sway.desktop` conflicted with `sway` package → fixed with hook |
| KVM | **PASS** — `/dev/kvm` present; domain `type=kvm` |

## Install

```text
ETHERIS_INSTALL_GAMING=0 sudo etheris-installer --auto \
  --disk /dev/vda --confirm YES \
  --user demo --password demo \
  --timezone Europe/Helsinki --keymap fi --fs ext4 --no-reboot
```

**Result:** `Installation finished SUCCESSFULLY` · `INSTALL_OK` (~KVM, minutes not hours)

## Cold-reboot gates ([docs/INSTALL-PERSISTENCE.md](../docs/INSTALL-PERSISTENCE.md))

| Feature | After cold reboot | Verdict |
|---------|-------------------|---------|
| **User password** | Greeter login `demo`/`demo` → desktop + Getting Started | **PASS** |
| **Keyboard** | `VC Keymap: fi` · `/etc/vconsole.conf` KEYMAP=fi · greeter sway-config had fi from install | **PASS** (console). User `10-keyboard.conf` became `us` after partial OOBE apply attempt — see notes |
| **Timezone** | `Europe/Helsinki` · NTP active · local EET | **PASS** |
| **Locale** | `LANG=en_US.UTF-8` | **PASS** |
| **Network** | `Wired connection 1` AUTOCONNECT=yes on `enp1s0` | **PASS** |
| **Display** | No `50-outputs.conf` (never saved) | **N/A** (optional until `etheris-display save`) |
| **Bootloader** | `systemd-boot` · `Current Entry: etheris.conf` · boots HD | **PASS** |

Also: `etheris-auth-setup.service` **masked**; demo password hash verifies via libxcrypt.

## Bugs found / fixes in tree

1. **Installer omitted `etheris.desktop`** — installed greeter only offered stock Sway.  
   **Fixed in tree:** installer now copies `etheris.desktop`, runs `etheris-hide-stock-sway`, copies hide hook, seeds ReGreet cache. **Needs next ISO bake** to ship.
2. **ReGreet password row** — not shown until a dummy submit (`type` + Enter) transitions to password card (live + installed). Usable, but skip_selection UX still weak.
3. **OOBE polkit** — `etheris-keymap-apply` prompted interactive auth; one attempt failed (faillock / mistype). OOBE marked done on disk to continue E2E. Follow-up: prefer `etheris-oobe-helper` / non-interactive path.

## Guest verify excerpt

See `out/qemu-persist-e2e-20261113/final-persist-results.txt` (full `e2e-persist-verify.txt` from guest).
