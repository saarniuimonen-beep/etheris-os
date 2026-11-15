# Etheris OS — Secure Boot plan (Alpha 0.3)

**Status:** Alpha deliverable **complete** as **unsupported** + probe harness — **not shipping signed Etheris keys**  
**Evidence:** `scripts/secure-boot-qemu-probe.sh` · `out/secure-boot-spike/RESULT.md`  
**Firmware on host:** `/usr/share/edk2/x64/OVMF_CODE.secboot.4m.fd`

---

## Reality check

- Archiso / custom kernels need either:
  - Distro/shim enrollment, or
  - User-enrolled Machine Owner Key (MOK), or
  - Vendor signing pipeline (cost + ops)
- Claiming “Secure Boot supported” without signed artifacts + hardware tests is dishonest.

---

## Phased approach

| Phase | Deliverable | Status |
|-------|-------------|--------|
| R0 | This document + inventory of unsigned artifacts (kernel, UKI?, bootloader) | **Done** |
| R1 | Document **manual** MOK enrollment for brave testers (unsupported) | **Done** (stance below) |
| R2 | QEMU OVMF Secure Boot probe harness | **Done** (unsigned ISO reaches boot menu; no signed boot claimed) |
| R3 | Decide: ship Etheris key (ops heavy) vs document “SB off / user keys” | **Decided for Alpha:** SB off / user keys only |
| R4 | Hardware matrix rows on ≥1 laptop with SB on | **Open** (needs DUT) |

---

## Recommended Alpha stance

- Product claim: Secure Boot **unsupported**.  
- Default: Secure Boot **off** or firmware “other OS”.  
- Brave testers may enroll their own MOK and sign locally — **unsupported**, no Etheris db keys.  
- Prefer documenting how to disable SB or enroll user keys over half-signed images.

### Manual MOK (unsupported sketch)

1. Generate keys with `sbctl create-keys` (or openssl).  
2. Enroll via `mokutil --import` / firmware Setup Mode.  
3. Sign systemd-boot + kernel/UKI with your key.  
4. Expect NVIDIA proprietary modules to fail without separate signing.

---

## Prototype checklist (QEMU)

- [x] OVMF Secure Boot firmware located (`OVMF_CODE.secboot.4m.fd`)  
- [x] Probe harness boots ISO under SB firmware (`secure-boot-qemu-probe.sh`)  
- [ ] Enroll test PK/KEK/db  
- [ ] Sign systemd-boot + kernel (or UKI)  
- [ ] Boot live + installed disk as **signed**  
- [ ] Record failure modes (unsigned module, DKMS NVIDIA, etc.)

---

## NVIDIA / third-party modules

Proprietary modules often break SB. Honest messaging: gaming NVIDIA + SB is a **special** path, not default Alpha.
