#!/usr/bin/env bash
# Static consistency gates for the Archiso profile (no ISO build required).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="$ROOT/profile/etheris/airootfs"
fail=0

ok() { printf 'OK  %s\n' "$*"; }
bad() { printf 'FAIL %s\n' "$*"; fail=1; }

VERSION="$(tr -d '[:space:]' <"$ROOT/VERSION")"
[[ -n "$VERSION" ]] || bad "VERSION empty"

# Every etheris-* bin should be executable in tree and listed in profiledef file_permissions
while IFS= read -r bin; do
  name="$(basename "$bin")"
  [[ -x "$bin" ]] || bad "not executable: $name"
  if ! grep -qF "[\"/usr/local/bin/${name}\"]" "$ROOT/profile/etheris/profiledef.sh"; then
    bad "missing profiledef file_permissions: $name"
  fi
done < <(find "$BASE/usr/local/bin" -maxdepth 1 -type f -name 'etheris*' | sort)
# Hub CLI without hyphen
[[ -x "$BASE/usr/local/bin/etheris" ]] || bad "etheris hub missing"
grep -qF '["/usr/local/bin/etheris"]' "$ROOT/profile/etheris/profiledef.sh" || bad "etheris hub not in profiledef"

# No Python cache in airootfs
if find "$BASE" -type d -name '__pycache__' -print -quit | grep -q .; then
  bad "__pycache__ present under airootfs"
else
  ok "no __pycache__ in airootfs"
fi

# ReGreet skip_selection seed (state.toml — upstream CACHE_PATH)
if [[ -f "$BASE/var/lib/regreet/state.toml" ]] \
  && grep -qE '^\s*last_user\s*=\s*"etheris"' "$BASE/var/lib/regreet/state.toml" \
  && grep -qF 'Etheris (Sway)' "$BASE/var/lib/regreet/state.toml"; then
  ok "regreet state.toml seeded for live skip_selection"
else
  bad "regreet state.toml missing or incomplete under var/lib/regreet"
fi
if [[ -e "$BASE/var/lib/regreet/cache.toml" || -e "$BASE/var/lib/regreet/cache.json" ]]; then
  bad "legacy regreet cache.toml/json still present (use state.toml only)"
fi
grep -qF '["/var/lib/regreet"]' "$ROOT/profile/etheris/profiledef.sh" \
  && ok "profiledef lists /var/lib/regreet permissions" \
  || bad "profiledef missing /var/lib/regreet permissions"
grep -qF '["/var/lib/regreet/state.toml"]' "$ROOT/profile/etheris/profiledef.sh" \
  && ok "profiledef lists state.toml permissions" \
  || bad "profiledef missing /var/lib/regreet/state.toml permissions"
# Token geometry SoT (Neo-Aero / phase-2)
TOK="$BASE/usr/local/share/etheris/design/etheris.tokens.json"
if [[ -f "$TOK" ]] \
  && grep -qE '"panelHeightPx"[[:space:]]*:[[:space:]]*28' "$TOK" \
  && grep -qE '"panelTopOffsetPx"[[:space:]]*:[[:space:]]*0' "$TOK"; then
  ok "tokens panel 28/0"
else
  bad "tokens panelHeightPx/panelTopOffsetPx not 28/0"
fi
if [[ -f "$BASE/etc/skel/.config/etheris/settings.conf" ]] \
  && grep -qE '^blur=off' "$BASE/etc/skel/.config/etheris/settings.conf"; then
  ok "skel blur=off"
else
  bad "skel blur not off (Flow / Neo-Aero default)"
fi
if [[ -f "$BASE/etc/systemd/system/etheris-regreet-cache.service" ]] \
  && [[ -L "$BASE/etc/systemd/system/multi-user.target.wants/etheris-regreet-cache.service" ]]; then
  ok "etheris-regreet-cache chown oneshot enabled"
else
  bad "etheris-regreet-cache oneshot not enabled"
fi

# Hide stock Sway session before greeter
if [[ -f "$BASE/etc/systemd/system/etheris-hide-stock-sway.service" ]] \
  && [[ -L "$BASE/etc/systemd/system/multi-user.target.wants/etheris-hide-stock-sway.service" ]]; then
  ok "etheris-hide-stock-sway enabled before greeter"
else
  bad "etheris-hide-stock-sway oneshot not enabled"
fi

# Avahi: Warpinator needs discovery — must not be masked while also enabled
if [[ -L "$BASE/etc/systemd/system/avahi-daemon.service" ]]; then
  target="$(readlink "$BASE/etc/systemd/system/avahi-daemon.service")"
  if [[ "$target" == /dev/null ]]; then
    bad "avahi-daemon.service is masked (/dev/null) — conflicts with Warpinator enable"
  fi
