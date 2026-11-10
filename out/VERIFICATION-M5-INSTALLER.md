# Milestone 5 — Installer E2E verification

**Date:** 2026-11-08  
**Live ISO used:** `ethereal-2026.11.08-x86_64.iso`  
**Installer under test:** tree copy injected via virtio FAT (`ethereal-inject.img`) — includes disk-detection fix + `--auto`  
**Disk:** disposable `~/.local/share/libvirt/images/ethereal-os.qcow2` (30 GiB sparse → ~3.5 GiB used)  
**Evidence:** `out/verification-m5/`

## Acceptance criteria

| Criterion | Result |
|-----------|--------|
| Clean install on disposable virtual disk | **PASS** |
| Target disk clearly identified (`/dev/vda`) before modify | **PASS** (summary + `--confirm YES`) |
| Destructive ops require explicit YES | **PASS** (`--confirm YES` required in `--auto`) |
| Installed system boots **without** ISO attached | **PASS** (`installed-boot-20.png` greeter) |
| User can log in | **PASS** (`demo` / `demo`) |
| Desktop starts (Sway + welcome) | **PASS** (`installed-01` welcome, `installed-03` `demo@ethereal` terminal) |
| Failed install does not report success | **PASS** (earlier disk-detect failure exited with ERROR) |

## Fixes made during M5

1. **Disk detection:** `lsblk` with MODEL/TRAN empty shifted fields → virtio `vda` invisible. Fixed to `NAME,TYPE` parsing.
2. **`--auto` mode:** for VM/CI; still requires `--confirm YES` and `--disk`.
3. **Greeter on installed system:** uses `ethereal-session` (not bare `sway`).
4. **Lean auto gaming default:** `--auto` omits Steam unless `ETHEREAL_INSTALL_GAMING=1` (host RAM / VM size).

## Notes / limitations

- Installer fixes are **in the git tree** and were proven via inject disk; they are **not yet baked into a new ISO** (rebuild still needed for USB media).
- This E2E used lean packages (no Steam on installed disk). Live ISO still has Steam. Interactive installs default gaming ON.
- Restart/shutdown of installed system not separately timed after login (session is up).
- Physical hardware install not tested.

## Verdict

**Milestone 5: Passed** (VM disposable-disk path).

**Recommended next:** rebuild ISO to ship installer fixes → Milestone 6 (first-boot OOBE) only for settings not already set by installer; or Milestone 7 hardware services matrix in VM.
