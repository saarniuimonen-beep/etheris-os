# Etheris OS — Reliability rock-solid claim

**Date:** 2026-11-15  
**ISO SHA256:** `49ee87b5e8db6c309e4f051873d82ae7c6036b51e9f13e2f5de7ff9c3625fc25`  
**Primary evidence:** [`VERIFICATION-STABILITY-ROCKSOLID-20261115.md`](VERIFICATION-STABILITY-ROCKSOLID-20261115.md)  
**QEMU shots:** `out/qemu-rocksolid-20261115T195200Z/`

**Verdict: ROCK-SOLID PASS**

- Host: `reliability-check.sh` → 21 OK, 0 FAIL (includes validate-iso R1.2).
- Live: A+B+R / Must+RR satisfied on shipped ISO with **no guest-apply**.
- Stricter soak: ×15 Menu/launcher; auth triple + second-boot auth; swap 0; MemUsed ≤1.8 GiB.