fi
if [[ -L "$BASE/etc/systemd/system/multi-user.target.wants/avahi-daemon.service" ]]; then
  ok "avahi-daemon enabled for Warpinator"
else
  bad "avahi-daemon not enabled (Warpinator on package set)"
fi

# MOTD must not advertise optional DEs that are not on the ISO
if grep -qiE 'Hyprland|KDE|XFCE|Pick your desktop' "$BASE/etc/motd"; then
  bad "motd advertises DEs not shipped on ISO"
else
  ok "motd matches Sway-only ISO"
fi

# os-release BUILD_ID lag must match channels.conf STABLE_LAG_DAYS
lag="$(awk -F= '/^STABLE_LAG_DAYS=/{print $2; exit}' "$BASE/etc/etheris/channels.conf")"
build_id="$(awk -F= '/^BUILD_ID=/{print $2; exit}' "$BASE/etc/os-release")"
want="rolling-lag${lag}"
[[ "$build_id" == "$want" ]] && ok "BUILD_ID=$build_id matches STABLE_LAG_DAYS=$lag" \
  || bad "BUILD_ID=$build_id != $want (channels.conf)"

img_ver="$(awk -F= '/^IMAGE_VERSION=/{print $2; exit}' "$BASE/etc/os-release")"
[[ "$img_ver" == "$VERSION" ]] && ok "IMAGE_VERSION=$img_ver" || bad "IMAGE_VERSION=$img_ver != VERSION=$VERSION"

