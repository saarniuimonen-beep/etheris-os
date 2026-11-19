# Etheris OS — Development Roadmap

**Status:** active planning (0.1.0-alpha → 0.2 reliability)  
**Principle:** quality over quantity — reliability, security, privacy, and maintainability before feature sprawl.

This document folds the project recommendations into an honest roadmap mapped to what already exists in-tree. Detail for “what to do next” still lives in [`SESSION-LOG.md`](../SESSION-LOG.md). Coverage checklist: [`MASTER-CHECKLIST.md`](../MASTER-CHECKLIST.md).

---

## Guiding priorities

1. **Reliability** — installer, first boot, greeter, session, updates that do not brick
2. **Security & privacy** — strong defaults, no live credentials on disk installs, scoped polkit
3. **Maintainability** — reproducible builds, tests, small core, optional package groups
4. **Identity** — Etheris desktop (Flow / Ocean Glass) as a coherent OS, not a package collage

---

## Already in place (honest baseline)

| Area | Status |
|------|--------|
| Archiso live ISO + UEFI/BIOS | Done · rebakes verified in QEMU |
| greetd + ReGreet · Etheris session · hide stock Sway | Done (2026-11-15 reliability bake) |
| Installer (UEFI, ext4/btrfs) + persistence gates | Done · cold-reboot E2E on KVM |
| Live-only auth-setup (not copied to installs) | Done |
| Scoped polkit · nftables · no telemetry · SSH masked | Done (P0 source tests) |
| Update channels (stable lag / rc / edge) + `etheris-update` | Partial — channels exist; recovery/rollback thin |
| Control Center / Settings / OOBE / themes | Partial — present; polish ongoing |
| Hardware / GPU / gaming tooling on ISO | Present · physical matrix open |
| Source CI (`bash -n`, P0, `check-profile`) | Done |
| Optional LUKS in installer | **Done** (QEMU E2E 2026-11-15; default off) |
| Software Center | **Done** (GTK + package groups in tree/ISO) |
| Secure Boot · SELinux | Secure Boot unsupported (plan/spike only) · SELinux stays off |

---

## 1. Security and privacy

| Recommendation | Plan | When |
|----------------|------|------|
| Optional LUKS in installer | **Done** in CLI (`--luks`); polish recovery docs / UI | Alpha **0.2–0.3** |
| Secure Boot (signed bootloader + keys) | After installer LUKS path is solid | Alpha **0.3** |
| Review sudo / services / live creds | Keep auditing; live sudoers already stripped on install | Ongoing · Alpha **0.2** |
| Firewall defaults | Today: **nftables**; evaluate firewalld only if it clearly improves UX without regressing live | Alpha **0.3** review |
| Security docs | [`SECURITY.md`](SECURITY.md) · [`POLKIT.md`](POLKIT.md) — expand user-facing guide | Alpha **0.2–0.3** |
| Privacy dashboard / app permissions | After Software Center foundations | Alpha **0.4** |
| SELinux evaluation | Research note first (Arch/Sway friction); no force-enable | Alpha **0.3** study |

---

## 2. Update system and recovery

| Recommendation | Plan | When |
|----------------|------|------|
| Recover from interrupted updates | Harden `etheris-update` + documented resume | Alpha **0.2–0.3** |
| Signature / repo authenticity | Pacman signatures already on; document + CI check | Alpha **0.2** |
| Preflight dependency conflicts | `pacman` dry-run gate in update helper | Alpha **0.3** |
| Channel switching safety | Explicit confirm + lag explanation | Alpha **0.3** |
| Critical security updates across channels | Policy: security never blocked by lag | Alpha **0.3** |
| Rollback / Btrfs snapshots | Snapshot on update when FS=btrfs; boot entry helper | Alpha **0.3–0.4** |

---

## 3. Build system and infrastructure

| Recommendation | Plan | When |
|----------------|------|------|
| Reduce container privileges / rootless | Investigate; host today needs privileged Podman for pacstrap | Alpha **0.2** spike |
| Pin container image + deps | Digest-pin `archlinux` image; record versions in build log | Alpha **0.2** |
| Reproducibility | `SOURCE_DATE_EPOCH` already; chase remaining drift | Ongoing |
| Automated ISO validation | Extend `test-iso-smoke.sh` + post-bake squashfs gates | Alpha **0.2** |
| Checksums / manifests | `SHA256SUMS` on every bake — keep; add release manifest later | Now / Beta |
| Automated install + boot tests | Libvirt harness (live + `--auto` install) in CI or nightly | Alpha **0.2** |

---

## 4. Lightweight architecture (package groups)

Ship a **small core** by default; keep heavy stacks optional:

| Group | Contents | Default on ISO |
|-------|----------|----------------|
| **Core** | base, networking, security, update tooling | Yes |
| **Desktop** | Sway, Waybar, portals, greeter, Etheris shell | Yes |
| **Gaming** | Steam, Wine, Gamescope, … | Yes today → **optional** by 0.4 |
| **Development** | git, compilers, SDKs | Optional |
| **Multimedia** | codecs / media apps | Optional |
| **Optional** | extras | Optional |

