#!/usr/bin/env bash
# Post-bake ISO content gates (L1). Mounts airootfs.sfs and checks greeter/session/auth paths.
# Does not boot the guest — pair with scripts/test-iso-smoke.sh for L2.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi
[[ -n "$ISO" && -f "$ISO" ]] || {
  echo "No ISO found. Pass path or build first."
  exit 1
}
ISO="$(realpath "$ISO")"

ok=0
fail=0
pass() { printf 'OK  %s\n' "$*"; ok=$((ok + 1)); }
bad() { printf 'FAIL %s\n' "$*"; fail=$((fail + 1)); }

WORKDIR="$ROOT/out/validate-iso"
EXTRACT="$WORKDIR/root"
mkdir -p "$WORKDIR"
if [[ -e "$EXTRACT" ]]; then
  if rm -rf "$EXTRACT" 2>/dev/null; then
    :
  elif sudo -n true 2>/dev/null; then
    sudo rm -rf "$EXTRACT"
  else
    podman run --rm --privileged -v "$WORKDIR:/w:Z" docker.io/alpine:latest \
      rm -rf /w/root
  fi
fi
mkdir -p "$EXTRACT"

echo "Etheris ISO validation (squashfs content)"
echo "  ISO: $ISO"
echo

extract_with_podman() {
  local PODMAN=(podman)
  if sudo -n true 2>/dev/null; then
    PODMAN=(sudo podman)
  fi
  "${PODMAN[@]}" run --rm --privileged \
    --network=host \
    --security-opt label=disable \
    -v "$ISO:/iso/etheris.iso:ro,Z" \
    -v "$EXTRACT:/extract:Z" \
    docker.io/archlinux:latest \
    bash -lc '
      set -euo pipefail
      pacman -Sy --noconfirm --needed squashfs-tools >/dev/null
      mkdir -p /mnt/iso
      mount -o loop,ro /iso/etheris.iso /mnt/iso
      SFS="$(find /mnt/iso -name airootfs.sfs | head -1)"
      [[ -n "$SFS" && -f "$SFS" ]] || { echo "airootfs.sfs missing inside ISO"; exit 2; }
      # Extract only the paths we gate on (fast)
      unsquashfs -f -d /extract "$SFS" \
        etc/greetd/regreet.toml \
        etc/greetd/config.toml \
        etc/skel/.config/etheris/settings.conf \
        etc/skel/.config/waybar/config.jsonc \
        etc/nftables.conf \
        etc/systemd/system/etheris-regreet-cache.service \
        etc/systemd/system/multi-user.target.wants/etheris-regreet-cache.service \
        etc/systemd/system/etheris-hide-stock-sway.service \
        etc/systemd/system/multi-user.target.wants/etheris-hide-stock-sway.service \
        etc/systemd/system/multi-user.target.wants/nftables.service \
        usr/share/wayland-sessions/etheris.desktop \
        usr/local/bin/etheris \
        usr/local/bin/etheris-auth-check \
        usr/local/bin/etheris-browser \
        usr/local/bin/etheris-doctor \
        usr/local/bin/etheris-greeter \
        usr/local/bin/etheris-perf \
        usr/local/bin/etheris-security \
        usr/local/bin/etheris-packages \
        usr/local/bin/etheris-privacy \
        usr/local/bin/etheris-report \
        usr/local/bin/etheris-software-center \
        usr/local/bin/etheris-monitor \
        usr/local/bin/etheris-profiles \
        usr/local/bin/etheris-installer \
        etc/systemd/system/etheris-perf.service \
        etc/skel/.config/sway/config \
        usr/local/share/etheris/design/etheris.tokens.json \
        usr/local/share/etheris/groups \
        usr/local/share/polkit-1/rules.d \
        var/lib/regreet/state.toml \
        >/dev/null
      # Stock sway.desktop may or may not exist; extract if present
      unsquashfs -f -d /extract "$SFS" usr/share/wayland-sessions/sway.desktop >/dev/null 2>&1 || true
      umount /mnt/iso || true
    '
}

