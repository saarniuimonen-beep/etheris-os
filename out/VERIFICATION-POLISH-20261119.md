# Verification — Etheris extreme polish bake (2026-11-19)

**ISO:** `out/etheris-2026.11.19-x86_64.iso`  
**SHA256:** `173b316bf047373a100b23b93fde678fa98002314a6930ac2b899d2350c63cf0`  
**Host:** Omarchy · `qemu:///session` · domain `etheris-os`

## Host gates

| Gate | Result |
|------|--------|
| `check-profile.sh` | **PASSED** |
| `test-p0-security.sh` | **44 OK** |
| `validate-iso.sh` | **30 OK, 0 FAIL** |
| `reliability-check.sh` | **21 OK, 0 FAIL** (L0/L1 + rock-solid tree) |
| `maturity-check.sh` | **15 OK, 0 FAIL** (STRICT L0/L1 + tree) |

## Live (no guest-apply)

| Gate | Result |
|------|--------|
| Rock-solid live (`test-rocksolid-live.sh`) | **11 OK, 0 FAIL** |
| Greeter ≤90s | **53s** |
| Auth ×3 | **12 OK** (see `06-auth1.png`) |
| Doctor | **16 OK / 0 FAIL / 2 WARN** (benign VM loop) — tooling present |
| Overlay soak ×15 | **PASS** |
| Second cold boot | **PASS** |
| Evidence | `out/qemu-rocksolid-20261119T170252Z/` |

## Polish probes (live)

| Tool | Result | Evidence |
|------|--------|----------|
| `etheris packages list` | gaming/dev/multimedia/**office** | `out/qemu-polish-20261119/42-packages.png` |
| `etheris privacy` | policy + Firefox telemetry path | `43-privacy.png` |
| Software Center GTK | filter · install/remove · trust labels | `44-software.png` |
| Monitor GTK | session_pss **209 MiB** OK ≤500 | `45-monitor.png` |
| Lock branding | wallpaper + Neo-Aero ring | `30-packages-privacy.png` (idle lock) |

## Shipped this bake

- Software Center / packages / privacy / report / monitor / profiles (were tree-only; now in ISO)
- Office package group
- Lock screen wallpaper + indicator polish
- Waybar wordmark `etheris` · glass blur default matches tokens (`off`)
- Doctor tooling section · richer report bundle
- `validate-iso.sh` local extract parity (was false-FAILING green ISO)

## Tree-only (missed mid-bake copy; optional apply)

- Control Center **Monitor** foot link → `out/cc-monitor-apply.tgz`

## Honest open

- Secure Boot signed images · physical GPU DUT · public publish
- GTK Adwaita CSS parser warnings under virtio (cosmetic)
- ReGreet still shows User row (password field focused / session auto-selected)
