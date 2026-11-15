# Verification — Etheris OS maturity test (2026-11-15)

**ISO:** `out/etheris-2026.11.15-x86_64.iso`  
**SHA256:** `79106f8b47177585a113075d79153141e13ccbfd97363911768318e1ecb8b105`  
**Domain:** `etheris-os` @ `qemu:///session` (KVM)  
**Evidence:** `out/maturity-20261115T185050Z/`  
**Also:** prior LUKS install E2E `out/VERIFICATION-LUKS-E2E-20261115.md`

---

## Layer results

| Layer | Result | Notes |
|-------|--------|-------|
| L0 Static | **PASS** | `check-profile` PASSED · `test-p0-security` **30 OK** |
| L1 Artifact | **PASS** | `validate-iso.sh` **23 OK** |
| L2 Boot | **PASS** | UEFI CDROM → ReGreet ~90 s (`01-greeter.png`) |
| L3 Desktop | **PASS** w/ findings | Greeter → Waybar desktop · Super+A Menu · Super+D launcher · auth-check **12 OK** |
| L4 Install | **PASS** (prior) | LUKS E2E same-day |
| L5 Hardware | **N/A** | Physical DUT blocked (honest) |
| L6 Security extras | **Partial** | LUKS QEMU OK · SB unsupported · SELinux off |

---

## L3 checklist

| Check | Result | Evidence |
|-------|--------|----------|
| Password-first greeter | **PASS** | `01-greeter.png` — Password focused; Auto-selecting `Etheris (Sway)` |
| Login `etheris`/`etheris` → Sway+Waybar | **PASS** | `02-desktop.png` |
| Super+A Etheris Menu | **PASS** | `18-super-a.png` — Wired · Ocean Glass · Privacy/Apps |
| Super+D launcher | **PASS** | `19-super-d.png` — Search apps grid |
| `etheris-auth-check` | **PASS** | `10-auth-check.png` — **12 OK, 0 FAIL** |
| `nftables` active | **PASS** | doctor + `17-os-nft-perf.png` (active lines) |
| NetworkManager / avahi | **PASS** | active / enabled (CLI batch) |
| MOTD Sway-only | **PASS** | foot banner: `Sway · Etheris desktop` |
| `etheris.desktop` | **PASS** | `ETHERIS_DESKTOP_OK` |
| rgb tools 755 | **PASS** | `14-rgb-desktop.png` |
| hide-stock-sway / regreet-cache | **PASS** | both `active` |
| `etheris-menu-hover` | **PASS** | pid running |
| `etheris doctor` | **FAIL** | 6 OK / 2 FAIL / 2 WARN — see findings |

---

## Findings

### F1 — `etheris-perf.service` failed (**real**)

```
etheris-perf: line 10: HOME: unbound variable
```

Systemd oneshot runs with no `HOME`; script uses `set -u` + `$HOME`.  
**Fixed in tree** (`USER_CONF` uses `${HOME:-}`) — needs rebake for live ISO.

### F2 — `etheris doctor` security audit false FAIL

`etheris-security audit` reads `/etc/shadow` without elevation → “no password hash”.  
`etheris-auth-check` (sudo -n path) is the authoritative live gate: **12 OK**.

### F3 — `systemd-loop@…sr0` failed

VM CDROM loop attach noise; does not block desktop. Treat as WARN unless ruleset empty.

### F4 — `nft list ruleset` as user

Needs root; `systemctl is-active nftables` remains the smoke gate.

---

## Verdict

**Maturity smoke: CONDITIONAL PASS** on ISO `79106f8b…` (L0–L3 desktop Must green; doctor failed on this bake).

**Criteria + tree fixes (2026-11-15 later):** see [`MATURITY-CRITERIA.md`](../docs/MATURITY-CRITERIA.md) and [`VERIFICATION-MATURITY-CRITERIA-20261115.md`](VERIFICATION-MATURITY-CRITERIA-20261115.md).  
`scripts/maturity-check.sh` **PASSED**; F1–F3 fixed in tree — **rebake** to claim live doctor PASS (M3.6/M3.7).

**Not claimed:** physical GPU, Secure Boot supported, doctor exit 0 **on this ISO**.
