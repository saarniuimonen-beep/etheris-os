# Etheris OS — Performance Audit

**Date:** 2026-11-15  

---

## Current implementation

| Area | State |
|------|--------|
| Target | ~500 MiB idle basic session (README); measured PSS much lower without Firefox |
| Idle measurement | `etheris ram` / idle-check (PSS-aware) |
| Perf profiles | `etheris-perf` / `etheris-performance` + `etheris-perf.service` |
| GPU helpers | `etheris-gpu` / `etheris-gpu-manager` |
| Browser lean path | Firefox policies + lean profile helpers |
| zram | `zram-generator` on package set |
| Live overlay | `cow_spacesize=2G` for Steam headroom |
| Animations | Default off in settings; Flow respects reduced motion |

---

## Verified measurements

| Check | Result | Evidence |
|-------|--------|----------|
| Idle **no Firefox**, session PSS | **≈124 MiB PASS** (≤500) | `out/VERIFICATION-IDLE-RAM-20261113.md` |
| Idle with warm Firefox | Fails ≤500 budget (expected) | `out/VERIFICATION-IDLE-RAM.md` (Nov 12) |
| Live desktop responsiveness (KVM) | Subjectively OK | 2026-11-15 smoke |
| Boot time (physical) | **Unverified** | — |
| Idle CPU / GPU power (laptop) | **Unverified** | — |

---

## Identified problems

1. **Default ISO includes gaming stack** — increases image size, install surface, and temptation to leave Steam resident (destroys idle RAM story).
2. **One-shot glass blur** (grim+ImageMagick) can hitch on weak GPUs when Menu opens with blur=on.
3. **Duplicate UI toolkits** — GTK4 apps + possible future Qt (Quickshell ADR) would regress RAM if dual panel ever ships (ADR forbids dual panel).
4. **Background services** — Avahi, Bluetooth, NM, PipeWire are justified; still worth periodic `systemd-analyze blame` on real hardware.
5. **No reproducible benchmark suite** in CI — only ad-hoc VM notes.

---

## Proposed solutions

| Change | Priority | Benefit | Risk |
|--------|----------|---------|------|
| Optional Gaming package group (off by default ISO variant or installer opt-in) | High | Smaller ISO, clearer lightweight identity | Extra build matrix |
| Keep animations/blur off by default | Keep | Predictable VM/laptop | Less “wow” |
| Benchmark script (boot to Waybar timestamp, idle PSS, cold Firefox) | High | Regression detection | Needs KVM CI time |
| Avoid Quickshell until RSS delta documented | Medium | Per ADR | Delays richer shell |
| Do not disable NM/PipeWire/nftables for scores | — | Reliability > vanity metrics | — |

---

## Performance implications for Neo-Aero

- Prefer **tokenized opacity** over permanent compositor blur (Sway limitation; SwayFX is a fork — **do not switch compositor casually**).
- One-shot blur for Menu is acceptable if timed and skippable (`blur=off`).
- Reduced-motion must remain first-class (already in Flow direction).