Installer / Software Center should expose these groups rather than growing the default squashfs forever.

---

## 5. Desktop experience

| Piece | Status | Next |
|-------|--------|------|
| Control Center / Menu sheet | Present | Reliability + a11y |
| First-boot OOBE | Present (TUI) | Polkit-safe apply (done 2026-11-15); GTK optional later |
| Software Center | Missing | Alpha **0.4** |
| System Monitor (CPU/GPU/RAM/temp) | Partial via existing tools | Unify under Etheris UI · 0.4 |
| Theme manager | Themes exist | Deeper system sync · 0.4 |
| Settings ↔ system config | Partial | Persistence gates already; keep expanding |

---

## 6. Long-term (after core is dependable)

- Atomic / transactional updates  
- Btrfs snapshot integration (user-facing)  
- Hardware detection + driver management (beyond current helpers)  
- Application permission management + privacy dashboard  
- Automatic backups  
- Gaming profiles / performance presets  
- Deeper desktop customization  

Introduce only with tests and docs; none of these are Alpha 0.2 blockers.

---

## 7. Version roadmap

### Alpha **0.2** — Reliability *(current focus)*

- [x] Greeter session clarity (Etheris only; ReGreet cache / skip_selection seed)
- [x] Auth-check on Python 3.13 · OOBE polkit without faillock trap
- [x] Menu polish baked into ISO
- [x] Live smoke on latest ISO — greeter → desktop → auth-check **12 OK** → Super+A Menu / Super+D ([`out/VERIFICATION-RELIABILITY-SMOKE-20261115.md`](../out/VERIFICATION-RELIABILITY-SMOKE-20261115.md))
- [x] Greeter seed corrected to ReGreet `state.toml` + rebake
- [x] Live confirm: password-first greeter (Password focused; auto session) — `out/qemu-alpha02-greeter-20261115/`
- [x] Automated post-bake validation script (`scripts/validate-iso.sh` squashfs gates; boot smoke remains separate)
- [x] Installer failure modes documented (`INSTALLER-FAILURE-MODES.md`)
- [x] Hardware matrix: QEMU rows filled; physical GPU rows still open
- [x] Pin build image script + `build.sh` pin support; validate-iso every bake

### Alpha **0.3** — Security

- [x] Optional LUKS **in installer** + QEMU unlock E2E PASS (`out/VERIFICATION-LUKS-E2E-20261115.md`) — default off  
- [x] Secure Boot **unsupported** stance + OVMF probe (`SECURE-BOOT-PLAN.md`, `secure-boot-qemu-probe.sh`) — no signed keys  
- [x] Security defaults review (existing audit + nftables)  
- [x] Update recovery + security-update policy (`UPDATE-RECOVERY.md`, `SECURITY-UPDATES.md`)  
- [x] SELinux evaluation write-up (`SELINUX-STUDY.md`) — not enabling SELinux  

### Alpha **0.4** — Ecosystem

- [x] Software Center CLI + **GTK** (`etheris-software-center`)  
- [x] Installer gaming opt-in (`ETHERIS_INSTALL_GAMING=1`; default lean) — live ISO still ships stack
- [x] Package groups (`groups/*.list` + PACKAGE-GROUPS.md)  
- [x] Privacy dashboard + Settings/CC Privacy entry points  
- [x] Stronger desktop integration (Settings Software/Privacy · CC Apps/Privacy · monitor · profiles)  

### Beta **0.5** — Stability

- [x] Build reproducibility notes + pin script (`REPRODUCIBILITY.md`)  
- [ ] Broader **physical** hardware validation (needs real GPUs) — **BLOCKED** (matrix rows marked)  
- [x] Channel validation automation (`scripts/channel-validate.sh` + soak scaffold)  
- [x] Recovery procedures index (`RECOVERY.md`)  

### Beta **1.0** — Release preparation
- [x] Release-prep checklist scaffold ([`RELEASE-PREP-1.0.md`](RELEASE-PREP-1.0.md))  
- [x] QEMU install + LUKS E2E (`out/VERIFICATION-LUKS-E2E-20261115.md`)  
- [ ] Extensive **physical** install testing  
- [x] Security review stance: LUKS QEMU OK to advertise as optional; SB still unsupported; SELinux off  
- [ ] Update/recovery validation on hardware  
- [ ] Docs + release infrastructure (signed artifacts only with owner approval) — **not shipping 1.0 yet**

---

## Final stance

Prefer a **dependable installer, secure defaults, reliable updates, effective recovery, and a consistent desktop** over more apps and one-off tools.

Etheris should feel like one operating system: flexible and transparent like open source, with a polished desktop, strong privacy, sensible security, and long-term reliability.
