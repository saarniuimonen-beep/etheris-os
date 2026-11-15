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
| Optional LUKS | **Plan only** — [`LUKS-PLAN.md`](LUKS-PLAN.md); no installer merge until E2E |
| Secure Boot | **Plan only** — [`SECURE-BOOT-PLAN.md`](SECURE-BOOT-PLAN.md) |
| Security updates policy | **Done** — [`SECURITY-UPDATES.md`](SECURITY-UPDATES.md) |
| SELinux | **Study done — do not enable** — [`SELINUX-STUDY.md`](SELINUX-STUDY.md) |

---

## High / Alpha 0.4

| Item | Status |
|------|--------|
| `etheris doctor` | **Done** |
| `etheris report create` | **Done** |
| Package groups | **Done** (lists + CLI) |
| Software Center | **CLI stub**; GTK later |
| Privacy dashboard | **CLI** (`etheris privacy`) |
| Build pinning | **Done** |

---

## Medium (Neo-Aero)

| Phase | Status |
|-------|--------|
| D0 naming glossary | **Done** |
| D1 tokens 28/0 + blur=off | **Done** |
| D2 chrome polish | Open |
| D3 CC IA / profiles / monitor UI | Open |
| D4 experimental compositors | Gated |

See [`DESIGN-ROADMAP.md`](DESIGN-ROADMAP.md).

---

## Beta 0.5 / 1.0

| Item | Status |
|------|--------|
| Recovery index | **Done** — [`RECOVERY.md`](RECOVERY.md) |
| Reproducibility notes | **Done** — [`REPRODUCIBILITY.md`](REPRODUCIBILITY.md) |
| Release-prep checklist | **Done** — [`RELEASE-PREP-1.0.md`](RELEASE-PREP-1.0.md) |
| Physical HW matrix / channel automation / signed publish | **Open** |

---

## Explicitly not done (honest)

- LUKS in installer  
- Secure Boot signed images  
- SELinux enforcing  
- GTK Software Center  
- Physical GPU certification  
- Full Neo-Aero D2–D3 UI polish  
- Bit-identical reproducible ISOs  

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
