# P0 Security — verification (2026-11-15)

**Scope:** Expanded source-level criteria + fixes. No ISO rebuild in this pass.

## Source tests

```bash
./scripts/test-p0-security.sh
```

**Result:** 44 OK, 0 FAIL (host Omarchy 2026-11-15).

### Prior criteria (still green)

| Check | Result |
|-------|--------|
| Shell syntax for installer/OOBE/auth/keymap/display/helper | PASS |
| Auth-setup live Conditions + refuses on non-live host | PASS |
| Scoped polkit; share ≡ etc | PASS |
| No chmod 777/666; OOBE root:wheel 2770/660 | PASS |
| Installer masks auth-setup + removes live sudoers | PASS |

### New criteria (2026-11-15)

| Check | Result |
|-------|--------|
| Installer seeds ReGreet `state.toml` (`last_user` + Etheris session) | PASS |
| No reliance on legacy `cache.toml`/`cache.json` | PASS |
| Live airootfs `state.toml` seed present | PASS |
| `etheris-keymap-apply` validates + rejects unsafe LAYOUT | PASS |
| nftables input `policy drop` + enabled on multi-user + installer enable | PASS |
| Installer masks `sshd`; live NOPASSWD + installed password sudo | PASS |
| Live sudoers mode 440 | PASS |
| privacy.conf telemetry/analytics/crash off | PASS |
| sysctl security defaults present | PASS |
| `etheris-security audit` covers sshd + telemetry | PASS |

## Fixes applied so tests pass

1. **Installer** — seed `/var/lib/regreet/state.toml` for installed user; remove legacy cache files.
2. **keymap-apply** — reject LAYOUT/VARIANT outside `[a-z0-9_-]+` before sed/localectl.
3. **etheris-security audit** — listening summary / port 22, LUKS note, sudoers inventory, nftables drop, sysctl.

## Not performed

- ISO rebake / VM install cold-reboot with new state.toml seed
- Live polkit agent prompt behaviour