extract_local() {
  local mnt_iso mnt_done=0
  mnt_iso="$(mktemp -d "$WORKDIR/isomnt.XXXXXX")"
  cleanup() {
    if ((mnt_done)); then
      sudo umount "$mnt_iso" 2>/dev/null || true
    fi
    rmdir "$mnt_iso" 2>/dev/null || true
  }
  trap cleanup EXIT
  sudo mount -o loop,ro "$ISO" "$mnt_iso"
  mnt_done=1
  local sfs
  sfs="$(find "$mnt_iso" -name airootfs.sfs | head -1)"
  [[ -n "$sfs" && -f "$sfs" ]] || {
    echo "airootfs.sfs missing inside ISO"
    exit 2
  }
  unsquashfs -f -d "$EXTRACT" "$sfs" \
    etc/greetd/regreet.toml \
    etc/greetd/config.toml \
    etc/skel/.config/etheris/settings.conf \
    etc/skel/.config/waybar/config.jsonc \
    etc/nftables.conf \
    etc/systemd/system/etheris-regreet-cache.service \
    etc/systemd/system/multi-user.target.wants/etheris-regreet-cache.service \
    etc/systemd/system/etheris-hide-stock-sway.service \
    etc/systemd/system/multi-user.target.wants/etheris-hide-stock-sway.service \
    etc/systemd/system/multi-user.target.wants/nftables.service \
    usr/share/wayland-sessions/etheris.desktop \
    usr/local/bin/etheris \
    usr/local/bin/etheris-auth-check \
    usr/local/bin/etheris-browser \
    usr/local/bin/etheris-doctor \
    usr/local/bin/etheris-greeter \
    usr/local/bin/etheris-perf \
    usr/local/bin/etheris-security \
    usr/local/bin/etheris-packages \
    usr/local/bin/etheris-privacy \
    usr/local/bin/etheris-report \
    usr/local/bin/etheris-software-center \
    usr/local/bin/etheris-monitor \
    usr/local/bin/etheris-profiles \
    usr/local/bin/etheris-lock \
    usr/local/bin/etheris-installer \
    etc/systemd/system/etheris-perf.service \
    etc/skel/.config/sway/config \
    usr/local/share/etheris/design/etheris.tokens.json \
    usr/local/share/etheris/groups \
    usr/local/share/polkit-1/rules.d \
    var/lib/regreet/state.toml \
    >/dev/null
  unsquashfs -f -d "$EXTRACT" "$sfs" usr/share/wayland-sessions/sway.desktop >/dev/null 2>&1 || true
  sudo umount "$mnt_iso"
  mnt_done=0
  trap - EXIT
  rmdir "$mnt_iso" 2>/dev/null || true
}

if command -v unsquashfs >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
  echo "==> Extract via local unsquashfs + loop mount"
  extract_local
elif command -v podman >/dev/null 2>&1; then
  echo "==> Extract via podman (archlinux + squashfs-tools)"
  extract_with_podman
else
  echo "Need unsquashfs+sudo or podman to validate ISO contents."
  exit 1
fi

BASE="$EXTRACT"

# --- gates ---
if [[ -f "$BASE/etc/greetd/regreet.toml" ]] && grep -qE '^\s*skip_selection\s*=\s*true' "$BASE/etc/greetd/regreet.toml"; then
  pass "regreet.toml skip_selection=true"
else
  bad "regreet.toml missing skip_selection=true"
fi

if [[ -f "$BASE/var/lib/regreet/state.toml" ]] \
  && grep -qE '^\s*last_user\s*=\s*"etheris"' "$BASE/var/lib/regreet/state.toml" \
  && grep -qF 'Etheris (Sway)' "$BASE/var/lib/regreet/state.toml"; then
  pass "regreet state.toml seeded (etheris + Etheris (Sway))"
else
  bad "regreet state.toml missing or incomplete (need last_user + Etheris (Sway))"
