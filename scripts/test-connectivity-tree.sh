#!/usr/bin/env bash
# Etheris OS — host tree seals for audio / network / Bluetooth wiring.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
A="$ROOT/profile/etheris/airootfs"
ok=0
fail=0
pass() { echo "OK  $*"; ok=$((ok + 1)); }
bad() { echo "FAIL $*"; fail=$((fail + 1)); }

[[ -x "$A/usr/local/bin/etheris-session-ready" ]] && pass "session-ready" || bad "session-ready"
[[ -x "$A/usr/local/bin/etheris-bt-status" ]] && pass "bt-status" || bad "bt-status"
[[ -L "$A/etc/systemd/user/sockets.target.wants/pipewire.socket" ]] && pass "pipewire.socket" || bad "pipewire.socket"
[[ -L "$A/etc/systemd/user/sockets.target.wants/pipewire-pulse.socket" ]] && pass "pipewire-pulse.socket" || bad "pipewire-pulse"
[[ -L "$A/etc/systemd/user/default.target.wants/wireplumber.service" ]] && pass "wireplumber" || bad "wireplumber"
[[ -f "$A/etc/pipewire/pipewire.conf.d/99-etheris.conf" ]] && pass "pipewire drop" || bad "pipewire drop"
[[ -f "$A/etc/wireplumber/wireplumber.conf.d/99-etheris-bluetooth.conf" ]] && pass "wp bluetooth drop" || bad "wp bluetooth"
[[ -f "$A/etc/NetworkManager/conf.d/wifi_backend.conf" ]] && pass "iwd backend" || bad "iwd backend"
[[ -f "$A/etc/NetworkManager/conf.d/20-etheris-wifi.conf" ]] && pass "wifi privacy drop" || bad "wifi privacy"
grep -q 'custom/bluetooth' "$A/etc/skel/.config/waybar/config.jsonc" && pass "waybar bt" || bad "waybar bt"
grep -q 'nm-applet' "$A/etc/skel/.config/sway/config" && pass "sway nm-applet" || bad "sway nm-applet"
grep -q 'blueman-applet' "$A/etc/skel/.config/sway/config" && pass "sway blueman" || bad "sway blueman"
[[ -x "$A/usr/local/bin/etheris-volume" ]] && pass "etheris-volume" || bad "etheris-volume"
grep -q 'etheris-volume' "$A/etc/skel/.config/sway/config" && pass "sway volume helper" || bad "sway volume helper"
[[ -f "$A/etc/iwd/main.conf" ]] && pass "iwd main.conf" || bad "iwd main.conf"
grep -qx 'network-manager-applet' "$ROOT/profile/etheris/packages.x86_64" && pass "pkg nm-applet" || bad "pkg nm-applet"
grep -q 'bluetooth' "$A/usr/local/bin/etheris-installer" && pass "installer bluetooth" || bad "installer bluetooth"
grep -q 'pipewire.conf.d' "$A/usr/local/bin/etheris-installer" && pass "installer pipewire drops" || bad "installer pipewire"
grep -q 'run_connectivity' "$A/usr/local/bin/etheris-doctor" && pass "doctor connectivity" || bad "doctor connectivity"
grep -q 'AutoEnable=true' "$A/etc/bluetooth/main.conf" && pass "bt AutoEnable" || bad "bt AutoEnable"
grep -q 'org.blueman' "$A/etc/polkit-1/rules.d/49-etheris-wheel.rules" && pass "blueman polkit" || bad "blueman polkit"
grep -q 'EnableNetworkConfiguration=false' "$A/etc/iwd/main.conf" && pass "iwd no IP config" || bad "iwd no IP config"

echo
echo "Result: $ok OK, $fail FAIL"
((fail == 0))
