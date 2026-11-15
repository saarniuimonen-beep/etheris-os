# Verification — Alpha 0.2 Critical (tree + rebake + L1)

**Date:** 2026-11-15  
**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `37566bb8dce73bc2f2ef31ce29c331bf447b2e72e8d9f48e724a7ddabdb8d4d4`

## Source gates

| Gate | Result |
|------|--------|
| `scripts/prepare-profile.sh` | OK |
| `scripts/check-profile.sh` | **PASSED** (state.toml, tokens 28/0, blur=off) |
| `scripts/test-p0-security.sh` | **30 OK, 0 FAIL** |

## L1 ISO validation

```text
./scripts/validate-iso.sh out/etheris-2026.11.15-x86_64.iso
→ 15 OK, 0 FAIL — ISO validation PASSED
```

Includes: `skip_selection`, `state.toml` (`etheris` + `Etheris (Sway)`), doctor, tokens, skel blur=off, sway hidden, nftables, SHA256SUMS.

## Tree changes (this bake)

| Item | Status |
|------|--------|
| ReGreet `state.toml` seed (not cache.toml) | In ISO |
| `etheris doctor` / `etheris-doctor` | In ISO |
| Token SoT panel 28/0 + blur=off | In ISO |
| Installer `ETHERIS_INSTALL_GAMING` default **0** | In ISO |
| `scripts/validate-iso.sh` | Present |

## L3 greeter smoke (cold reset → live ISO)

Evidence: `out/qemu-alpha02-greeter-20261115/greeter-{1,2}.png`

| Check | Result | Notes |
|-------|--------|-------|
| Cold greeter password-first | **PASS** | Password field + focus; info `Auto-selecting session "Etheris (Sway)"` |
| No Session combo pre-Login | **PASS** | Contrast prior `out/qemu-reliability-smoke-20261115/fresh-greeter.png` (User+Session only) |
| User row still visible | Expected | ReGreet UI; typing password works without clicking Login |

Still open (optional follow-up): live `etheris doctor` + Super+A/D regression on this bake.

LUKS / Secure Boot / SELinux: **not in this bake** (deferred).
