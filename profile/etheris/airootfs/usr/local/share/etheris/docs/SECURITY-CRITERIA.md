# Etheris OS — Security criteria (stricter / rock-solid)

**Rule:** Claim **security PASS** only when every **Must** below is green with evidence.  
**Not a penetration test.** Does not claim Secure Boot, SELinux, or LUKS-by-default.

**Runner:** `scripts/test-security.sh`  
**Baseline:** `scripts/test-p0-security.sh` (Must S0 — already expanded)  
**Related:** [`SECURITY.md`](SECURITY.md) · [`SECURITY-AUDIT.md`](SECURITY-AUDIT.md) · [`STABILITY-CRITERIA.md`](STABILITY-CRITERIA.md)

---

## Verdict levels

| Verdict | Meaning |
|---------|---------|
| **PASS** | All Must S0–S2 green (S3 live when evidence present) |
| **CONDITIONAL PASS** | S0–S2 green; S3 live fails only for known pre-rebake gaps |
| **FAIL** | Any Must S0–S2 red |

---

## Must S0 — P0 baseline (every PR)

| ID | Criterion |
|----|-----------|
| S0.1 | `test-p0-security.sh` → **0 FAIL** |

---

## Must S1 — Stricter tree (every PR / every bake)

| ID | Criterion |
|----|-----------|
| S1.1 | `sshd.service` **masked** (`→ /dev/null`) in airootfs |
| S1.2 | `pacman.conf` `SigLevel = Required` |
| S1.3 | Firefox policies: `DisableTelemetry` + `DisableFirefoxStudies` |
| S1.4 | nftables: input **and** forward `policy drop`; **no** accept on port 22 |
| S1.5 | Warpinator ports (42000/42001/5353) have explicit comments (intentional LAN) |
| S1.6 | sysctl drop-in: `kptr_restrict`, `dmesg_restrict`, `unprivileged_bpf_disabled`, `rp_filter`, `tcp_syncookies` |
| S1.7 | No world-writable files under `etc/sudoers.d`, `etc/shadow*`, `usr/local/bin` |
| S1.8 | No PEM/OpenSSH private keys in airootfs |
| S1.9 | `etheris-auth-check` uses libxcrypt/`ctypes` (Python 3.13-safe) |
| S1.10 | `etheris-security` uses `as_root` for `/etc/shadow` (no false FAIL) |
| S1.11 | `etheris-doctor` treats `systemd-loop@*sr0*` as benign WARN |
| S1.12 | Polkit `Result.YES` only for `/usr/local/bin/etheris-*` helpers (no blanket pacman YES) |
| S1.13 | No `chmod 777` / `chmod 666` in any `etheris*` tool under `usr/local/bin` |
| S1.14 | Live `sudoers.d/etheris` mode **440**; installer strips it + writes password wheel |
| S1.15 | Docs honesty: SECURITY.md / SB / LUKS plans do **not** claim SB or SELinux “supported” |
| S1.16 | `privacy.conf`: TELEMETRY/ANALYTICS/CRASH_REPORTS=off |
| S1.17 | Auth-setup unit: live Conditions + installer **mask** on install |
| S1.18 | `etheris-security audit` checks: sshd, nft drop, port 22, sudoers NOPASSWD trap, sysctl, telemetry |

---

## Must S2 — ISO artifact (when ISO present)

| ID | Criterion |
|----|-----------|
| S2.1 | `validate-iso.sh` 0 FAIL |
| S2.2 | Squashfs: nftables enabled · auth-check present (covered by validate-iso + S1 extract spot) |

---

## Must S3 — Live (KVM — every security bake)

| ID | Criterion | Pass rule |
|----|-----------|-----------|
| S3.1 | `etheris-auth-check` | 12 OK, 0 FAIL |
| S3.2 | `nftables` | `is-active` |
| S3.3 | `etheris-security audit` | 0 FAIL (with sudo -n / as_root) |
| S3.4 | No listener on port 22 | `ss` / audit |
| S3.5 | `sshd` not enabled | systemctl |
| S3.6 | Product-relevant failed units | none (benign sr0 WARN OK) |

---

## Must NOT claim without separate gates

- Secure Boot **supported**
- SELinux enforcing
- LUKS default-on
- “Impenetrable” / pentest-grade certification
- Physical evil-maid resistance

---

## Fix policy

1. Prefer **product fixes** in tree over weakening criteria.  
2. Re-run `./scripts/test-security.sh`.  
3. Live S3 gaps that need a rebake: mark **CONDITIONAL** and list the tree fix + bake SHA when closed.
