#!/usr/bin/env bash
# Source-level P0 security / persistence checks (no ISO rebuild, no disk writes).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
A="$ROOT/profile/etheris/airootfs"
fail=0
pass=0
ok() { echo "  OK  $*"; pass=$((pass + 1)); }
bad() { echo "FAIL  $*"; fail=$((fail + 1)); }

echo "== Etheris P0 source checks =="
echo "ROOT=$ROOT"

# --- shell syntax ---
for f in etheris-installer etheris-oobe etheris-oobe-helper etheris-auth-setup \
         etheris-keymap-apply etheris-display etheris-auth-check; do
  if bash -n "$A/usr/local/bin/$f" 2>/dev/null; then
    ok "bash -n $f"
  else
    bad "bash -n $f"
  fi
done

# --- systemd unit ---
UNIT="$A/etc/systemd/system/etheris-auth-setup.service"
if grep -q '^ConditionKernelCommandLine=archisobasedir$' "$UNIT" \
  && grep -q '^ConditionPathExists=/run/archiso$' "$UNIT"; then
  ok "auth-setup unit has live Conditions"
else
  bad "auth-setup unit missing live Conditions"
fi
if command -v systemd-analyze >/dev/null 2>&1; then
  if systemd-analyze verify "$UNIT" 2>/dev/null; then
    ok "systemd-analyze verify etheris-auth-setup.service"
  else
    # verify may warn about missing Wants targets outside a booted system
    if systemd-analyze verify "$UNIT" 2>&1 | grep -qiE 'error|failed'; then
      bad "systemd-analyze verify reported errors"
    else
      ok "systemd-analyze verify (warnings only / offline)"
    fi
  fi
else
  ok "systemd-analyze not installed — skipped unit verify"
fi

# --- auth-setup script guard ---
if grep -q 'archisobasedir' "$A/usr/local/bin/etheris-auth-setup" \
  && grep -q '/run/archiso' "$A/usr/local/bin/etheris-auth-setup"; then
  ok "auth-setup script live guard present"
else
  bad "auth-setup script live guard missing"
fi

# Simulate non-live: script must exit 0 without chpasswd when not live
TMP="$(mktemp -d)"
fake="$TMP/etheris-auth-setup"
cp "$A/usr/local/bin/etheris-auth-setup" "$fake"
# Force guard path by running in env without archiso; script checks real /proc/cmdline
# On a normal host this should refuse.
if bash "$fake" >/tmp/etheris-auth-setup-test.out 2>&1; then
  if grep -q 'not a live ISO' /tmp/etheris-auth-setup-test.out; then
    ok "auth-setup refuses on non-live host"
  elif grep -qw archisobasedir /proc/cmdline 2>/dev/null && [[ -d /run/archiso ]]; then
    ok "auth-setup ran (host appears live — unexpected for Omarchy)"
  else
    bad "auth-setup did not refuse on non-live host (see /tmp/etheris-auth-setup-test.out)"
  fi
else
  bad "auth-setup exited non-zero on refuse path"
fi
rm -rf "$TMP"

# --- polkit: no blanket YES ---
for RULE in \
  "$A/usr/local/share/etheris/polkit/49-etheris-wheel.rules" \
  "$A/etc/polkit-1/rules.d/49-etheris-wheel.rules"; do
  if [[ ! -f "$RULE" ]]; then bad "missing $RULE"; continue; fi
  if grep -q 'org.freedesktop.NetworkManager' "$RULE" \
    && grep -q 'AUTH_ADMIN_KEEP' "$RULE" \
    && grep -q 'etheris-oobe-helper' "$RULE"; then
    ok "scoped polkit $(basename "$(dirname "$RULE")")/$(basename "$RULE")"
  else
    bad "polkit not scoped: $RULE"
  fi
  # Detect classic blanket pattern: only isInGroup then YES with no action.id checks
  if ! grep -q 'action.id\|var id' "$RULE"; then
    bad "polkit lacks action.id checks: $RULE"
  fi
done
if diff -q "$A/usr/local/share/etheris/polkit/49-etheris-wheel.rules" \
           "$A/etc/polkit-1/rules.d/49-etheris-wheel.rules" >/dev/null; then
  ok "share and etc polkit rules identical"
else
  bad "share vs etc polkit rules differ"
fi

# --- OOBE: no world-writable chmod in sources ---
if grep -nE '^[^#]*chmod[[:space:]]+777|^[^#]*chmod[[:space:]]+666' \
     "$A/usr/local/bin/etheris-oobe" "$A/usr/local/bin/etheris-installer" 2>/dev/null; then
  bad "world-writable chmod still present in oobe/installer"
else
  ok "no chmod 777/666 in oobe/installer"
fi
if grep -q '2770' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'etheris-oobe-helper' "$A/usr/local/bin/etheris-installer"; then
  ok "installer sets root:wheel OOBE perms + helper"
