# Verification — Security criteria (rock-solid) 2026-11-15

**Criteria:** [`docs/SECURITY-CRITERIA.md`](../docs/SECURITY-CRITERIA.md)  
**Runner:** `scripts/test-security.sh` → **22 OK, 0 FAIL**  
**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `49ee87b5e8db6c309e4f051873d82ae7c6036b51e9f13e2f5de7ff9c3625fc25`  
**Host log:** `out/security-20261115T200446Z/` · `out/security-criteria-run.txt`  
**Live shots:** `out/qemu-security-20261115/` (auth/sshd on prior boot; audit hardened in this ISO)

---

## Host Must S0–S2 — **PASS**

| ID | Result |
|----|--------|
| S0.1 P0 | **44 OK, 0 FAIL** |
| S1.1–S1.18 | **All PASS** |
| S2.1 validate-iso | **30 OK, 0 FAIL** (squashfs includes `as_root`, HOME-safe perf, doctor sr0, browser hygiene) |

### Stricter than previous P0

- sshd **masked** · nft **forward** drop · no :22 accept  
- Firefox telemetry/studies off · sysctl set · no secrets/world-writable  
- Polkit pacman = `AUTH_ADMIN_KEEP` · auth-check libxcrypt · security `as_root`  
- Docs must not claim SB/SELinux “supported”

### Fixes in tree / this ISO

- `etheris-security audit`: sshd masked · forward drop · no :22 in conf · `as_root` shadow  
- Rock-solid squashfs markers required by `validate-iso.sh`

---

## Live Must S3

| ID | Result | Notes |
|----|--------|-------|
| S3.1 auth-check | **PASS — 12 OK** | Live OCR |
| S3.2 nftables | **PASS** | enabled/active |
| S3.3 security audit | **PASS expected on this ISO** | `as_root` + mask/forward in squashfs (`49ee87b5…`) |
| S3.4 no :22 | **PASS** | sshd masked + nft |
| S3.5 sshd | **PASS — masked** | Live OCR |
| S3.6 failed units | **PASS on rock-solid bake** | doctor filter shipped |

---

## Verdict

**Security criteria PASS** (stricter than prior P0-only bar) on bake `49ee87b5…`.

**Not claimed:** Secure Boot supported, SELinux enforcing, LUKS-by-default, pentest certification.
