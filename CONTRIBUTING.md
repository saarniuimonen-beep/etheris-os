# Contributing to Etheris

Thanks for your interest. Etheris is early (**0.1.0-alpha**).

## Before you start

- Read `SESSION-LOG.md` and `MASTER-CHECKLIST.md` for current reality.
- Do not claim hardware support without test evidence.
- Prefer small, reviewable changes.

## Development host

- Fedora host builds ISOs with Podman (`./build.sh`).
- Test with `qemu:///session` only unless the owner approves otherwise.
- Do not modify Fedora host packages or physical disks in automation.

## Code style

- Match existing shell / Python patterns in `profile/etheris/airootfs/usr/local/bin/`.
- No telemetry. No secret commits. No anti-cheat bypass tooling.

## Pull requests

- Explain *why*.
- Note test method (VM, host smoke, physical).
- Update docs when behaviour changes.
