# Etheris OS — Development Roadmap (Comprehensive)

**Date:** 2026-11-15 · **Version:** 0.1.0-alpha  
**Supersedes for planning detail:** earlier [`ROADMAP.md`](ROADMAP.md) (kept as short product view)  

**Philosophy:** A smaller number of excellent, reliable features beats a pile of unfinished ones.

---

## Priority legend

- **Critical** — install, boot, update, recovery, security defaults, ISO testing  
- **High** — CLI/diagnostics, hardware, packaging, network/power, build, docs  
- **Medium** — Control Center depth, Neo-Aero system, themes, profiles, a11y, DX tooling  
- **Experimental** — atomic updates, compositor forks, advanced automation  

---

## Critical (Alpha 0.2)

| Item | Status |
|------|--------|
| Password-first greeter | **Done** (ISO `37566bb8…`) |
| `scripts/validate-iso.sh` | **Done** |
| Installer failure modes docs | **Done** |
| Update recovery guidance + lock | **Done** |
| Hardware matrix honesty | **Done** (QEMU filled; physical open) |
| Build image pin support | **Done** (`pin-build-image.sh` + `build.sh`) |
| P0 + auth-check | Keep green every bake |

---

## Critical → Alpha 0.3 (Security)

| Item | Status |
|------|--------|
| Optional LUKS | **Done** — installer `--luks` + QEMU E2E PASS ([`LUKS-PLAN.md`](LUKS-PLAN.md), `out/VERIFICATION-LUKS-E2E-20261115.md`) |
| Secure Boot | **Done as unsupported** — plan + OVMF probe ([`SECURE-BOOT-PLAN.md`](SECURE-BOOT-PLAN.md)); no signed keys |
| Security updates policy | **Done** — [`SECURITY-UPDATES.md`](SECURITY-UPDATES.md) |
| SELinux | **Study done — do not enable** — [`SELINUX-STUDY.md`](SELINUX-STUDY.md) |

---

## High / Alpha 0.4

| Item | Status |
|------|--------|
| `etheris doctor` | **Done** |
| `etheris report create` | **Done** |
| Package groups | **Done** (lists + CLI) |
| Software Center | **Done** (CLI + GTK) |
| Privacy dashboard | **Done** (`etheris privacy` + Settings/CC) |
| Build pinning | **Done** (`out/build-image.pin`) |

---

## Medium (Neo-Aero)

| Phase | Status |
|-------|--------|
| D0 naming glossary | **Done** |
| D1 tokens 28/0 + blur=off | **Done** |
| D2 chrome polish | **Done (tree)** — lock/launcher/CC foot; rebake for lock CSS on live |
| D3 CC IA / profiles / monitor UI | **Done (tree)** — Privacy/Apps/Updates · `etheris profiles` · `etheris monitor` |
| D4 experimental compositors | Gated |

See [`DESIGN-ROADMAP.md`](DESIGN-ROADMAP.md).

---

## Beta 0.5 / 1.0

| Item | Status |
|------|--------|
| Recovery index | **Done** — [`RECOVERY.md`](RECOVERY.md) |
| Reproducibility notes | **Done** — [`REPRODUCIBILITY.md`](REPRODUCIBILITY.md) |
| Release-prep checklist | **Done** — [`RELEASE-PREP-1.0.md`](RELEASE-PREP-1.0.md) |
| Channel validate/soak automation | **Done** scaffold — multi-day operator soak open |
| Physical HW matrix / signed publish / 1.0 cut | **Open** (BLOCKED on DUT + owner approval) |

---

## Explicitly not done (honest)

- Secure Boot **signed** images / “SB supported” claim  
- SELinux enforcing  
- Physical GPU certification (Etheris-on-DUT)  
- Bit-identical reproducible ISOs  
- Shipping **1.0**

---

## Dependency graph (simplified)

```
ISO validation ──► greeter polish ──► installer LUKS (gated)
       │
       └─► update recovery ──► snapshots/rollback (future)
desktop tokens ──► theme manager ──► CC privacy/updates panels
package groups ──► Software Center GTK
doctor/report ──► support quality
```
