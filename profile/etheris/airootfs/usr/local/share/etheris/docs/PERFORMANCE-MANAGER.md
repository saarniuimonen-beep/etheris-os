# Etheris Performance Manager & GPU Manager

**Status:** Implemented in tree (2026-11-10). Physical GPU profile effects require real hardware; VMs often expose limited cpufreq/GPU sysfs.

## What it is

Four safe performance profiles applied through manufacturer-supported Linux interfaces:

| Profile | Intent |
|---------|--------|
| `maximum` | Prefer higher CPU/GPU performance states (gaming, compile, AI) |
| `balanced` | Default everyday mode |
| `quiet` | Milder boost / quieter-oriented GPU power where supported |
| `powersave` | Prefer efficiency (laptops / battery) |

**Never:** overclock, undervolt, disable thermal protection, or invent fan curves.

## Tools

| Command | Role |
|---------|------|
| `etheris-perf` | Detect capabilities, apply profiles, metrics |
| `etheris-performance` | GTK Performance Manager |
| `etheris-gpu` | GPU status + driver/performance links |
| `etheris-gpu-manager` | GTK GPU Manager |
| `etheris-hw` / `etheris-drivers` | Existing hardware report / driver helpers |

Also: **Settings → Performance**, **Control Center (Super+A) → Performance profile**.

## Persistence

- System: `/var/lib/etheris/performance-profile`, `/etc/etheris/performance.conf`
- User: `~/.config/etheris/settings.conf` → `performance_profile=`
- Boot: `etheris-perf.service` oneshot (`apply`)

## Interfaces used (when present)

- CPU governors (`cpupower` / sysfs), EPP (`energy_performance_preference`)
- Boost / turbo sysfs (`cpufreq/boost`, `intel_pstate/no_turbo`)
- ACPI `platform_profile` when the firmware exposes choices
- AMDGPU `power_dpm_force_performance_level` / `power_dpm_state`
- NVIDIA: best-effort `nvidia-settings` PowerMizer + `nvidia-smi -pm` (no clock forcing)
- Intel GPU: `power/control` when writable
- Fans: only leave pwm enable in firmware/auto mode when nodes exist — **experimental / often unavailable**

Unsupported controls are skipped and listed under `etheris-perf capabilities`.

## Quick usage

```bash
etheris-perf status
etheris-perf set balanced
etheris-perf set maximum
etheris-perf restore
etheris-gpu status
etheris-performance   # GUI
```

Privileged apply uses `pkexec` (`AUTH_ADMIN_KEEP` for `/usr/local/bin/etheris-perf` — see `docs/POLKIT.md`).

## Honesty / testing

- Package presence ≠ profile effect. Verify with `etheris-perf monitor` before/after.
- QEMU often lacks real AMDGPU/NVIDIA sysfs — expect capability gaps.
- Document physical results in `docs/HARDWARE-TEST-MATRIX.md`.
