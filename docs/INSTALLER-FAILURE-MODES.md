# Etheris OS — Installer failure modes

**Audience:** operators debugging `etheris-installer`  
**Related:** [`INSTALL-PERSISTENCE.md`](INSTALL-PERSISTENCE.md), [`OOBE.md`](OOBE.md)

---

## Preconditions (fail fast)

| Failure | Message / cause | Recovery |
|---------|-----------------|----------|
| Not root | `Run as root: sudo etheris-installer` | Re-run with sudo |
| Legacy BIOS | Requires UEFI | Boot firmware in UEFI mode |
| `--auto` without `--confirm YES` | Explicit gate | Pass `--confirm YES` |
| Bad disk | Not a block device / live medium | Pick another disk; never target the ISO device |
| Bad username | Must match `^[a-z_][a-z0-9_-]*$` | Choose a simple lowercase name |
| Password empty / mismatch | Interactive or `--password` | Re-enter matching passwords |
| Unsupported FS | Only `ext4` \| `btrfs` | Pass `--fs ext4` or `btrfs` |

---

## Mid-install failures

| Stage | Typical cause | Recovery |
|-------|---------------|----------|
| Partitioning | Disk busy, wrong size, leftover mounts | `umount` targets; reboot live; wipe safely |
| `pacstrap` | Mirror/network, partial sync, OOM | Check network; retry; enlarge live cow if needed |
| `arch-chroot` config | Script error in chroot heredoc | Capture log; reinstall (destructive) |
| Bootloader (`bootctl`) | ESP not mounted / not VFAT | Confirm `/boot` is ESP; reinstall |
| Password / user | `chpasswd` failure | Reinstall or chroot from live and fix `/etc/shadow` |

**Interrupted install:** There is **no** resume. Treat the target disk as dirty — re-run installer after confirming you can wipe it. Do not boot a half-written root and expect support.

---

## Post-install symptoms

| Symptom | Check | Fix path |
|---------|-------|----------|
| Greeter rejects password | Persistence matrix | [`INSTALL-PERSISTENCE.md`](INSTALL-PERSISTENCE.md) |
| Wrong keymap | `localectl` / vconsole | `etheris-keymap-apply` / OOBE |
| No network | NM + iwd | `nmcli` / Settings |
| Stuck in OOBE | Flag / helper | `etheris oobe status` |
| Auth-check FAIL | Live vs installed | Installed: auth-setup must be masked |

---

## Logging

- Prefer running from a terminal on the live desktop so stdout/stderr remain visible.
- For `--auto` harnesses, capture the full script output under `out/`.
- Do **not** log passwords.

---

## Gaming opt-in

Default disk install is **lean** (`ETHERIS_INSTALL_GAMING=0`).  
If Steam packages fail mid-pacstrap with gaming enabled, reinstall lean first, then add gaming packages later via package groups / Software Center (0.4).
