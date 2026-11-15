# Etheris OS — Update recovery

**Tool:** `etheris-update`  
**Related:** [`CHANNELS.md`](CHANNELS.md), [`SECURITY.md`](SECURITY.md), [`SECURITY-UPDATES.md`](SECURITY-UPDATES.md)

---

## Normal upgrade

```bash
sudo etheris-update status
sudo etheris-update check
sudo etheris-update upgrade    # one pacman -Syu transaction
```

Before channel changes / security / refresh, the previous mirrorlist + snapshot are saved under `/var/lib/etheris/`.

---

## Interrupted `pacman -Syu`

1. **Do not reboot blindly** if the terminal is still open — note the last package line.
2. Remount RW if needed; ensure network works.
3. Prefer coherent recovery:

```bash
sudo etheris-update recover    # restore previous Archive snapshot mirrors
# then, if packages are mixed:
sudo pacman -Sy
sudo pacman -Suu               # allow downgrades to match snapshot
```

4. If `recover` has no previous snapshot: set channel explicitly (`sudo etheris-update channel stable`) then `upgrade`.
5. Kernel/bootloader: after a successful upgrade, confirm `bootctl status` and that the pacman hook copied kernels to the ESP (see installer persistence docs).

Lock file: while `upgrade` / `security` / `recover` run, `/var/lib/etheris/update.lock` is held. If a previous run died, remove the stale lock only when no pacman process is active:

```bash
sudo rm -f /var/lib/etheris/update.lock
```

---

## Wrong channel / too new packages

| Goal | Command |
|------|---------|
| Back to Stable lag | `sudo etheris-update channel stable` → `upgrade` or `recover` |
| Undo last mirror switch | `sudo etheris-update recover` |
| Emergency fresher security snapshot | `sudo etheris-update security` (typed confirm) |

---

## “System won’t boot after update”

1. Boot live ISO.  
2. Mount root + ESP.  
3. `arch-chroot` and inspect `pacman -Q linux`, `/boot`, `journalctl`.  
4. Restore mirrors from `/var/lib/etheris/previous-mirrorlist` if present; `pacman -Syu` / `-Suu` as needed.  
5. Reinstall kernel + `bootctl install` if ESP is empty.

Btrfs snapshots / A/B immutable rollback: **not shipped** (see [`IMMUTABLE.md`](IMMUTABLE.md)).
