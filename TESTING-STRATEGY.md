# Etheris OS — Testing Strategy

**Date:** 2026-11-15  
**Principle:** Do not claim PASS without evidence. Prefer QEMU/KVM; physical for GPU/Wi-Fi/suspend.

---

## 1. Layers

| Layer | What | Gate |
|-------|------|------|
| L0 Static | `bash -n`, `py_compile`, `check-profile.sh`, `test-p0-security.sh` | CI on every PR |
| L1 Artifact | Post-bake squashfs spot-checks (sessions, polkit, menus, cache) | Every ISO |
| L2 Boot smoke | `scripts/test-iso-smoke.sh` + libvirt live boot screenshots | Every ISO |
| L3 Desktop smoke | Login, Waybar, Super+A Menu / Super+D launcher, auth-check, nftables | Every reliability bake |
| L3b Stability | [`STABILITY-CRITERIA.md`](STABILITY-CRITERIA.md) via `scripts/test-stability.sh` | Every stability / release-prep bake |
| L4 Install E2E | `--auto` install + cold reboot persistence matrix | Before claiming installer changes done |
| L5 Hardware | Matrix in HARDWARE-TEST-MATRIX.md | Before hardware claims |
| L6 Security features | LUKS/SB/SELinux when implemented | Dedicated plans |

Existing evidence lives under `out/VERIFICATION-*.md` and `out/qemu-*/`.

---

## 2. Mandatory ISO checklist (Alpha 0.2)

Automate where possible:

1. **L1:** `scripts/validate-iso.sh` — squashfs gates (skip_selection, `state.toml`, sessions, tokens 28/0, blur=off, doctor, SHA256)  
2. ISO boots (UEFI) — `scripts/test-iso-smoke.sh`  
3. ReGreet password-first (stock Sway hidden)  
4. Login `etheris`/`etheris` → Sway+Waybar  
5. `etheris doctor` / `etheris-auth-check` → 0 FAIL  
6. `systemctl is-active nftables`  
7. Super+A opens Etheris Menu (control-center); Super+D opens launcher  
8. No product-relevant failed units (`systemd-loop@*` WARN only)  
9. hide-stock-sway + regreet-cache active  
10. `scripts/test-stability.sh` host A-gates green  

**Reliability gate:** formal Must IDs in [`RELIABILITY-CRITERIA.md`](RELIABILITY-CRITERIA.md); host runner `scripts/reliability-check.sh` (L0/L1 + tree).  
**Maturity gate:** [`MATURITY-CRITERIA.md`](MATURITY-CRITERIA.md) · `scripts/maturity-check.sh`. Live R2/R3 / M2/M3 need QEMU screenshots.  
**Stability gate:** [`STABILITY-CRITERIA.md`](STABILITY-CRITERIA.md) · `scripts/test-stability.sh` (host A-gates + B-evidence).  
**Security gate:** [`SECURITY-CRITERIA.md`](SECURITY-CRITERIA.md) · `scripts/test-security.sh` (stricter than P0; S0–S2 host + S3 live).

---

## 3. Installer tests

| Case | Tooling |
|------|---------|
| ext4 auto install | `out/e2e-persist-harness/` + virsh |
| btrfs + rootflags | Same |
| Persistence gates | [`INSTALL-PERSISTENCE.md`](INSTALL-PERSISTENCE.md) |
| LUKS (future) | New matrix: unlock, fail passphrase, resume |
| Interrupted install | Documented manual procedure first |

---

## 4. Update / recovery tests (future-critical)

- Channel switch stable↔rc  
- Interrupted `pacman -Syu` recovery guidance  
- Mirrorlist previous snapshot restore  
- Kernel + bootloader after update (bootctl hook)  
- Snapshot rollback when Btrfs UX exists  

---

## 5. Desktop / Neo-Aero tests

- Theme switch dark/light  
- Contrast screenshots on two wallpapers  
- Reduced motion on  
- Keyboard-only Menu/launcher  
- Greeter password-first (when fixed)  

---

## 6. CI recommendations

| Job | Now | Next |
|-----|-----|------|
| source-checks.yml | Yes | Keep |
| ShellCheck / shfmt | No | Add non-blocking then blocking |
| Bats for installer argument parsing | No | High value, fast |
| KVM ISO smoke in CI | No | Needs nested virt runners — optional nightly on owner hardware |

---

## 7. Privacy rules for reports

Future `etheris report create` must exclude passwords, tokens, private keys, full `$HOME`, and redact MACs/usernames when requested. Sharing requires explicit user action.

---

## 8. Honesty rule

If a test was not run, status is **Unverified** — never “Verified” in IMPLEMENTATION-STATUS or release notes.
