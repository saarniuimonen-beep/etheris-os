# Verification — remaining-phase implementation bake

**Date:** 2026-11-15  
**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `79106f8b47177585a113075d79153141e13ccbfd97363911768318e1ecb8b105`

## Gates

| Gate | Result |
|------|--------|
| `check-profile.sh` | PASSED |
| `test-p0-security.sh` | 30 OK |
| `validate-iso.sh` | **23 OK** (incl. packages/privacy/report/software-center/monitor/profiles/`--luks`) |
| Greeter password-first | **PASS** (`out/qemu-phase-impl-20261115/greeter2.png`) |
| `channel-validate.sh` | Archive stable/rc DBs reachable |
| Secure Boot spike | Harness OK; **no** secboot OVMF on host |

## Shipped in this ISO

- LUKS opt-in installer (`--luks`) + `cryptsetup` on live  
- GTK Software Center · Settings Privacy/Software · CC Privacy/Apps  
- `etheris monitor` · `etheris profiles`  
- Package groups gaming/dev/multimedia  

## Not completed (honest)

| Item | Why |
|------|-----|
| Install persistence E2E re-run | Needs dedicated guest install automation (`virt-install` missing on host); disk `etheris-e2e-20261115.qcow2` prepared |
| LUKS unlock E2E | Depends on install E2E with `--luks` |
| Physical GPU matrix rows | No physical NVIDIA/AMD/Intel DUT in this session |
| Secure Boot signed boot | No `OVMF_CODE.secboot.fd`; product still unsupported |
| Neo-Aero D2 launcher/lock polish | Partial (waybar + CC only) |
| 1.0 release | Checklist only — not a release |

## Next operator steps

```bash
# Install E2E (manual or with virt-install once available):
# boot live ISO + empty qcow2, login etheris/etheris, then:
sudo etheris-installer --auto --disk /dev/vda --confirm YES \
  --user demo --password demo --keymap fi --fs ext4 --no-reboot
# Optional LUKS:
#   … --luks --luks-passphrase demo
```
