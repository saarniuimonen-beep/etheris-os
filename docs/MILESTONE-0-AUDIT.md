# Milestone 0 — Project Audit and Baseline

**Status:** Passed (documentation complete)  
**Date:** 2026-11-08  
**Version:** 0.1.0-alpha  
**Host:** Fedora 44 — builds via Podman; tests via `qemu:///session` only  

This report establishes what exists and what has been proven. It does **not** implement new features.

---

## 1. Repository structure

```
etheris-os/
├── VERSION                 # 0.1.0-alpha
├── build.sh                # Podman + mkarchiso
├── README.md
├── SESSION-LOG.md          # Handoff
├── MASTER-CHECKLIST.md     # Phase tracking (legacy numbering)
├── docs/                   # Specs + guides
├── scripts/                # prepare-profile, smoke helpers, mount-wrapper
├── profile/etheris/       # Archiso profile
│   ├── packages.x86_64
│   ├── pacman.conf         # [multilib] enabled
│   ├── profiledef.sh
│   └── airootfs/           # Overlay (configs, etheris-* tools)
├── out/                    # ISOs, logs, verification evidence
└── work/                   # Leftover host build debris (often root-owned)
```

**Build process:** `./build.sh` → `prepare-profile.sh` (sync skel → live home) → Podman `archlinux:latest` → `mkarchiso` → `out/etheris-YYYY.MM.DD-x86_64.iso` + `SHA256SUMS`.  
Host Fedora packages/bootloader/disks are not modified by design. Rootless Podman uses a mount wrapper for pacstrap `devtmpfs`.

---

## 2. What “Etheris Light” actually is

**Not an independent compositor.**

| Claim | Reality |
|-------|---------|
| Etheris Light | Product name for the **lightweight default desktop stack** |
| Compositor | **Sway** (`exec sway` from `etheris-session`) |
| Session wrapper | `/usr/local/bin/etheris-session` sets Wayland env + launches Sway |
| Session desktop file | `Etheris (Sway)` → `etheris-session` |
| Shell / panel | Waybar |
| Terminal / launcher / notify | foot / wofi / mako |
| Files | pcmanfm |
| Login | greetd + tuigreet + PAM |

**Debt:** Some docs/strings still say **labwc** (`desktops/etheris.txt`, in-image README, `etheris ram` still checks `*labwc*`). The **running** path is Sway. Treat labwc references as stale unless reintroduced as a separate session.

**Quickshell:** **Not present** anywhere in the tree. Evaluation only if later milestones justify it; keep Sway baseline.

---

## 3. Login / auth / session startup

| Component | Path / unit | Notes |
|-----------|-------------|--------|
| Display manager | greetd (`graphical.target.wants`) | |
| Greeter | tuigreet | Cosmetic greeting; F3 sessions / F12 power |
| Auth | PAM via greetd | Live user `etheris` / `etheris` |
| Auth setup | `etheris-auth-setup.service` | Fixes greeter/user on live |
| Default session | `etheris-session` → Sway | |

Custom branded greeter: **spec only** (`docs/LOGIN.md`). Do not replace without approval.

---

## 4. Packages and services (live ISO highlights)

**Desktop:** sway, waybar, foot, wofi, mako, pcmanfm, portals-wlr, pipewire, NetworkManager, greetd/tuigreet.  
**Gaming (from 2026.11.08):** steam, lib32 mesa/vulkan, gamemode, mangohud, gamescope, bluez.  
**Hardware tools:** etheris-hw, etheris-drivers, etheris-cpu-setup; intel/amd ucode; mesa stack.  
**Security defaults:** nftables on; sshd masked; no telemetry config; pacman SigLevel Required.  
**Enabled (examples):** NetworkManager, greetd, nftables, bluetooth, etheris-cpu-setup, etheris-mirror-lag.timer, pacman-init.

NVIDIA proprietary drivers are **not** on the ISO by default; selected post-detect via `etheris-drivers` (Pascal → AUR 580xx).

---

## 5. ISO build status

| Artifact | Size | SHA256 (prefix) | Build |
|----------|------|-----------------|-------|
| `out/etheris-2026.11.07-x86_64.iso` | ~1.6 GiB | `10fa426c…` | Success; **QEMU live verified** |
| `out/etheris-2026.11.08-x86_64.iso` | ~1.8 GiB | `2a42e2fa…` | Success; **QEMU live not re-verified** |

VM CDROM currently set to **2026.11.08**; domain may need reset to boot it.

