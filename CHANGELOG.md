# Changelog

All notable Etheris OS development progress. Version remains **0.1.0-alpha** until a public release.

## Unreleased (development · through 2026-11-15)

### Desktop

- Thin top bar, Menu (Super+A) with hover, icon Rofi launcher, frosted Quick/Session power menu
- Flow / Ocean Glass tokens synced across GTK, Waybar, Rofi, wallpapers
- Password-first ReGreet greeter; hide stock Sway session entry
- Software Center, system monitor CLI, doctor, privacy helpers

### Installer & security

- UEFI installer persistence E2E (ext4/btrfs)
- Optional LUKS install + unlock E2E (QEMU, 2026-11-15)
- Security defaults verified: nftables, SSH masked, scoped polkit, auth-check 12 OK

### Reliability gates (QEMU)

- Stability, reliability, maturity STRICT — PASS
- Security criteria — 22 OK
- Bug criteria rock-solid — PASS (menu float clip fixed)
- Idle RAM rock-solid — ~169 MiB with `browser_preload=off`

### Tooling

- Host scripts: `test-stability.sh`, `reliability-check.sh`, `maturity-check.sh`, `test-security.sh`, `test-bugs.sh`, `measure-idle-ram.sh`, `validate-iso.sh`, channel soak helpers
- GitHub Actions source-checks workflow

### Latest ISO

- `etheris-2026.11.15-x86_64.iso`
- SHA256 `eb677f92d3d6a336b1eca3f6b8f64de4e649badabf22c17366468c3a4b05dfd6`

## 0.1.0-alpha (2026-11-10)

- Initial public-prep tree: Archiso profile, Etheris Sway desktop, Performance/GPU managers
- GitHub Pages website workflow and early release notes
- ISO bake `etheris-2026.11.10-x86_64.iso`
