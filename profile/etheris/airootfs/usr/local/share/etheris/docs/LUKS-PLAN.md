# Etheris OS — Optional LUKS plan (Alpha 0.3)

**Status:** Opt-in implemented + **QEMU E2E PASS** (install → unlock → greeter; wrong passphrase rejected) — **default remains unencrypted**  
**Evidence:** [`out/VERIFICATION-LUKS-E2E-20261115.md`](../out/VERIFICATION-LUKS-E2E-20261115.md)  
**Rule:** Claim “LUKS supported” only for the verified QEMU path; physical DUT / encrypted swap still open.

---

## Goals

- Optional full-disk encryption for `/` (and optionally `/home`) at install time.
- Clear recovery path when passphrase is forgotten or unlock fails.
- No silent encryption; typed confirmation in interactive and `--auto` modes.

---

## Proposed UX

| Mode | Behavior |
|------|----------|
| Default | Unencrypted (current) |
| Opt-in | `ETHERIS_INSTALL_LUKS=1` or installer prompt “Encrypt disk?” |
| Passphrase | Entered twice; never logged; unlock via cryptsetup in initramfs |

Partition sketch (UEFI):

1. ESP (unencrypted FAT)  
2. LUKS container → ext4 or btrfs root (and optional subvolumes)

---

## Implementation spikes (ordered)

1. Document cryptsetup + `encrypt` mkinitcpio hook on Arch.  
2. Prototype on disposable QEMU disk (not user data).  
3. Wire installer flag + fstab/`crypttab` generation.  
4. Greeter/boot: ensure unlock prompt is readable (console OK for 0.3).  
5. Recovery: live ISO unlock recipe in this doc.  
6. Matrix: wrong passphrase, reboot, resume-from-sleep (if swap encrypted later).

---

## Risks

| Risk | Mitigation |
|------|------------|
| Brick / unbootable | E2E gate; recovery section; default off |
| Support load | Explicit “you must remember the passphrase” |
| TPM/auto-unlock | **Out of scope** for 0.3 |
| Swap encryption | Defer; document hibernation unsupported when encrypted |

---

## Recovery (target text once shipped)

```text
1. Boot Etheris live ISO
2. cryptsetup open /dev/DISK root
3. mount /dev/mapper/root /mnt
4. mount ESP to /mnt/boot
5. arch-chroot /mnt
```

---

## Installer flags

```bash
sudo etheris-installer --auto … --luks --luks-passphrase '…'
# or: ETHERIS_INSTALL_LUKS=1 (passphrase defaults to user password)
```

Live ISO includes `cryptsetup`. Initramfs gets the `encrypt` hook; systemd-boot `options` include `cryptdevice=UUID=…:cryptroot`.

## Exit criteria before claiming “LUKS supported”

- [x] Install with LUKS on QEMU succeeds  
- [x] Cold boot unlock → greeter / session (OOBE TUI after login)  
- [x] Wrong passphrase fails safely  
- [x] Offline recovery unlock tested (`UNLOCK_OK` via nbd/cryptsetup)  
- [ ] Persistence matrix re-soak on LUKS disk (password, keymap, NM) — prior non-LUKS persist E2E still green
