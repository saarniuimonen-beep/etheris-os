# Install persistence — verification checklist

**Spec:** [`docs/INSTALL-PERSISTENCE.md`](../docs/INSTALL-PERSISTENCE.md)  
**Status:** Cold-reboot E2E **PASS** on KVM (2026-11-13 night) — see [`VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md`](VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md). Installer session-desktop fix in tree for next bake.

| Feature | Expected | How to verify after reboot |
|---------|----------|----------------------------|
| User password | Login with install password | Greeter login; `etheris-auth-setup` must **not** reset it |
| Keyboard | Console + greeter + desktop match | `localectl status`; type at greeter; desktop keys |
| Timezone | Correct zone + NTP | `timedatectl` |
| Locale | LANG set | `cat /etc/locale.conf` |
| Network | Autoconnect | Unplug/replug or reboot; `nmcli connection show` |
| Display | Saved layout restored | Settings → Save display layout; reboot; check outputs |
| Bootloader | Boots after `pacman -Syu` | `bootctl status`; btrfs entry has `rootflags=subvol=@` |

## Code landed

- Installer: `--keymap`, `vconsole.conf`, NM iwd backend, polkit share path, `systemd-timesyncd`, btrfs `rootflags=subvol=@`, disable live auth unit, `etheris-bootctl.hook`
- `etheris-auth-setup`: live-only guard + unit `ConditionKernelCommandLine=archisobasedir`
- `etheris-keymap-apply` / OOBE keyboard → console + greeter
- `etheris-display save` + Settings button

## E2E (next bake)

```bash
# Live → install (auto example)
sudo etheris-installer --auto --disk /dev/vda --confirm YES \
  --user demo --password demo --timezone Europe/Helsinki --keymap fi --no-reboot
# reboot into disk, complete OOBE, then cold reboot again and run the table above
```
