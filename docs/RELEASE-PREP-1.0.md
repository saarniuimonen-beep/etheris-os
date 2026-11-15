# Etheris OS — Release preparation toward 1.0

**Status:** Checklist scaffold (Beta → 1.0)  
**Do not** ship 1.0 until Critical security/reliability gates below are honest PASSes.

---

## Product gates

- [x] Alpha 0.2 reliability items green on ISO `79106f8b…` (validate 23 OK + greeter)  
- [x] Optional LUKS QEMU E2E (`out/VERIFICATION-LUKS-E2E-20261115.md`) — default still unencrypted  
- [x] Secure Boot stance documented (**unsupported**; secboot OVMF probe harness)  
- [x] Update recovery docs + locks (`UPDATE-RECOVERY.md`)  
- [ ] Hardware matrix: ≥3 **Etheris-on-DUT** physical GPU rows (host inventory ≠ guest proof) — **BLOCKED** no DUT  
- [x] Privacy policy + dashboard CLI reviewed  
- [x] Software Center / package groups usable (CLI + GTK; no AUR in store)  

---

## Engineering gates

- [x] `validate-iso.sh` on bake `79106f8b…` (23 OK) — re-run every publish artifact  
- [x] P0 green (30 OK, 2026-11-15 re-run)  
- [x] Build image pin recorded (`out/build-image.pin`)  
- [x] SHA256SUMS present for current ISOs  
- [ ] Release notes for a named Beta/1.0 cut  
- [ ] [`PUBLISH-APPROVAL.md`](PUBLISH-APPROVAL.md) signed off  

---

## Docs gates

- [x] LUKS/SB/SELinux claims match verification (LUKS QEMU only; SB unsupported; SELinux off)  
- [x] CHANNELS + SECURITY-UPDATES current  
- [ ] README install path final pass before public cut  

---

## Channel soak

- [x] Automation: `scripts/channel-validate.sh` + `channel-soak.sh` scaffold (`out/channel-soak-20261115T183848Z/`)  
- [ ] Operator multi-day `rc` soak (manual checklist in soak OUT)

---

## Version naming

Follow [`RELEASE-POLICY.md`](RELEASE-POLICY.md). Alpha/Beta labels must remain until physical HW + publish approval clear. **Do not ship 1.0 yet.**
