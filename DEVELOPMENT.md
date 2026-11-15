# Etheris OS — Development Guide

**Status:** Alpha 0.1.0 · Host builds via Podman · Test via `qemu:///session`

For contribution norms see [`CONTRIBUTING.md`](CONTRIBUTING.md).  
For current truth see [`SESSION-LOG.md`](SESSION-LOG.md).  
For full planning see [`docs/AUDIT-INDEX.md`](docs/AUDIT-INDEX.md).

## Build

```bash
cd ~/etheris-os
./scripts/prepare-profile.sh
./scripts/check-profile.sh
./scripts/test-p0-security.sh
./build.sh   # privileged Podman; --network=host on this host
```

Artifacts: `out/etheris-*.iso`, `out/SHA256SUMS`.

## Test

| Command | Purpose |
|---------|---------|
| `./scripts/test-p0-security.sh` | Installer/OOBE/polkit source gates |
| `./scripts/check-profile.sh` | Profile consistency |
| `./scripts/test-iso-smoke.sh` | Headless boot smoke |
| Libvirt live smoke | Manual / documented in `out/VERIFICATION-*` |

Do not mark features verified without evidence ([`docs/TESTING-STRATEGY.md`](docs/TESTING-STRATEGY.md)).

## Layout

| Path | Role |
|------|------|
| `profile/etheris/` | Archiso profile |
| `profile/.../usr/local/bin/etheris*` | First-party tools |
| `design/` | Neo-Aero previews + tokens (source) |
| `docs/` | Specs + audits |
| `scripts/` | Build/test helpers |

## Tooling (planned)

- ShellCheck / shfmt / Bats — recommended in DEVELOPMENT-ROADMAP; not all wired in CI yet  
- CI today: `.github/workflows/source-checks.yml`

## Rules of the road

1. Reliability before rice  
2. No telemetry  
3. No LUKS/Secure Boot claims until tested  
4. Sway remains default compositor unless ADR changes  
5. Prefer small PRs with verification notes  
