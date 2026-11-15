# Etheris OS — Recovery procedures (Beta checklist)

Quick index of recovery docs:

| Situation | Doc / tool |
|-----------|------------|
| Install failed / interrupted | [`INSTALLER-FAILURE-MODES.md`](INSTALLER-FAILURE-MODES.md) |
| Bad update / wrong channel | [`UPDATE-RECOVERY.md`](UPDATE-RECOVERY.md) · `etheris-update recover` |
| Driver / NVIDIA brick | [`DRIVER-RECOVERY.md`](DRIVER-RECOVERY.md) |
| Auth / password / keymap | [`INSTALL-PERSISTENCE.md`](INSTALL-PERSISTENCE.md) |
| Security emergency snapshot | [`SECURITY-UPDATES.md`](SECURITY-UPDATES.md) |
| Diagnostics bundle | `etheris doctor` · `etheris report create` |

## Live ISO rescue pattern

1. Boot latest Etheris live ISO.  
2. Network on; `etheris doctor` optional.  
3. Mount installed root (+ ESP).  
4. `arch-chroot` and repair.  
5. Do not dual-write random configs without a backup copy.

## Not available yet

- One-click Btrfs rollback UI  
- A/B slot boot menu ([`IMMUTABLE.md`](IMMUTABLE.md))  
- Cloud backup restore  
