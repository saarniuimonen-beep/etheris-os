#!/usr/bin/env bash
# Etheris OS — rock-solid security criteria (stricter than P0 alone).
# See docs/SECURITY-CRITERIA.md
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
A="$ROOT/profile/etheris/airootfs"
OUT="$ROOT/out/security-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"

ok=0
fail=0
pass() { printf 'OK  %s\n' "$*"; ok=$((ok + 1)); }
bad() { printf 'FAIL %s\n' "$*"; fail=$((fail + 1)); }

echo "Etheris security criteria (rock-solid)"
echo "  criteria: docs/SECURITY-CRITERIA.md"
echo "  out:      $OUT"
echo

# ----- S0.1 P0 baseline -----
if "$ROOT/scripts/test-p0-security.sh" >"$OUT/s0-p0.txt" 2>&1; then
  if grep -qE 'Result:.*0 FAIL' "$OUT/s0-p0.txt"; then
    pass "S0.1 P0 security (0 FAIL)"
  else
    bad "S0.1 P0 unexpected summary"
  fi
else
  bad "S0.1 P0 security"
  tail -25 "$OUT/s0-p0.txt" | sed 's/^/  | /' || true
fi

# ----- S1.1 sshd masked -----
if [[ -L "$A/etc/systemd/system/sshd.service" ]] \
  && [[ "$(readlink "$A/etc/systemd/system/sshd.service")" == /dev/null ]]; then
  pass "S1.1 sshd.service masked → /dev/null"
else
  bad "S1.1 sshd.service not masked to /dev/null"
fi

# ----- S1.2 pacman SigLevel -----
if grep -qE '^SigLevel[[:space:]]*=[[:space:]]*Required' "$A/etc/pacman.conf"; then
  pass "S1.2 pacman SigLevel=Required"
else
  bad "S1.2 pacman SigLevel not Required"
fi

# ----- S1.3 Firefox telemetry off -----
FF="$A/etc/firefox/policies/policies.json"
if [[ -f "$FF" ]] \
  && grep -q '"DisableTelemetry"[[:space:]]*:[[:space:]]*true' "$FF" \
  && grep -q '"DisableFirefoxStudies"[[:space:]]*:[[:space:]]*true' "$FF"; then
  pass "S1.3 Firefox DisableTelemetry + DisableFirefoxStudies"
else
  bad "S1.3 Firefox policies missing telemetry/studies disable"
fi

# ----- S1.4 nftables drop in/forward; no :22 accept -----
NFT="$A/etc/nftables.conf"
if [[ -f "$NFT" ]] \
  && grep -E 'hook input' "$NFT" | grep -q 'policy drop' \
  && grep -E 'hook forward' "$NFT" | grep -q 'policy drop'; then
  pass "S1.4 nftables input+forward policy drop"
else
  bad "S1.4 nftables input/forward policy drop missing"
fi
if grep -E 'dport[[:space:]]*22|[[:space:]]22[[:space:]]*accept|tcp dport 22' "$NFT" >/dev/null 2>&1; then
  bad "S1.4 nftables accepts port 22"
else
  pass "S1.4 nftables has no port-22 accept"
fi

# ----- S1.5 Warpinator ports documented -----
if grep -q 'Warpinator' "$NFT" \
  && grep -q '42000' "$NFT" \
  && grep -q '5353' "$NFT"; then
  pass "S1.5 Warpinator/mDNS ports documented in nftables"
else
  bad "S1.5 Warpinator ports missing comments or rules"
fi

# ----- S1.6 sysctl -----
SYS="$A/etc/sysctl.d/99-etheris-security.conf"
need_sys=(kernel.kptr_restrict kernel.dmesg_restrict kernel.unprivileged_bpf_disabled net.ipv4.conf.all.rp_filter net.ipv4.tcp_syncookies)
sys_ok=1
for k in "${need_sys[@]}"; do
  grep -qE "^${k}[[:space:]]*=" "$SYS" 2>/dev/null || sys_ok=0
done
if ((sys_ok)) && [[ -f "$SYS" ]]; then
  pass "S1.6 sysctl hardening keys present"
else
  bad "S1.6 sysctl missing one of: ${need_sys[*]}"
fi