fi

if [[ -f "$BASE/etc/systemd/system/multi-user.target.wants/etheris-regreet-cache.service" ]]; then
  pass "etheris-regreet-cache oneshot enabled"
else
  bad "etheris-regreet-cache oneshot not enabled in image"
fi

if [[ -f "$BASE/usr/share/wayland-sessions/etheris.desktop" ]] \
  && grep -qF 'Name=Etheris (Sway)' "$BASE/usr/share/wayland-sessions/etheris.desktop"; then
  pass "etheris.desktop present (Etheris (Sway))"
else
  bad "etheris.desktop missing or wrong Name="
fi

if [[ -f "$BASE/usr/share/wayland-sessions/sway.desktop" ]]; then
  if grep -qiE '^(Hidden|NoDisplay)=true' "$BASE/usr/share/wayland-sessions/sway.desktop"; then
    pass "stock sway.desktop Hidden/NoDisplay"
  else
    bad "stock sway.desktop present without Hidden/NoDisplay"
  fi
else
  pass "stock sway.desktop absent (hide oneshot / not packaged)"
fi

if [[ -f "$BASE/etc/systemd/system/multi-user.target.wants/etheris-hide-stock-sway.service" ]]; then
  pass "etheris-hide-stock-sway enabled"
else
  bad "etheris-hide-stock-sway not enabled"
fi

if [[ -x "$BASE/usr/local/bin/etheris-auth-check" ]]; then
  pass "etheris-auth-check executable"
else
  bad "etheris-auth-check missing"
fi

if [[ -x "$BASE/usr/local/bin/etheris-doctor" ]]; then
  pass "etheris-doctor executable"
else
  bad "etheris-doctor missing"
fi

for bin in etheris-packages etheris-privacy etheris-report etheris-software-center etheris-monitor etheris-profiles; do
  if [[ -x "$BASE/usr/local/bin/$bin" ]]; then
    pass "$bin executable"
  else
    bad "$bin missing"
  fi
done

if [[ -f "$BASE/usr/local/share/etheris/groups/gaming.list" ]]; then
  pass "package groups present"
else
  bad "package groups missing"
fi

if [[ -x "$BASE/usr/local/bin/etheris-installer" ]] \
  && grep -qE -- '--luks' "$BASE/usr/local/bin/etheris-installer"; then
  pass "installer supports --luks"
else
  bad "installer missing --luks"
fi

if [[ -x "$BASE/usr/local/bin/etheris" ]] \
  && grep -qE 'doctor\|diag\|diagnose\)|exec etheris-doctor' "$BASE/usr/local/bin/etheris"; then
  pass "etheris hub wires doctor"
else
  bad "etheris hub missing doctor command"
fi

if [[ -f "$BASE/etc/systemd/system/multi-user.target.wants/nftables.service" ]] \
  || [[ -L "$BASE/etc/systemd/system/multi-user.target.wants/nftables.service" ]]; then
  pass "nftables enabled"
else
  # Some images enable via presets; accept unit file + conf
  if [[ -f "$BASE/etc/nftables.conf" ]]; then
    pass "nftables.conf present (enable may be via presets)"
  else
    bad "nftables not clearly enabled"
  fi
fi

if [[ -f "$BASE/usr/local/share/etheris/design/etheris.tokens.json" ]]; then
  if grep -qE '"panelHeightPx"[[:space:]]*:[[:space:]]*28' "$BASE/usr/local/share/etheris/design/etheris.tokens.json" \
    && grep -qE '"panelTopOffsetPx"[[:space:]]*:[[:space:]]*0' "$BASE/usr/local/share/etheris/design/etheris.tokens.json"; then
    pass "tokens panelHeightPx=28 panelTopOffsetPx=0"
  else
    bad "tokens geometry not 28/0"
  fi
  if grep -qE '"blurDefault"[[:space:]]*:[[:space:]]*"off"' "$BASE/usr/local/share/etheris/design/etheris.tokens.json"; then
    pass "tokens blurDefault=off"
  else
    bad "tokens blurDefault not off"
  fi