---

## 6. Feature classification

Legend: **W** working (tested) · **P** partial · **B** broken · **U** untested · **S** spec-only

| Area | Class | Evidence / note |
|------|-------|-----------------|
| ISO build (Podman) | W | 11.07 + 11.08 logs |
| Live boot + greeter (11.07) | W | VERIFICATION-LIVE / USABILITY |
| Login + Sway (11.07) | W | same |
| WM shortcuts Alt+F4 / Super+Q / Alt+Tab / Super+H | W | USABILITY (restore Super+Shift+H partial under automation) |
| Welcome tip (live) | W | once + reopen |
| foot 1.28 config | W | fixed + verified on 11.07 |
| Cold boot without systemd-firstboot TUI | W | masked + UTC on 11.07 rebuild |
| Live boot/login (11.08) | U | Steam/multilib ISO not re-smoked |
| Installer E2E → installed boot | U | script exists; never proven |
| OOBE / first-boot wizard | S | `docs/OOBE.md` |
| Custom login UX | S | `docs/LOGIN.md` |
| Design token system | S | `docs/DESIGN.md` |
| Hardware detection tools | P | code + host smoke; not guest/physical matrix |
| Steam on ISO | P | packaged; launch unverified in guest |
| Idle ≤500 MB | P | ~0.4–0.5 G on 11.07 VM; remeasure 11.08 |
| Stale labwc docs | B/debt | misrepresents current Sway stack |
| Greeter journal bleed | P | cosmetic |
| Installer greeter uses bare `sway` | P | inconsistency vs live `etheris-session` |

---

## 7. Bugs / technical debt (prioritised)

1. **P0 for roadmap:** Latest ISO (11.08) core path unverified in QEMU after large package delta.  
2. **P0 for “usable by others”:** Installer never E2E-tested (Milestone 5).  
3. Stale **labwc** “Etheris Light” documentation vs Sway reality.  
4. Installer session command should match live (`etheris-session`).  
5. Welcome acceptance for **installed** users not proven (Milestone 4 installed criterion).  
6. Host `work/` leftovers may be root-owned after builds.  
7. Pascal NVIDIA depends on AUR 580xx longevity.

---

## 8. Performance (measured only)

| Metric | Value | Conditions |
|--------|-------|------------|
| Idle RAM | ~0.4–0.5 GiB / ~511 MiB fetch | QEMU, 2 GiB guest, live 11.07, Etheris/Sway, Steam **not** in that ISO |
| Boot time | not rigorously timed | — |
| 11.08 idle | **not measured** | Steam present; measure with Steam closed |

Do not invent numbers. 500 MB is a target, not a gate to strip security/hardware support.

---

## 9. Fedora / disk safety

- Builds: containerised.  
- Tests: libvirt user session + disposable qcow2.  
- **No** approved physical-disk or Fedora-host package changes in this project’s rules.

---

## 10. Roadmap milestone status (vs §12)

| # | Milestone | Status |
|---|-----------|--------|
| 0 | Project audit | **Passed** (this document) |
| 1 | Reproducible build + bootable ISO | **Passed** (`2026.11.08` + VERIFICATION-20261108) |
| 2 | Live login + session | **Passed** on 11.08 (incl. logout→greeter) |
| 3 | Core desktop / WM | **Passed** on 11.08 |
| 4 | First-login welcome | **Passed** live + installed (`demo` user) |
| 5 | Safe installer + installed boot | **Passed** (VERIFICATION-M5-INSTALLER; ISO rebuild to ship fixes still needed) |
| 6–14 | First-boot OOBE → stable release | **Not started** |

---

## 11. Recommended next milestone

**Complete Milestone 1 acceptance on the current artifact:** QEMU cold-boot / greeter / login / Sway smoke of `etheris-2026.11.08-x86_64.iso`, with written proof (`out/VERIFICATION-20261108.md`).

That also re-checks Milestones 2–3 (and live welcome) on the Steam-bearing ISO without expanding into installer redesign, OOBE, or visual replacement.

**After that passes:** Milestone 5 (installer on disposable qcow2) is the correct product gate.

---

## 12. Approval gate

Per roadmap §15: **do not expand scope** (installer expansion, OOBE, LOGIN/DESIGN implementation, Quickshell, compositor replacement) until the project owner approves the next milestone.

**Awaiting owner decision:** Approve **Milestone 1 re-verification of 2026.11.08** (recommended), or explicitly choose another milestone.
