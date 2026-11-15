# Verification — reliability + Menu rebake (2026-11-15)

## Artifact

| Item | Value |
|------|--------|
| ISO | `out/etheris-2026.11.15-x86_64.iso` |
| SHA256 | `ec72603b4dd635dec6394562516196798c605d037d81614faca278eed7889e75` |
| Build log | `out/build-20261115T163656Z.log` |
| Libvirt image | hardlinked at `~/.local/share/libvirt/images/etheris-2026.11.15-x86_64.iso` |

## Source gates

| Check | Result |
|-------|--------|
| `scripts/test-p0-security.sh` | **30 OK** |
| `scripts/check-profile.sh` | **PASSED** |

## Squashfs spot-check (mounted from ISO)

| Check | Result |
|-------|--------|
| `etheris-menu-hover` | **PASS** |
| `etheris-auth-check` libcrypt/ctypes | **PASS** |
| Polkit YES for keymap-apply + oobe-helper | **PASS** |
| ReGreet cache seeded (`etheris` + etheris.desktop) | **PASS** |
| `etheris-regreet-cache.service` enabled | **PASS** |
| `etheris-hide-stock-sway.service` enabled | **PASS** |
| Stock `sway.desktop` NoDisplay/Hidden | **PASS** (hook ran during build) |
| Waybar `format: Menu` + sway exec menu-hover | **PASS** |
| `etheris.desktop` session | **PASS** |

## Not yet (live VM)

- Cold boot → password-first greeter
- Login → hover Menu / Super+A / Super+D
- `etheris-auth-check` live counts