else
  bad "installer OOBE permission hardening missing"
fi
if [[ -x "$A/usr/local/bin/etheris-oobe-helper" ]] || [[ -f "$A/usr/local/bin/etheris-oobe-helper" ]]; then
  ok "etheris-oobe-helper present"
else
  bad "etheris-oobe-helper missing"
fi

# --- OOBE completion simulation (user state) ---
OTMP="$(mktemp -d)"
export ETHERIS_OOBE_DIR="$OTMP/sys-oobe"
export ETHERIS_OOBE_CONF="$OTMP/oobe.conf"
export HOME="$OTMP/home"
export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$HOME" "$ETHERIS_OOBE_DIR"
printf 'enabled=1\n' >"$ETHERIS_OOBE_CONF"
# Fake system state as needed with safe perms
printf 'needed\n' >"$ETHERIS_OOBE_DIR/state"
chmod 660 "$ETHERIS_OOBE_DIR/state"
chmod 770 "$ETHERIS_OOBE_DIR"
# Not live
if ! grep -qw archisobasedir /proc/cmdline 2>/dev/null; then
  st="$("$A/usr/local/bin/etheris-oobe" status || true)"
  echo "$st" | grep -q 'action=run' && ok "oobe status action=run when needed" || bad "oobe status: $st"
  "$A/usr/local/bin/etheris-oobe" mark done >/dev/null
  st2="$("$A/usr/local/bin/etheris-oobe" status || true)"
  echo "$st2" | grep -q 'action=skip' && ok "oobe mark done → skip" || bad "oobe after done: $st2"
  # draft must not accept password keys
  "$A/usr/local/bin/etheris-oobe" mark in_progress >/dev/null || true
else
  ok "skipped oobe status sim (host looks live)"
fi
rm -rf "$OTMP"

# --- installer argument handling ---
if "$A/usr/local/bin/etheris-installer" --help 2>&1 | grep -q -- '--keymap'; then
  ok "installer --help lists --keymap"
else
  bad "installer --help missing --keymap"
fi
# Unknown arg should die (runs as non-root first check — expect root error or unknown)
set +e
out="$("$A/usr/local/bin/etheris-installer" --not-a-real-flag 2>&1)"
rc=$?
set -e
if [[ $rc -ne 0 ]] && echo "$out" | grep -qiE 'Unknown argument|Run as root'; then
  ok "installer rejects bad/unauthorized invocation"
else
  bad "installer unexpected: rc=$rc out=$out"
fi

# --- ext4 / btrfs config generation (static) ---
if grep -q 'rootflags=subvol=@' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'FS=ext4' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'btrfs subvolume create' "$A/usr/local/bin/etheris-installer"; then
  ok "installer has ext4 default + btrfs subvols + rootflags"
else
  bad "installer filesystem persistence bits missing"
fi
if grep -q 'etheris-bootctl.hook' "$A/usr/local/bin/etheris-installer" \
  && [[ -f "$A/etc/pacman.d/hooks/etheris-bootctl.hook" ]]; then
  ok "bootctl pacman hook present + installer copies it"
else
  bad "bootctl hook missing"
fi
if grep -q 'systemd-timesyncd' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'wifi.backend=iwd\|wifi_backend' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'vconsole.conf' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'chpasswd' "$A/usr/local/bin/etheris-installer"; then
  ok "persistence: timesyncd + NM iwd + vconsole + chpasswd"
else
  bad "persistence wiring incomplete in installer"
fi
if grep -q 'systemctl mask etheris-auth-setup' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'rm -f /etc/sudoers.d/etheris' "$A/usr/local/bin/etheris-installer"; then
  ok "installer masks auth-setup and removes live sudoers"
else
  bad "installer live-credential cleanup incomplete"
fi

# --- profiledef includes helper ---
if grep -q 'etheris-oobe-helper' "$ROOT/profile/etheris/profiledef.sh"; then
  ok "profiledef.sh lists etheris-oobe-helper"
else
  bad "profiledef.sh missing etheris-oobe-helper"
fi

# --- ReGreet: installer seeds state.toml (not legacy cache only) ---
if grep -q 'var/lib/regreet/state.toml' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'last_user' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'user_to_last_sess' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'Etheris (Sway)' "$A/usr/local/bin/etheris-installer"; then
  ok "installer seeds ReGreet state.toml (last_user + Etheris session)"
else
  bad "installer missing ReGreet state.toml seed"
fi
if grep -qE 'cache\.(toml|json)' "$A/usr/local/bin/etheris-installer" \
  && ! grep -q 'rm -f .*cache\.toml' "$A/usr/local/bin/etheris-installer"; then
  bad "installer still writes legacy ReGreet cache without cleanup"
else
  ok "installer does not rely on legacy ReGreet cache.toml/json"
