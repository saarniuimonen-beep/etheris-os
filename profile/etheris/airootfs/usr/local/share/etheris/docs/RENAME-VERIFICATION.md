# Etheris rename verification (Stage C checkpoint)

**Date:** 2026-11-10  
**Status:** **PASS** — user-facing identity is Etheris; no remaining Ethereal product branding in source.

## Method

Searched the project tree (excluding `out/` build logs, `work/` mkarchiso scratch, and binary ISOs) for:

- `Ethereal` / `Ethereal OS`
- Intermediate rename candidates: `Etherglow`, `Etherix`

## Results

| Area | Result |
|------|--------|
| `os-release` / hostname | `NAME="Etheris OS"`, `ID=etheris`, hostname `etheris` |
| Login (ReGreet) | Greeting **Etheris OS**; wallpapers under `/usr/local/share/etheris` |
| Boot (syslinux / GRUB / EFI) | Menu titles **Etheris OS** |
| ISO naming | `iso_name=etheris`, label `ETHERIS_YYYYMM`, `install_dir=etheris` |
| Desktop apps / `.desktop` | Etheris Settings, Files, Wallpapers, Transfers, Defaults, … |
| CLI / share tree | `/usr/local/bin/etheris*`, `/usr/local/share/etheris` |
| Docs / README | Project presented as Etheris |
| Path leftovers | No `*ethereal*` / `*etherglow*` / `*etherix*` paths |

## Remaining old-name mentions (intentional)

| Location | Why retained |
|----------|----------------|
| `SESSION-LOG.md` | Historical rename chronicle (Ethereal → … → Etheris). Not user-facing OS branding. |

## Outside the project tree (host leftovers)

Under `~/.local/share/libvirt/images/` some pre-rename filenames remain (`ethereal-*.iso`, `ethereal-*.qcow2`, `ethereal-inject.iso`). Active domain/ISO for testing is **etheris-os** / `etheris-2026.11.09-*.iso`. Host image renames are optional cleanup and are **not** OS branding.

No migration shims for `/etc/ethereal` or `~/.config/ethereal` were found or needed — prior work already used Etheris paths on this tree, or intermediate names never shipped as a public install.

## Compatibility notes

- Internal IDs (`ID=etheris`, session names, config under `~/.config/etheris`) stay Etheris.
- Third-party package names (Firefox, Steam, Arch, …) were not renamed.
- Live credentials remain documented as `etheris` / `etheris`.

## Gaps fixed during this checkpoint

- None required for branding strings in source.
- README still had some **stale feature wording** (tuigreet-first, wofi launcher) relative to the baked desktop stack; corrected separately as documentation accuracy, not rename.

## Checkpoint decision

**Rename verification: complete.** Proceed to Stage D — CPU & GPU Performance Manager.
