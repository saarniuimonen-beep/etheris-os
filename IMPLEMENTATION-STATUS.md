# Etheris OS — Implementation Status

**Date:** 2026-11-15 · **Version:** 0.1.0-alpha  

Legend (strict):

| Label | Meaning |
|-------|---------|
| **Verified** | Implemented and exercised with recorded evidence (`out/VERIFICATION-*` or P0 script) |
| **Unverified** | Code present; no adequate automated/live evidence in this audit |
| **Partial** | Meaningful subset ships; gaps remain |
| **Planned** | Documented intent only |
| **Broken / incomplete** | Known fail or stub that must not be advertised as done |

---

## Platform & build

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| Archiso ISO (BIOS+UEFI) | **Verified** | Multiple ISO bakes; latest smoke 2026-11-15 |
| `build.sh` Podman bake | **Verified** | Produces `out/etheris-*.iso` + SHA256SUMS |
| SOURCE_DATE_EPOCH | **Partial** | Set in build; bit-identical not proven |
| Rootless / reduced-privilege build | **Planned** | Privileged Podman required today |
| Image digest pinning | **Planned** | Uses `archlinux:latest` |
| Source CI (bash/py/P0/profile) | **Verified** | `.github/workflows/source-checks.yml` |
| Automated install CI | **Planned** | Harness scripts in `out/e2e-persist-harness/` only |
| Public signed releases | **Planned** | No signing pipeline |

## Installer & first boot

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| UEFI + systemd-boot installer | **Verified** | Persist E2E 2026-11-13 |
| ext4 / btrfs (+ subvol rootflags) | **Verified** | Installer + E2E |
| User/password/locale/TZ/keymap | **Verified** | Persist gates |
| Network autoconnect (NM+iwd) | **Verified** | Persist E2E |
| Live auth not carried to disk | **Verified** | Unit masked; sudoers stripped (P0 + E2E) |
| Etheris session on installed system | **Partial** | Installer copies desktop + hide-sway (in ISO); soak on latest bake limited |
| LUKS opt-in | **Planned** | No installer code paths |
| Legacy BIOS install | **Planned** | Installer requires UEFI |
| Interrupted-install recovery | **Partial** | Safety confirms; no full resume protocol |
| OOBE (TUI) | **Partial** | Exists; polkit YES hardened 2026-11-15; GTK OOBE planned |
| Privacy / channel pages in OOBE | **Partial** | Some pages; not full recommendation set |

## Login / session

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| greetd + ReGreet | **Verified** | Live smokes |
| Etheris (Sway) session | **Verified** | 2026-11-15 |
| Hide stock sway.desktop | **Verified** | Squashfs + greeter UI |
| Password-first (zero click) | **Partial** | Needs Login click once (2026-11-15) |
| TUI greeter fallback | **Unverified** | Code present (`etheris-greeter`) |

## Desktop shell

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| Sway + Waybar + Foot + portals | **Verified** | Live desktop |
| Menu / Control Center (GTK4) | **Verified** | Super+A 2026-11-15 |
| Launcher icons (Rofi/wofi path) | **Verified** | Super+D 2026-11-15 |
| Menu hover helper | **Partial** | Process runs; QEMU tablet hover flaky; prior hot-patch verified |
| Power menu | **Unverified** recently | Older VERIFICATION-POWER-MENU |
| Theme / wallpaper apply (Flow tokens) | **Partial** | Pipeline ships; phase-2 Neo-Aero “not applied” per IDENTITY |
| Notifications (mako) + DND restore | **Partial** | In tree; cross-login persistence not re-proven on latest ISO |
| Lock screen branding | **Partial** | swaylock present; Neo-Aero polish incomplete |
| Software Center | **Planned** | — |
| Workspace profiles | **Planned** | — |
| System Monitor app | **Partial** | Perf/GPU managers exist; no unified monitor UI |

## Security & privacy

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| No telemetry defaults | **Verified** (config) | `privacy.conf`, Firefox policies |
| nftables default firewall | **Verified** | Live: active 2026-11-15 |
| Scoped polkit | **Verified** | P0 + smoke |
| `etheris-security audit` | **Partial** | Exists; checklist-level, not LUKS/SB/SELinux |
| `etheris-auth-check` | **Verified** | 12 OK on 2026-11-15 live |
| LUKS | **Planned** | — |
| Secure Boot | **Planned** | — |
| SELinux | **Planned** | — |
| firewalld | **Planned** | nftables used instead |
| Flatpak default sandbox model | **Planned** | Not default |
| Privacy dashboard UI | **Planned** | Config file only |

## Updates & recovery

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| Channels stable/rc/edge | **Partial** | Code + docs; channel E2E thin |
| Archive lag mirrors | **Partial** | Implemented; promotion testing not routine |
| Previous mirrorlist save | **Partial** | `etheris-update` state dir |
| Btrfs snapshot rollback UX | **Planned** | — |
| Atomic / A/B updates | **Planned** | immutable-prep only |
| `etheris-immutable` protect `/usr` | **Partial** | Prep mode on btrfs installs; not full immutability |

## Hardware & performance

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| `etheris-hw` detect | **Unverified** on latest ISO | Code present; no invented values |
| GPU/perf managers | **Partial** | Tools ship; physical matrix open |
| Idle RAM ≤500 MiB (no Firefox) | **Verified** (2026-11-13) | ~124 MiB session PSS |
| Gaming stack on ISO | **Partial** | Packages present; Steam live needs cow space |

## CLI / diagnostics

| Feature | Status | Evidence / notes |
|---------|--------|------------------|
| `etheris` hub (theme/hw/gaming…) | **Partial** | Works; incomplete vs proposed CLI map |
| `etheris doctor` | **Partial** | In tree (+ prior ISO); newest CLIs need rebake |
| `etheris report create` | **Partial** | Implemented in tree |
| `etheris packages` / software | **Partial** | CLI groups; GTK store later |
| `etheris privacy` | **Partial** | CLI dashboard |
| Network diagnose command | **Planned** | NM used; no Etheris wrapper |
| LUKS / Secure Boot | **Planned** | Research docs only — not in installer |

---

## Summary counts (major rows above)

Roughly: many **Verified** core paths; large **Partial** middle; LUKS/SB/SELinux/Software Center/doctor still **Planned/Missing**. Alpha is real for live desktop + install persistence — not for enterprise security features.
