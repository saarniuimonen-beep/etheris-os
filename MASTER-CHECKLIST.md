# Etheris OS — Master Development Checklist (status)

Version: **0.1.0-alpha**  
Updated: 2026-11-15  

**Source of truth for “what to do next”:** [`SESSION-LOG.md`](SESSION-LOG.md).  
**Product roadmap (0.2→1.0):** [`docs/ROADMAP.md`](docs/ROADMAP.md).  
This file tracks phase coverage honestly. Legend: `[x]` done in tree · `[~]` partial · `[ ]` not done · `[!]` needs ISO/VM/hardware evidence

## PHASE 1 — Project foundation

- [x] Clean project structure (`profile/`, `build.sh`, `docs/`, `scripts/`, `website/`)
- [x] Arch Linux base · systemd · pacman
- [x] Official Arch repos via Archive lag channels
- [~] Optional AUR (`etheris-aur` lag gate; not default)
- [x] Versioning (`VERSION`, stamped `os-release` via `prepare-profile.sh`)
- [x] Build docs (`README.md`)
- [~] Reproducible ISO (`SOURCE_DATE_EPOCH`; full bit-identical `[!]`)
- [x] Source CI (`source-checks.yml`: bash -n, py_compile, P0, `check-profile.sh`)

## PHASE 2 — Lightweight desktop (Sway)

- [x] Sway default + Waybar / Foot / Wofi / Rofi / Mako / PCManFM
- [x] PipeWire · NetworkManager · portals (`xdg-desktop-portal-wlr`)
- [x] greetd + **ReGreet** (graphical login) + tuigreet text fallback
- [x] swaylock / swayidle / clipboard / screenshot tools
- [x] Live login + Sway verified in QEMU (see `out/VERIFICATION-*.md`)

## PHASE 3 — Etheris visual identity

- [~] Logo / brand kit (SVG mark; full kit later)
- [x] Theme packs + wallpapers + token pipeline (`etheris-tokens-generate`)
- [x] Etheris Settings / Control Center / power menu / wallpaper
- [x] ReGreet branding (`docs/LOGIN.md`)
- [~] Design phase-2 previews (Sway cannot do true frosted blur)
- [x] MOTD matches shipped desktop (Sway only — no fake DE picker)

## PHASE 4 — Customization

- [x] `~/.config` Sway stack + `~/.config/etheris/`
- [x] Themes / wallpapers via `etheris`
- [~] Panel / launcher docs

## PHASE 5 — Bootable USB ISO

- [x] Archiso profile (BIOS syslinux + UEFI systemd-boot)
- [x] Live overlay (`cow_spacesize=2G` for Steam)
- [x] Hybrid ISO builds (`out/etheris-*.iso` + `SHA256SUMS`)
- [x] QEMU live smoke scripts (`test-iso.sh`, `test-iso-smoke.sh` → newest ISO)
- [x] First-login welcome / guide / shortcuts / sound

## PHASE 6 — Custom installer

- [x] `etheris-installer` (UEFI + systemd-boot, ext4/btrfs, `--auto` CI mode)
- [x] Full persistence gate matrix — cold-reboot E2E on KVM 2026-11-13 ([`out/VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md`](out/VERIFICATION-INSTALL-PERSISTENCE-E2E-20261113.md)); installer session/hide-sway in tree — **re-E2E on ISO `ec72603b…` still open**
- [ ] LUKS opt-in UI (deferred)
- [ ] Secure Boot (deferred)

## PHASE 7 — Performance

- [x] Light session defaults · zram · perf/GPU managers
- [x] Idle RAM measured in QEMU (~124 MiB session PSS without Firefox) — see SESSION-LOG
- [!] Physical idle / boot timing

## PHASE 8 — Testing

- [x] Build · live login · Sway · P0 security source tests (30 OK)
- [~] Installer VM E2E / audio / fuller net — persistence cold-reboot **PASS** on 2026-11-13 ISO; re-verify on latest bake; audio/net matrix still thin
- [!] Physical hardware matrix

## PHASE 9 — Documentation and release

- [x] Community files · security/privacy docs · release notes stub
- [x] Release checklist: [`docs/RELEASE-CHECKLIST.md`](docs/RELEASE-CHECKLIST.md)
- [~] Website local-only (Pages workflow ready; **no public publish without approval**)
- [ ] Signed release artifacts / public GitHub Release

## Update channels

- [x] Stable default (**14-day** Archive lag) · RC · Edge
- [x] `etheris-update` / recover / security snapshot helpers
- [x] `BUILD_ID=rolling-lag14` aligned with `channels.conf`
- [ ] Custom Etheris mirrors — blocked
- [ ] 4-year support — deferred ([`docs/RELEASE-POLICY.md`](docs/RELEASE-POLICY.md))

## PHASE 19 — Security and privacy

- [x] No telemetry · nftables on · SSH masked · pacman signatures
- [x] Scoped polkit · live-only auth-setup · OOBE permissions hardened (P0 baked 2026-11-13)
- [x] `etheris-security` + [`docs/SECURITY.md`](docs/SECURITY.md)
- [ ] LUKS / Secure Boot / public release audit

## PHASE 20 — Immutable core (planning)

- [x] Plan + `MODE=mutable-classic` + stub CLI
- [ ] Read-only base / A/B / rollback — not implemented

## PHASE 21 — Custom login

- [x] ReGreet graphical login shipped (was planning-only in older checklist revisions)
- [~] Further a11y / theming polish

## PHASE 22 — OOBE

- [x] Foot TUI OOBE + session gate + M6 verification
- [ ] GTK branded OOBE (optional)
- [!] Fresh-install E2E without inject on latest ISO

## PHASE 23 — Unified visual design

- [x] Design docs + token apply path in tree
- [~] Phase-2 desktop polish ongoing

## PHASE 24 — CPU / GPU / Gaming

- [x] Hardware/drivers/perf/GPU/RGB tooling + Steam/Wine stack on ISO
- [!] Physical Pascal / Turing+ / AMD / Intel / Proton / suspend matrix

## Next (from SESSION-LOG / DEVELOPMENT-ROADMAP Alpha 0.2)

1. [x] `scripts/validate-iso.sh` post-bake gates (tree)
2. [x] Greeter `state.toml` seed (tree) — live zero-click after rebake
3. [x] `etheris doctor` aggregator (tree)
4. Rebake + validate-iso + live password-first smoke
4. Keep website local until owner approval · defer LUKS/Secure Boot to Alpha 0.3

Audit pack: [`docs/AUDIT-INDEX.md`](docs/AUDIT-INDEX.md)