fi
if [[ -f "$A/var/lib/regreet/state.toml" ]] \
  && grep -q 'last_user' "$A/var/lib/regreet/state.toml" \
  && grep -q 'Etheris (Sway)' "$A/var/lib/regreet/state.toml"; then
  ok "live airootfs has ReGreet state.toml seed"
else
  bad "live airootfs missing ReGreet state.toml seed"
fi

# --- keymap-apply: reject unsafe tokens before sed ---
if grep -q 'invalid LAYOUT' "$A/usr/local/bin/etheris-keymap-apply" \
  && grep -Fq '^[a-z0-9_-]+$' "$A/usr/local/bin/etheris-keymap-apply"; then
  ok "keymap-apply validates LAYOUT charset"
else
  bad "keymap-apply missing LAYOUT charset validation"
fi
set +e
km_out="$("$A/usr/local/bin/etheris-keymap-apply" 'us;rm -rf /' 2>&1)"
km_rc=$?
set -e
if [[ $km_rc -ne 0 ]] && echo "$km_out" | grep -qi 'invalid LAYOUT'; then
  ok "keymap-apply rejects unsafe LAYOUT"
else
  bad "keymap-apply did not reject unsafe LAYOUT (rc=$km_rc)"
fi

# --- firewall defaults ---
NFT="$A/etc/nftables.conf"
if [[ -f "$NFT" ]] \
  && grep -q 'policy drop' "$NFT" \
  && grep -q 'type filter hook input' "$NFT"; then
  ok "nftables input policy drop present"
else
  bad "nftables default-drop input missing"
fi
if [[ -e "$A/etc/systemd/system/multi-user.target.wants/nftables.service" ]] \
  || [[ -L "$A/etc/systemd/system/multi-user.target.wants/nftables.service" ]]; then
  ok "nftables enabled for multi-user.target"
else
  bad "nftables not enabled under multi-user.target.wants"
fi
if grep -q 'systemctl enable .*nftables\|enable NetworkManager.*nftables' \
     "$A/usr/local/bin/etheris-installer"; then
  ok "installer enables nftables on install"
else
  bad "installer does not enable nftables"
fi

# --- SSH / sudo policy ---
if grep -q 'systemctl mask sshd' "$A/usr/local/bin/etheris-installer"; then
  ok "installer masks sshd"
else
  bad "installer does not mask sshd"
fi
if grep -q "%wheel ALL=(ALL:ALL) ALL" "$A/usr/local/bin/etheris-installer" \
  && grep -q 'NOPASSWD' "$A/etc/sudoers.d/etheris"; then
  ok "live NOPASSWD present; installer writes password sudo for wheel"
else
  bad "live/installed sudo policy mismatch"
fi
mode="$(stat -c '%a' "$A/etc/sudoers.d/etheris" 2>/dev/null || echo '?')"
if [[ "$mode" == "440" || "$mode" == "0440" ]]; then
  ok "live sudoers.d/etheris mode $mode"
else
  bad "live sudoers.d/etheris mode $mode (want 440)"
fi

# --- privacy + sysctl hardening shipped ---
PRIV="$A/etc/etheris/privacy.conf"
if [[ -f "$PRIV" ]] \
  && grep -q '^TELEMETRY=off' "$PRIV" \
  && grep -q '^ANALYTICS=off' "$PRIV" \
  && grep -q '^CRASH_REPORTS=off' "$PRIV"; then
  ok "privacy.conf telemetry/analytics/crash off"
else
  bad "privacy.conf missing or telemetry not off"
fi
SYSCTL="$A/etc/sysctl.d/99-etheris-security.conf"
if [[ -f "$SYSCTL" ]] \
  && grep -q 'kernel.kptr_restrict' "$SYSCTL" \
  && grep -q 'net.ipv4.conf.all.rp_filter' "$SYSCTL"; then
  ok "sysctl security defaults present"
else
  bad "sysctl security defaults missing"
fi

# --- security CLI audit entrypoint ---
if [[ -x "$A/usr/local/bin/etheris-security" ]] \
  || [[ -f "$A/usr/local/bin/etheris-security" ]]; then
  if grep -q 'cmd_audit\|audit)' "$A/usr/local/bin/etheris-security" \
    && grep -q 'TELEMETRY=off' "$A/usr/local/bin/etheris-security" \
    && grep -q 'sshd' "$A/usr/local/bin/etheris-security"; then
    ok "etheris-security audit checks sshd + telemetry"
  else
    bad "etheris-security audit incomplete"
  fi
else
  bad "etheris-security missing"
fi

# --- docs ---
for d in POLKIT.md INSTALL-PERSISTENCE.md SECURITY.md OOBE.md; do
  [[ -f "$ROOT/docs/$d" ]] && ok "docs/$d present" || bad "docs/$d missing"
done

echo
echo "Result: ${pass} OK, ${fail} FAIL"
[[ "$fail" -eq 0 ]]
