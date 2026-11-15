# Etheris OS — Installation persistence requirements

**Priority:** A lightweight OS is not useful if basic configuration does not survive reboot.  
These are **acceptance gates** for any disk install (interactive or `--auto`).

| Feature | Expected behavior after reboot | Persist via |
|---------|--------------------------------|-------------|
| **User password** | Same password works at greeter | `/etc/shadow` (`chpasswd` at install) — never reset by live auth helpers |
| **Keyboard layout** | Console, greeter, and desktop match install/OOBE choice | `/etc/vconsole.conf` · greeter Sway XKB · `~/.config/sway/config.d/10-keyboard.conf` |
| **Timezone** | Clock/region correct | `/etc/localtime` · `timedatectl` · `systemd-timesyncd` enabled |
| **Locale** | LANG and generated locales correct | `/etc/locale.conf` · `/etc/locale.gen` |
| **Network** | Wired/Wi‑Fi reconnects automatically | NetworkManager + iwd backend · saved system connections |
| **Display configuration** | Resolution/scale/arrangement restored | `~/.config/sway/config.d/50-outputs.conf` via `etheris-display` |
| **Bootloader** | Boots after kernel/systemd updates | systemd-boot entry + `bootctl update` pacman hook; Btrfs uses `rootflags=subvol=@` |

## Verification (installed VM or hardware)

After install + one reboot (and OOBE if shown):

```bash
# Password: greeter login with the password chosen at install
localectl status          # keymap / X11 layout
timedatectl               # timezone + NTP
cat /etc/locale.conf
nmcli -t -f NAME,TYPE,AUTOCONNECT,DEVICE connection show
test -f ~/.config/sway/config.d/50-outputs.conf && cat ~/.config/sway/config.d/50-outputs.conf
bootctl status
cat /boot/loader/entries/etheris.conf   # btrfs must include rootflags=subvol=@
```

Mark PASS only when each row behaves after a **cold reboot**, not merely after apply in the same session.

## Related

- Installer: `usr/local/bin/etheris-installer`
- OOBE: `usr/local/bin/etheris-oobe` · `docs/OOBE.md`
- Keymap helper: `usr/local/bin/etheris-keymap-apply`
- Display save: `usr/local/bin/etheris-display`
- Live-only auth: `etheris-auth-setup` (must **not** run on installed systems)
