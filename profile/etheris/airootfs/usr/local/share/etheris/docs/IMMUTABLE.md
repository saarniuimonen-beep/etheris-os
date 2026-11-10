# Etheris OS — Immutable Core & Recovery (Phase 20)

**Status: DESIGN ONLY — not implemented / not verified**

Do **not** claim Etheris is immutable until A/B updates, rollback, and QEMU tests in this document pass.

Prerequisite from the project spec: first bootable **and** installable milestone must work.  
Today: ISO boots (verified). Full install + immutable stack: **not verified**.

---

## Goals

1. Protect the OS core from accidental / app-driven corruption.
2. Apply system updates as **atomic deployments**, not in-place mutation of the running root.
3. Keep **user data** (`/home`, configs, documents) across updates and rollbacks.
4. Remain customizable (`~/.config`, Flatpak/apps) without writing into `/usr` by default.
5. Provide recovery (previous slot + live USB).

## Non-goals (for now)

- Shipping ostree/systemd-sysupdate/A/B in the experimental ISO.
- Secure Boot signing of deployment artifacts.
- Claiming Flatpak sandboxing without verified confinement.

---

## Recommended filesystem layout (future)

Prefer **Btrfs** for deployments that will grow into immutability.

| Subvolume | Mount | Role |
|-----------|--------|------|
| `@a` / `@b` | `/` (one active) | Immutable OS deployments (A/B) |
| `@home` | `/home` | User data (survives rollback) |
| `@var_log` | `/var/log` | Logs (persistent, not in OS image) |
| `@state` | `/var/lib/etheris/state` | Channel/update state, machine-local |
| `@tmp` / tmpfs | `/tmp`, `/var/tmp` | Ephemeral |
| ESP | `/boot` or `/efi` | systemd-boot + slot entries |

**ext4** remains supported for the classic mutable installer path so early installs stay simple.

Snapshots ≠ backups. Nested subvolumes must be designed so rolling `@a`/`@b` does not delete `@home`.

---

## Update model (future)

1. Download/verify a new deployment into the **inactive** slot.
2. Verify signatures (pacman / image checksums).
3. Mark slot bootable; reboot into it.
4. On success: keep previous slot as recovery.
5. On failure: boot previous slot automatically or via boot menu.

Ordinary `pacman -Syu` on a read-only root is **not** the update mechanism.

Investigation candidates (not chosen yet):

- systemd-sysupdate + Btrfs volumes  
- Custom “deploy root” + systemd-boot dual entries  
- ostree / bootc-style flows (heavier; evaluate later)

---

## Application model (future)

| Layer | Mechanism |
|-------|-----------|
| Desktop apps | Flatpak (optional) |
| Dev environments | Containers |
| OS / drivers / compositor | Controlled deployment only |
| Power users | **Developer mode** (explicit, warned, recoverable) |

---

## Developer mode (future)

- Off by default.
- Clear warning before enable.
- May remount writable or unlock a mutable overlay.
- Must not remove the recovery slot.

---

## Current experimental installs

| Property | Today |
|----------|--------|
| Root | **Mutable** (classic Arch) |
| Default FS in installer | ext4 (simple) |
| Btrfs path | Optional; creates future-friendly subvolumes **without** A/B |
| Updates | Normal `pacman -Syu` |
| Recovery | Live USB ISO |

Flag file on installed systems (when present):

`/etc/etheris/system-mode.conf` → `MODE=mutable-classic`

---

## Installer rules (to avoid painting into a corner)

1. Keep ESP + single root partition model for now (room to grow into A/B volumes later).
2. When Btrfs is chosen, create `@` + `@home` (+ `@var_log`) instead of a flat FS.
3. Never put user homes inside a disposable deployment subvolume.
4. Document that switching to immutable later may require reinstall or migration tooling.
5. Do not enable developer-mode or read-only `/` until update/rollback tests exist.

---

## Verification gate (before claiming “immutable”)

QEMU must demonstrate:

1. Boot  
2. Unprivileged writes to `/usr` fail  
3. Successful slot update  
4. Failed update recovery  
5. Rollback keeps `/home` documents and settings  
6. App install path (e.g. Flatpak) works  
7. Unbootable slot → previous slot boots  

Until then, Etheris is a **mutable** Arch-based desktop with a roadmap.