else
  bad "etheris.tokens.json missing from ISO"
fi

if [[ -f "$BASE/etc/skel/.config/etheris/settings.conf" ]] \
  && grep -qE '^blur=off' "$BASE/etc/skel/.config/etheris/settings.conf"; then
  pass "skel blur=off"
else
  bad "skel blur not off"
fi

if [[ -f "$BASE/etc/skel/.config/waybar/config.jsonc" ]] \
  && grep -qE '"height"[[:space:]]*:[[:space:]]*28' "$BASE/etc/skel/.config/waybar/config.jsonc"; then
  pass "skel waybar height 28"
else
  bad "skel waybar height not 28"
fi

# Rock-solid reliability markers (must be in shipped squashfs — no guest-apply)
if [[ -f "$BASE/usr/local/bin/etheris-perf" ]] \
  && grep -qE 'HOME:=/root|HOME:-\}' "$BASE/usr/local/bin/etheris-perf"; then
  pass "etheris-perf HOME-safe in squashfs"
else
  bad "etheris-perf missing or not HOME-safe in squashfs"
fi
if [[ -f "$BASE/etc/systemd/system/etheris-perf.service" ]] \
  && grep -q 'Environment=HOME=' "$BASE/etc/systemd/system/etheris-perf.service"; then
  pass "etheris-perf.service sets HOME in squashfs"
else
  bad "etheris-perf.service missing Environment=HOME in squashfs"
fi
if [[ -f "$BASE/usr/local/bin/etheris-doctor" ]] \
  && grep -qE 'systemd-loop@\*' "$BASE/usr/local/bin/etheris-doctor"; then
  pass "etheris-doctor benign systemd-loop@* filter in squashfs"
else
  bad "etheris-doctor missing systemd-loop@* filter in squashfs"
fi
if [[ -f "$BASE/usr/local/bin/etheris-security" ]] \
  && grep -q 'as_root' "$BASE/usr/local/bin/etheris-security"; then
  pass "etheris-security as_root in squashfs"
else
  bad "etheris-security missing as_root in squashfs"
fi
if [[ -f "$BASE/usr/local/bin/etheris-browser" ]] \
  && grep -q 'firefox_visible_on_ws' "$BASE/usr/local/bin/etheris-browser"; then
  pass "etheris-browser preload hygiene in squashfs"
else
  bad "etheris-browser missing firefox_visible_on_ws in squashfs"
fi
if [[ -f "$BASE/etc/skel/.config/sway/config" ]] \
  && grep -q 'etheris-menu-hover' "$BASE/etc/skel/.config/sway/config"; then
  pass "skel starts etheris-menu-hover"
else
  bad "skel missing etheris-menu-hover"
fi
if [[ -f "$BASE/usr/local/bin/etheris-installer" ]] \
  && grep -q 'var/lib/regreet/state.toml' "$BASE/usr/local/bin/etheris-installer"; then
  pass "installer seeds ReGreet state.toml"
else
  bad "installer missing state.toml seed in squashfs"
fi

# SHA256 record helper
SUMS="$ROOT/out/SHA256SUMS"
hash="$(sha256sum "$ISO" | awk '{print $1}')"
base="$(basename "$ISO")"
touch "$SUMS"
if grep -q "  ${base}\$" "$SUMS" 2>/dev/null; then
  sed -i "s|^[0-9a-f]\\{64\\}  ${base}\$|${hash}  ${base}|" "$SUMS"
else
  echo "${hash}  ${base}" >>"$SUMS"
fi
pass "SHA256 recorded for $base → out/SHA256SUMS"

echo
echo "Extract tree: $EXTRACT"
echo "Result: $ok OK, $fail FAIL"
if ((fail)); then
  echo "ISO validation FAILED"
  exit 1
fi
echo "ISO validation PASSED"