# ----- S1.7 no world-writable sensitive -----
ww="$(find "$A/etc/sudoers.d" "$A/usr/local/bin" \( -name 'shadow' -o -name 'shadow-*' \) -o -path "$A/etc/sudoers.d/*" -o -path "$A/usr/local/bin/*" 2>/dev/null \
  | while read -r f; do [[ -f "$f" && -w "$f" ]] || continue; perms=$(stat -c '%a' "$f"); [[ "${perms: -1}" != [2367] ]] || echo "$f"; done)"
# Simpler: find -perm -0002
ww2="$(find "$A/etc/sudoers.d" "$A/usr/local/bin" -type f -perm -0002 2>/dev/null || true)"
if [[ -z "${ww2}" ]]; then
  pass "S1.7 no world-writable under sudoers.d / usr/local/bin"
else
  bad "S1.7 world-writable: $ww2"
fi

# ----- S1.8 no private keys -----
if rg -l --glob '!**/docs/**' 'BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY' "$A" >/dev/null 2>&1; then
  bad "S1.8 private key material found in airootfs"
else
  pass "S1.8 no PEM/OpenSSH private keys in airootfs"
fi

# ----- S1.9 auth-check libxcrypt -----
AC="$A/usr/local/bin/etheris-auth-check"
if grep -q 'libcrypt' "$AC" && grep -q 'ctypes' "$AC"; then
  pass "S1.9 etheris-auth-check libxcrypt/ctypes path"
else
  bad "S1.9 etheris-auth-check missing libxcrypt/ctypes"
fi

# ----- S1.10 security as_root shadow -----
SEC="$A/usr/local/bin/etheris-security"
if grep -q 'as_root' "$SEC" && grep -q '/etc/shadow' "$SEC"; then
  pass "S1.10 etheris-security as_root for shadow"
else
  bad "S1.10 etheris-security missing as_root shadow handling"
fi

# ----- S1.11 doctor benign sr0 -----
DOC="$A/usr/local/bin/etheris-doctor"
if grep -q 'is_benign_failed_unit' "$DOC" && grep -q 'sr0\|block-sr' "$DOC"; then
  pass "S1.11 etheris-doctor benign systemd-loop@sr0"
else
  bad "S1.11 etheris-doctor missing benign sr0 handling"
fi

# ----- S1.12 polkit YES only etheris helpers; pacman = AUTH_ADMIN_KEEP -----
RULE="$A/usr/local/share/etheris/polkit/49-etheris-wheel.rules"
if [[ ! -f "$RULE" ]]; then
  bad "S1.12 polkit rules missing"
elif ! grep -q 'AUTH_ADMIN_KEEP' "$RULE" || ! grep -q '/usr/local/bin/etheris-' "$RULE"; then
  bad "S1.12 polkit missing AUTH_ADMIN_KEEP or etheris helper paths"
elif ! grep -A3 '/usr/bin/pacman' "$RULE" | grep -q 'AUTH_ADMIN_KEEP'; then
  bad "S1.12 pacman must use AUTH_ADMIN_KEEP (not YES)"
elif grep -B8 'Result.YES' "$RULE" | grep -qE 'pacman|/usr/bin/'; then
  # YES block must not mention pacman or arbitrary /usr/bin
  bad "S1.12 Result.YES appears tied to non-etheris /usr/bin path"
else
  pass "S1.12 polkit YES scoped; pacman AUTH_ADMIN_KEEP"
fi

# ----- S1.13 no chmod 777/666 in etheris bins -----
if rg -n --glob 'etheris*' '^[^#]*chmod[[:space:]]+(777|666)\b' "$A/usr/local/bin" >/dev/null 2>&1; then
  bad "S1.13 chmod 777/666 still present in etheris tools"
else
  pass "S1.13 no chmod 777/666 in etheris tools"
fi

# ----- S1.14 sudoers mode + installer strip -----
mode="$(stat -c '%a' "$A/etc/sudoers.d/etheris" 2>/dev/null || echo '?')"
if [[ "$mode" == "440" || "$mode" == "0440" ]] \
  && grep -q 'rm -f /etc/sudoers.d/etheris' "$A/usr/local/bin/etheris-installer" \
  && grep -q '%wheel ALL=(ALL:ALL) ALL' "$A/usr/local/bin/etheris-installer"; then
  pass "S1.14 live sudoers 440 + installer strip/password wheel"
else
  bad "S1.14 sudoers/installer privilege policy incomplete (mode=$mode)"
fi

# ----- S1.15 docs honesty -----
honest=1
for f in "$ROOT/docs/SECURITY.md" "$ROOT/docs/SECURE-BOOT-PLAN.md" "$ROOT/docs/SELINUX-STUDY.md"; do
  [[ -f "$f" ]] || { honest=0; break; }
done
if ((honest)) \
  && ! grep -qiE 'Secure Boot is supported|SELinux enforcing by default|fully hardened' "$ROOT/docs/SECURITY.md"; then
  pass "S1.15 security docs present; no false SB/SELinux supported claim"
else
  bad "S1.15 security docs missing or overclaim"
fi

# ----- S1.16 privacy.conf -----
PRIV="$A/etc/etheris/privacy.conf"
if [[ -f "$PRIV" ]] \
  && grep -q '^TELEMETRY=off' "$PRIV" \
  && grep -q '^ANALYTICS=off' "$PRIV" \
  && grep -q '^CRASH_REPORTS=off' "$PRIV"; then
  pass "S1.16 privacy.conf telemetry/analytics/crash off"
else
  bad "S1.16 privacy.conf incomplete"
fi

# ----- S1.17 auth-setup live + mask -----
UNIT="$A/etc/systemd/system/etheris-auth-setup.service"
if grep -q '^ConditionKernelCommandLine=archisobasedir$' "$UNIT" \
  && grep -q '^ConditionPathExists=/run/archiso$' "$UNIT" \
  && grep -q 'systemctl mask etheris-auth-setup' "$A/usr/local/bin/etheris-installer"; then
  pass "S1.17 auth-setup live Conditions + installer mask"
else
  bad "S1.17 auth-setup live/mask incomplete"
fi

# ----- S1.18 audit coverage in etheris-security -----
if grep -q 'as_root' "$SEC" \
  && grep -q 'policy drop' "$SEC" \
  && grep -q ':22' "$SEC" \
  && grep -q 'NOPASSWD' "$SEC" \
  && grep -q 'sshd' "$SEC" \
  && grep -q 'TELEMETRY=off' "$SEC" \
  && grep -q '99-etheris-security.conf\|sysctl security' "$SEC"; then
  pass "S1.18 etheris-security audit coverage (sshd/nft/22/sudoers/sysctl/telemetry)"
else
  bad "S1.18 etheris-security audit coverage incomplete"
fi

# ----- S2 ISO -----
ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi
if [[ -n "$ISO" && -f "$ISO" ]]; then
  if "$ROOT/scripts/validate-iso.sh" "$ISO" >"$OUT/s2-validate-iso.txt" 2>&1; then
    pass "S2.1 validate-iso ($(basename "$ISO"))"
  else
    bad "S2.1 validate-iso"
    tail -20 "$OUT/s2-validate-iso.txt" | sed 's/^/  | /' || true
  fi
else
  echo "SKIP S2 (no ISO)"
fi

# ----- S3 evidence (optional) -----
EVIDENCE="${ETHERIS_SECURITY_EVIDENCE:-}"
if [[ -z "$EVIDENCE" ]]; then
  EVIDENCE="$(/bin/ls -1t "$ROOT"/out/VERIFICATION-SECURITY-*.md 2>/dev/null | head -1 || true)"
fi
if [[ -n "$EVIDENCE" && -f "$EVIDENCE" ]]; then
  if grep -qiE 'Security criteria PASS|security criteria PASS|\*\*PASS\*\*' "$EVIDENCE" \
    && ! grep -qiE 'Security criteria FAIL|Verdict.*\*\*FAIL\*\*' "$EVIDENCE"; then
    if grep -qiE 'CONDITIONAL PASS' "$EVIDENCE"; then
      pass "S3-evidence $(basename "$EVIDENCE") (CONDITIONAL live OK)"
    else
      pass "S3-evidence $(basename "$EVIDENCE")"
    fi
  else
    echo "NOTE S3-evidence present but not a clear PASS: $(basename "$EVIDENCE")"
  fi
else
  echo "SKIP S3-evidence (no VERIFICATION-SECURITY-*.md yet)"
fi

{
  echo "# Security criteria run"
  echo
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- OK: $ok"
  echo "- FAIL: $fail"
  echo "- ISO: ${ISO:-none}"
  echo
  echo "See docs/SECURITY-CRITERIA.md."
} >"$OUT/SUMMARY.md"

echo
echo "Result: $ok OK, $fail FAIL"
echo "Summary: $OUT/SUMMARY.md"
if ((fail)); then
  echo "Security criteria FAILED"
  exit 1
fi
echo "Security criteria PASSED"
exit 0
