# Etheris OS — Development notes (Milestone 1)

Date: 2026-11-08  
Host: Fedora 44 (untouched — builds via Podman Arch container; tests via QEMU only)

## Audit — what already exists

| Area | Status |
|------|--------|
| Archiso profile `profile/etheris/` | Present (profiledef, packages, airootfs, efiboot, syslinux, grub) |
| Sway desktop configs | Present under `airootfs/etc/skel/.config/` |
| greetd + tuigreet config | Present (keep as default DM/greeter until `docs/LOGIN.md` approved) |
| Live user + auth setup | Present (`etheris` user, `etheris-auth-setup`) |
| Custom login UX | Spec only — `docs/LOGIN.md` (do not replace auth without approval) |
| First-boot OOBE | Design only — `docs/OOBE.md` (after installer verification; not live ISO) |
| Unified visual design | Proposal only — `docs/DESIGN.md` (tokens + launcher; after functional desktop) |
| `build.sh` (Podman + mkarchiso) | Present — **not yet verified to produce an ISO** |
| Custom installer script | Present — **not part of M1 success criteria until ISO boots** |
| Channel/update tooling | Present but **out of scope for M1** (spec §17) |

## Missing / risks for first bootable ISO

1. **ISO never built yet** — nothing verified bootable.
2. **~30 GiB free** on `/home` — build needs headroom; clean `work/` after failures.
3. **Host RAM tight** (~1.6 GiB available) — build/QEMU may be slow or OOM; use existing swap; do not touch Fedora disks.
4. Package names must be validated against Arch repos before `mkarchiso`.
5. Build must be **non-interactive** (`podman` without `-it` when unattended).
6. Build logs + SHA-256 required.
7. QEMU UEFI test required before claiming “works”.

## Milestone 1 plan (this phase only)

1. Validate every package in `packages.x86_64` exists on Arch.
2. Align `pacman.conf` with official archiso releng; use **official Arch mirrors** for the first successful ISO (channel lag deferred).
3. Harden `build.sh`: logs under `out/`, no TTY requirement, prepare-profile, checksums.
4. Run `mkarchiso` in Podman; capture log.
5. If build succeeds: QEMU UEFI boot smoke test (ISO only, no real disks).
6. Report pass/fail honestly; fix before any later phase.

## Explicitly NOT in this milestone

- Full installer end-to-end (script may ship on ISO; testing comes after live boot works)
- Update channels / LTS / custom mirrors
- Physical USB writing
- Fedora host package/bootloader/disk changes

## Milestone 1 outcome

See `out/MILESTONE1-RESULTS.md`. ISO built and live userspace reached in QEMU.
