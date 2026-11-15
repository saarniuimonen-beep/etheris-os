# Verification — Stability criteria + fixes (2026-11-15)

## Criteria added

| Artifact | Role |
|----------|------|
| [`docs/STABILITY-CRITERIA.md`](../docs/STABILITY-CRITERIA.md) | Must IDs A1–A9 (host) · B1–B11 (live) |
| [`scripts/test-stability.sh`](../scripts/test-stability.sh) | Enforces A-gates + B-evidence |
| `check-profile.sh` | A3–A5 keybinds · Menu chip · browser scratchpad hygiene |

## Host run

```text
OK  A1 check-profile
OK  A2 P0 security (0 FAIL)
OK  A8 channel Archive DBs
OK  A9 validate-iso (etheris-2026.11.15-x86_64.iso)
OK  B-evidence report present (VERIFICATION-STABILITY-20261115.md)
Result: 5 OK, 0 FAIL
Stability criteria PASSED
```

Log: `out/stability-20261115T192309Z/` · `out/stability-criteria-run.txt`

## Product fixes (so criteria can pass on next bake)

| Issue | Fix in tree |
|-------|-------------|
| Super+A/D / Menu chip not gated | `check-profile.sh` Must A3–A5 |
| Firefox preload can leave a visible window (B11) | `etheris-browser` `firefox_visible_on_ws` + scratchpad retries |
| Maturity F1 `etheris-perf` HOME unbound | already `${HOME:-}` + unit `Environment=HOME=/root` |
| Maturity F2 security audit false FAIL | already `as_root` shadow / SKIP |
| Maturity F3 doctor `systemd-loop@sr0` | already benign WARN |
| Automation typing `$ ? >` | `libvirt-keys.sh` extended |

## Live ISO note

Bake `79106f8b…` still carries pre-fix `etheris-security` / browser until **rebake**. Host A-gates + prior live stability smoke evidence are PASS. Clean live `etheris doctor` / B11 need the next ISO.

## Verdict

**Stability criteria PASS** (host A + B-evidence). Tree fixes landed for remaining live doctor/preload gaps.