# Duplicate .desktop names across XDG app dirs (identical names confuse menus)
dupes="$(
  {
    /bin/ls -1 "$BASE/usr/share/applications"/*.desktop 2>/dev/null | xargs -n1 basename
    /bin/ls -1 "$BASE/usr/local/share/applications"/*.desktop 2>/dev/null | xargs -n1 basename
  } | sort | uniq -d
)"
if [[ -n "$dupes" ]]; then
  bad "duplicate .desktop basenames: $(echo "$dupes" | tr '\n' ' ')"
else
  ok "no duplicate application desktop basenames"
fi

# skel vs live home drift — prepare-profile copies skel; catch manual edits left behind
if [[ -d "$BASE/home/etheris" ]]; then
  if ! diff -qr "$BASE/etc/skel" "$BASE/home/etheris" >/dev/null 2>&1; then
    bad "home/etheris drifts from etc/skel (run scripts/prepare-profile.sh)"
  else
    ok "home/etheris matches etc/skel"
  fi
fi

# --- Stability criteria (docs/STABILITY-CRITERIA.md A3–A5, A7) ---
SWAY="$BASE/etc/skel/.config/sway/config"
WAYBAR="$BASE/etc/skel/.config/waybar/config.jsonc"
if [[ -f "$SWAY" ]] \
  && grep -qE 'bindsym \$mod\+a exec \$cc' "$SWAY" \
  && grep -qE 'set \$cc etheris-overlay control-center' "$SWAY"; then
  ok "Super+A → Menu (control-center)"
else
  bad "Super+A must bind etheris-overlay control-center (\$cc)"
fi
if [[ -f "$SWAY" ]] \
  && grep -qE 'bindsym \$mod\+d exec \$menu' "$SWAY" \
  && grep -qE 'set \$menu etheris-overlay launcher' "$SWAY"; then
  ok "Super+D → launcher"
else
  bad "Super+D must bind etheris-overlay launcher"
fi
if [[ -f "$WAYBAR" ]] \
  && grep -qE '"format"[[:space:]]*:[[:space:]]*"Menu"' "$WAYBAR" \
  && grep -qE 'etheris-overlay control-center' "$WAYBAR"; then
  ok "Waybar Menu chip → control-center"
else
  bad "Waybar Menu chip missing or not wired to control-center"
fi
if [[ -f "$BASE/usr/share/wayland-sessions/sway.desktop" ]] \
  && grep -qiE '^(Hidden|NoDisplay)=true' "$BASE/usr/share/wayland-sessions/sway.desktop"; then
  ok "stock sway.desktop Hidden/NoDisplay in tree"
elif [[ -x "$BASE/usr/local/bin/etheris-hide-stock-sway" ]]; then
  ok "hide-stock-sway helper present (desktop may be patched at boot)"
else
  bad "no stock sway hide path (desktop Hidden or etheris-hide-stock-sway)"
fi
if [[ -x "$BASE/usr/local/bin/etheris-doctor" ]] \
  && [[ -x "$BASE/usr/local/bin/etheris-auth-check" ]]; then
  ok "etheris-doctor + etheris-auth-check present"
else
  bad "etheris-doctor / etheris-auth-check missing"
fi
# Browser preload must prefer scratchpad (stability B11 hygiene in tree)
if [[ -x "$BASE/usr/local/bin/etheris-browser" ]] \
  && grep -q 'move scratchpad' "$BASE/usr/local/bin/etheris-browser" \
  && grep -q 'firefox_visible_on_ws\|move_to_scratchpad' "$BASE/usr/local/bin/etheris-browser"; then
  ok "browser preload has scratchpad hygiene"
else
  bad "etheris-browser missing scratchpad hygiene for preload"
fi

# Audio / network / Bluetooth wiring (tree seals — physical DUT still separate)
if [[ -x "$BASE/usr/local/bin/etheris-session-ready" ]] \
  && [[ -L "$BASE/etc/systemd/user/sockets.target.wants/pipewire.socket" ]] \
  && [[ -L "$BASE/etc/systemd/user/sockets.target.wants/pipewire-pulse.socket" ]] \
  && [[ -L "$BASE/etc/systemd/user/default.target.wants/wireplumber.service" ]]; then
  ok "PipeWire user sockets + etheris-session-ready"
else
  bad "PipeWire user enablement / etheris-session-ready incomplete"
fi
if grep -q 'nm-applet' "$BASE/etc/skel/.config/sway/config" \
  && grep -q 'blueman-applet' "$BASE/etc/skel/.config/sway/config" \
  && grep -q 'etheris-session-ready' "$BASE/etc/skel/.config/sway/config"; then
  ok "Sway starts session-ready + nm-applet + blueman-applet"
else
  bad "Sway missing audio/network/BT session autostart"
fi
if grep -qx 'network-manager-applet' "$ROOT/profile/etheris/packages.x86_64" \
  && grep -qx 'alsa-utils' "$ROOT/profile/etheris/packages.x86_64" \
  && grep -qx 'blueman' "$ROOT/profile/etheris/packages.x86_64"; then
  ok "packages: nm-applet + alsa-utils + blueman"
else
  bad "packages missing network-manager-applet / alsa-utils / blueman"
fi
if grep -q 'bluetooth' "$BASE/usr/local/bin/etheris-auth-setup" \
  && grep -q 'bluetooth' "$BASE/usr/local/bin/etheris-installer" \
  && grep -q 'bluetooth' "$BASE/usr/local/bin/etheris-ensure-gaming-groups"; then
  ok "bluetooth group joined (auth-setup / installer / ensure)"
else
  bad "bluetooth group wiring incomplete"
fi
if [[ -f "$BASE/etc/NetworkManager/conf.d/wifi_backend.conf" ]] \
  && grep -q 'wifi.backend=iwd' "$BASE/etc/NetworkManager/conf.d/wifi_backend.conf" \
  && [[ -L "$BASE/etc/systemd/system/multi-user.target.wants/NetworkManager.service" ]] \
  && [[ -L "$BASE/etc/systemd/system/multi-user.target.wants/bluetooth.service" ]]; then
  ok "NM+iwd + bluetooth.service enabled"
else
  bad "NM/iwd/bluetooth enablement incomplete"
fi
if grep -q 'custom/bluetooth' "$BASE/etc/skel/.config/waybar/config.jsonc" \
  && grep -q 'etheris-bt-status' "$BASE/etc/skel/.config/waybar/config.jsonc" \
  && [[ -x "$BASE/usr/local/bin/etheris-bt-status" ]]; then
  ok "Waybar Bluetooth module + etheris-bt-status"
else
  bad "Waybar Bluetooth module incomplete"
fi
if [[ -f "$BASE/etc/pipewire/pipewire.conf.d/99-etheris.conf" ]] \
  && [[ -f "$BASE/etc/wireplumber/wireplumber.conf.d/99-etheris-bluetooth.conf" ]]; then
  ok "PipeWire + WirePlumber Etheris drops"
else
  bad "PipeWire/WirePlumber Etheris conf drops missing"
fi
if grep -q 'etheris-volume' "$BASE/etc/skel/.config/sway/config" \
  && grep -q 'playerctl' "$BASE/etc/skel/.config/sway/config" \
  && [[ -x "$BASE/usr/local/bin/etheris-volume" ]]; then
  ok "etheris-volume + media keys bound"
else
  bad "etheris-volume / media keybinds missing"
fi
if [[ -f "$BASE/etc/iwd/main.conf" ]] \
  && grep -q 'EnableNetworkConfiguration=false' "$BASE/etc/iwd/main.conf"; then
  ok "iwd defers IP config to NetworkManager"
else
  bad "iwd main.conf missing or manages IP itself"
fi

if ((fail)); then
  echo
  echo "Profile consistency FAILED"
  exit 1
fi
echo
echo "Profile consistency PASSED"
