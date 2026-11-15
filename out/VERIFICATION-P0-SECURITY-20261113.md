# P0 Security & Installation Fixes — verification (2026-11-13)

**Scope:** Source-level fixes only. No ISO rebuild. No disk install / cold reboot.

## Source tests

```bash
./scripts/test-p0-security.sh
```

**Result:** 30 OK, 0 FAIL (run on host Omarchy 2026-11-13).

| Check | Result |
|-------|--------|
| Shell syntax (`bash -n`) for installer/OOBE/auth/keymap/display/helper | PASS |
| `etheris-auth-setup.service` Conditions (`archisobasedir` + `/run/archiso`) | PASS |
| `systemd-analyze verify` (offline warnings only) | PASS |
| Auth-setup refuses on non-live host | PASS |
| Polkit scoped (no blanket YES); share ≡ etc | PASS |
| No `chmod 777/666` in OOBE/installer | PASS |
| Installer OOBE `root:wheel` 2770/660 + helper | PASS |
| OOBE `mark done` → `action=skip` | PASS |
| Installer args / ext4+btrfs / bootctl hook / timesyncd+iwd+vconsole+chpasswd | PASS |
| Installer masks auth-setup + removes live sudoers | PASS |

## Not performed (require next ISO + VM)

- Cold-reboot install persistence gates ([`INSTALL-PERSISTENCE.md`](../docs/INSTALL-PERSISTENCE.md))
- Live polkit agent prompt behaviour for `AUTH_ADMIN_KEEP` (pacman / keymap-apply)
- End-to-end OOBE on installed disk with wheel-group state writes
- ISO bake / publish

## ISO bake (approved)

| Item | Value |
|------|--------|
| File | `out/etheris-2026.11.13-x86_64.iso` |
| SHA256 | `4f6742823dc3019dfeae052d3895db344d13818ffd97d5925f335c9703fcd42e` |
| Built | 2026-11-13T15:27 local · log `out/build-p0-20261113T132031Z.console.log` |
| Spot-check in `work/mkarchiso/.../airootfs` | Scoped polkit · auth Conditions · `etheris-oobe-helper` · no OOBE `chmod 777` |

**Runtime persistence:** still **not verified** until install + cold reboot.
