#!/usr/bin/env bash
# Etheris OS — extremely strict game-ready / drivers criteria (rock-solid).
# See docs/GAME-READY-CRITERIA.md
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
A="$ROOT/profile/etheris/airootfs"
OUT="$ROOT/out/game-ready-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"

ISO="${1:-}"
if [[ -z "$ISO" ]]; then
  ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
fi

ok=0
fail=0
pass() { printf 'OK  %s\n' "$*"; ok=$((ok + 1)); }
bad() { printf 'FAIL %s\n' "$*"; fail=$((fail + 1)); }

echo "Etheris game-ready criteria (rock-solid)"
echo "  criteria: docs/GAME-READY-CRITERIA.md"
echo "  out:      $OUT"
echo "  iso:      ${ISO:-none}"
echo

find "$A" -type d -name '__pycache__' -prune -exec rm -rf {} + 2>/dev/null || true
find "$A" -name '*.pyc' -delete 2>/dev/null || true

# ---------- G0 gate stack ----------
if "$ROOT/scripts/check-profile.sh" >"$OUT/g0-profile.txt" 2>&1; then
  pass "G0.1 check-profile"
else
  bad "G0.1 check-profile"
  grep -E 'FAIL |FAILED' "$OUT/g0-profile.txt" | sed 's/^/  | /' || true
fi

if "$ROOT/scripts/test-p0-security.sh" >"$OUT/g0-p0.txt" 2>&1; then
  p0_ok="$(grep -Eo '[0-9]+ OK' "$OUT/g0-p0.txt" | tail -1 | awk '{print $1}')"
  if [[ -n "${p0_ok:-}" && "$p0_ok" -ge 44 ]]; then
    pass "G0.2 P0 security (${p0_ok} OK ≥44)"
  else
    bad "G0.2 P0 OK count too low (${p0_ok:-?})"
  fi
else
  bad "G0.2 P0 security"
fi

if [[ -n "$ISO" && -f "$ISO" ]]; then
  if "$ROOT/scripts/test-bugs.sh" "$ISO" >"$OUT/g0-bugs.txt" 2>&1; then
    pass "G0.3 test-bugs host PASSED"
  else
    bad "G0.3 test-bugs host"
    grep -E '^FAIL ' "$OUT/g0-bugs.txt" | head -20 | sed 's/^/  | /' || true
  fi
else
  pass "G0.3 test-bugs skipped (no ISO — criteria: when ISO present)"
fi

if grep -RIiE 'anticheat.?bypass|anti-cheat.?bypass|eac.?bypass|battleye.?bypass|vac.?bypass|kernel.?anticheat.?bypass' \
  "$A/usr/local" "$A/usr/share/etheris" 2>/dev/null \
  | grep -viE 'no bypass|does not.*bypass|not.*bypass|without bypass|bypasses\b' \
  | grep -q .; then
  bad "G0.4 anti-cheat bypass strings found"
else
  pass "G0.4 no anti-cheat bypass tooling/strings"
fi

# ---------- G1 tree seals ----------
if grep -q "cow_spacesize=2G" "$ROOT/profile/etheris/profiledef.sh" \
  && grep -q 'remount,size=2G' "$A/etc/systemd/system/etheris-live-ready.service" \
  && [[ -L "$A/etc/systemd/system/multi-user.target.wants/etheris-live-ready.service" ]]; then
  pass "G1.1 cow_spacesize=2G + live-ready remount"
else
  bad "G1.1 live cow space / remount missing"
fi

map_val="$(awk -F= '/^[[:space:]]*vm\.max_map_count/ {gsub(/ /,"",$2); print $2; exit}' \
  "$A/etc/sysctl.d/99-etheris-gaming.conf" 2>/dev/null || true)"
if [[ -n "${map_val:-}" && "$map_val" -ge 1048576 ]]; then
  pass "G1.2 vm.max_map_count=${map_val} (≥1048576)"
else
  bad "G1.2 vm.max_map_count too low or missing (${map_val:-none})"
fi

if grep -q '\[multilib\]' "$ROOT/build.sh" \
  && grep -q '^\[multilib\]' "$ROOT/profile/etheris/pacman.conf"; then
  pass "G1.3 multilib enabled (build + pacman.conf)"
else
  bad "G1.3 multilib missing"
fi

PKGS="$ROOT/profile/etheris/packages.x86_64"
need_pkgs=(
  steam steam-devices gamemode lib32-gamemode mangohud lib32-mangohud gamescope
  wine wine-mono wine-gecko winetricks vkd3d lib32-vkd3d protontricks umu-launcher
  lib32-mesa lib32-vulkan-icd-loader
)
miss=()
for p in "${need_pkgs[@]}"; do
  grep -qx "$p" "$PKGS" || miss+=("$p")
done
if ((${#miss[@]} == 0)); then
  pass "G1.4 live gaming package set (${#need_pkgs[@]} pkgs)"
else
  bad "G1.4 missing packages: ${miss[*]}"
fi

if grep -q 'ETHERIS_INSTALL_GAMING:-0' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'gaming-packages.list' "$A/usr/local/bin/etheris-installer"; then
  pass "G1.5 installer gaming opt-in default 0"
else
  bad "G1.5 installer gaming default / list wiring"
fi

if [[ -x "$A/usr/local/bin/etheris-steam" ]] \
  && grep -q '^Exec=etheris-steam' "$A/usr/local/share/applications/steam.desktop" \
  && grep -q '^Exec=etheris-steam' "$A/usr/local/share/etheris/desktop/steam.desktop" \
  && [[ -f "$A/etc/pacman.d/hooks/etheris-steam-desktop.hook" ]] \
  && grep -q 'etheris/desktop/steam.desktop' "$A/etc/pacman.d/hooks/etheris-steam-desktop.hook" \
  && grep -q 'apply_steam_desktop\|steam.desktop' "$A/usr/local/bin/etheris-ensure-gaming-groups" \
  && ! [[ -f "$A/usr/share/applications/steam.desktop" ]]; then
  pass "G1.6 etheris-steam + template + hook + live apply (no airootfs /usr/share dup)"
else
  bad "G1.6 steam launch path (wrapper/template/hook/live-apply; no XDG dup)"
fi

if [[ -x "$A/usr/local/bin/etheris-gaming-setup" ]] \
  && [[ -x "$A/usr/local/bin/etheris-hw" ]] \
  && [[ -x "$A/usr/local/bin/etheris-drivers" ]] \
  && grep -q 'pascal-legacy-aur\|pascal-guide\|pin-pascal' "$A/usr/local/bin/etheris-drivers"; then
  pass "G1.7 hw/drivers/gaming-setup + Pascal path"
else
  bad "G1.7 helpers / Pascal guard missing"
fi

if grep -q 'pascal-legacy-aur' "$A/usr/local/bin/etheris-drivers" \
  && grep -q 'Refusing nvidia-open' "$A/usr/local/bin/etheris-drivers" \
  && grep -q 'nvidia-580xx' "$A/usr/local/bin/etheris-drivers"; then
  pass "G1.8 Pascal never nudged to nvidia-open"
else
  bad "G1.8 Pascal / nvidia-open guard incomplete"
fi

if grep -q 'No invented values' "$A/usr/local/bin/etheris-hw" \
  && [[ -f "$A/usr/local/share/etheris/hardware/nvidia-pci.tsv" ]] \
  && [[ -f "$A/usr/local/share/etheris/hardware/amd-pci.tsv" ]] \
  && [[ -f "$A/usr/local/share/etheris/hardware/intel-pci.tsv" ]]; then
  pass "G1.9 hw honesty + PCI TSVs"
else
  bad "G1.9 hw honesty / TSVs"
fi

if grep -q 'command -v steam' "$A/usr/local/bin/etheris" \
  && grep -q 'not installed (lean disk install)' "$A/usr/local/bin/etheris" \
  && ! grep -q 'Steam:          pre-installed' "$A/usr/local/bin/etheris"; then
  pass "G1.10 hub gaming Steam present/missing honesty"
else
  bad "G1.10 hub gaming always claims pre-installed"
fi

GL="$A/usr/local/share/etheris/groups/gaming.list"
GP="$A/usr/local/share/etheris/gaming-packages.list"
if [[ -f "$GL" && -f "$GP" ]] && diff -q "$GL" "$GP" >/dev/null; then
  pass "G1.11 gaming.list ≡ gaming-packages.list"
else
  bad "G1.11 gaming package lists diverge"
fi

docs_ok=1
for d in \
  "$ROOT/docs/GAME-READY-CRITERIA.md" \
  "$ROOT/docs/GAMING.md" \
  "$ROOT/docs/HARDWARE.md" \
  "$ROOT/docs/DRIVER-RECOVERY.md" \
  "$A/usr/local/share/etheris/docs/GAMING.md" \
  "$A/usr/local/share/etheris/docs/HARDWARE.md"; do
  [[ -f "$d" ]] || docs_ok=0
done
if ((docs_ok)); then
  pass "G1.12 gaming/hardware/criteria docs present"
else
  bad "G1.12 missing gaming/hardware docs"
fi

if ! grep -qx 'lib32-openal' "$PKGS" \
  && ! grep -qx 'lib32-openal' "$GP" \
  && ! grep -qx 'lib32-openal' "$GL"; then
  pass "G1.13 no vanished lib32-openal in package lists"
else
  bad "G1.13 lib32-openal still listed (Arch dropped it)"
fi

if [[ -x "$A/usr/local/bin/etheris-ensure-gaming-groups" ]] \
  && grep -q 'etheris-ensure-gaming-groups' "$A/etc/systemd/system/etheris-live-ready.service" \
  && grep -q 'remount,size=2G' "$A/etc/systemd/system/etheris-live-ready.service"; then
  pass "G1.14 live-ready: cow remount + gaming groups"
else
  bad "G1.14 live-ready gaming groups / cow remount"
fi

if [[ -f "$A/etc/modprobe.d/etheris-nvidia.conf" ]] \
  && grep -qE 'nvidia_drm[[:space:]]+modeset=1' "$A/etc/modprobe.d/etheris-nvidia.conf"; then
  pass "G1.15 nvidia_drm modeset=1 modprobe"
else
  bad "G1.15 missing etheris-nvidia.conf modeset"
fi

if grep -q 'Do NOT set SDL_VIDEODRIVER=x11' "$A/usr/local/bin/etheris-gaming-setup" \
  && ! grep -qE '^SDL_VIDEODRIVER=x11$' "$A/usr/local/bin/etheris-gaming-setup" \
  && grep -q 'SDL_VIDEODRIVER' "$A/usr/local/bin/etheris-steam"; then
  pass "G1.16 no global SDL X11 poison (Steam-local only)"
else
  bad "G1.16 SDL_VIDEODRIVER policy broken"
fi

if grep -q 'doctor()' "$A/usr/local/bin/etheris-gaming-setup" \
  && grep -q 'gaming doctor' "$A/usr/local/bin/etheris-gaming-setup" \
  && grep -qE '^\s*doctor\)' "$A/usr/local/bin/etheris-gaming-setup"; then
  pass "G1.17 etheris-gaming-setup doctor"
else
  bad "G1.17 gaming doctor missing"
fi

if grep -qx 'xorg-xwayland' "$PKGS"; then
  pass "G1.18 xorg-xwayland on live ISO"
else
  bad "G1.18 xorg-xwayland missing from packages.x86_64"
fi

if grep -q 'enable_multilib' "$A/usr/local/bin/etheris-packages" \
  && grep -q 'join_gamemode_users' "$A/usr/local/bin/etheris-packages" \
  && grep -qF '== gaming' "$A/usr/local/bin/etheris-packages"; then
  pass "G1.19 packages install gaming → multilib + gamemode"
else
  bad "G1.19 etheris-packages gaming install incomplete"
fi

if [[ -f "$A/etc/skel/.config/environment.d/99-etheris-gaming.conf" ]] \
  && ! grep -qE '^[[:space:]]*SDL_VIDEODRIVER=x11' "$A/etc/skel/.config/environment.d/99-etheris-gaming.conf" \
  && [[ -f "$A/etc/skel/.config/MangoHud/MangoHud.conf" ]] \
  && [[ -f "$A/etc/pacman.d/hooks/etheris-steam-desktop.hook" ]] \
  && grep -q 'etheris/desktop/steam.desktop' "$A/etc/pacman.d/hooks/etheris-steam-desktop.hook" \
  && grep -q '99-etheris-gaming.conf' "$A/usr/local/bin/etheris-installer" \
  && grep -q 'etheris-nvidia.conf' "$A/usr/local/bin/etheris-installer"; then
  pass "G1.20 skel gaming env + steam desktop hook + installer sysctl/modprobe"
else
  bad "G1.20 skel/hook/installer gaming overlay incomplete"
fi

# ---------- G2 ISO artifact ----------
if [[ -n "$ISO" && -f "$ISO" ]]; then
  MNT=$(mktemp -d)
  EXT=$(mktemp -d)
  if sudo mount -o loop,ro "$ISO" "$MNT" 2>"$OUT/g2-mount.err"; then
    SFS=$(find "$MNT" -name 'airootfs.sfs' | head -1)
    if [[ -n "$SFS" ]]; then
      unsquashfs -d "$EXT" "$SFS" \
        usr/local/bin/etheris-steam \
        usr/local/bin/etheris-hw \
        usr/local/bin/etheris-drivers \
        usr/local/bin/etheris-gaming-setup \
        usr/local/bin/etheris-ensure-gaming-groups \
        usr/local/bin/etheris \
        usr/local/share/applications/steam.desktop \
        usr/local/share/etheris/desktop/steam.desktop \
        usr/local/share/etheris/gaming-packages.list \
        etc/pacman.d/hooks/etheris-steam-desktop.hook \
        etc/sysctl.d/99-etheris-gaming.conf \
        etc/modprobe.d/etheris-nvidia.conf \
        etc/systemd/system/etheris-live-ready.service \
        usr/bin/steam \
        2>"$OUT/g2-unsquash.err" || true
      if [[ -x "$EXT/usr/local/bin/etheris-steam" \
         && -x "$EXT/usr/local/bin/etheris-hw" \
         && -x "$EXT/usr/local/bin/etheris-drivers" \
         && -x "$EXT/usr/local/bin/etheris-gaming-setup" ]]; then
        pass "G2.1 squashfs gaming/hw helpers"
      else
        bad "G2.1 squashfs helpers missing"
        sed 's/^/  | /' "$OUT/g2-unsquash.err" | head -20 || true
      fi
      if [[ -e "$EXT/usr/bin/steam" || -L "$EXT/usr/bin/steam" ]] \
        && [[ -f "$EXT/etc/sysctl.d/99-etheris-gaming.conf" ]] \
        && [[ -f "$EXT/usr/local/share/etheris/gaming-packages.list" ]]; then
        pass "G2.2 squashfs steam + sysctl + gaming list"
      else
        bad "G2.2 squashfs steam/sysctl/list"
      fi
      if grep -q '^Exec=etheris-steam' "$EXT/usr/local/share/applications/steam.desktop" 2>/dev/null \
        && grep -q '^Exec=etheris-steam' "$EXT/usr/local/share/etheris/desktop/steam.desktop" 2>/dev/null \
        && [[ -f "$EXT/etc/pacman.d/hooks/etheris-steam-desktop.hook" ]] \
        && grep -q apply_steam_desktop "$EXT/usr/local/bin/etheris-ensure-gaming-groups" 2>/dev/null; then
        pass "G2.3 ISO steam desktop + template + hook + live apply"
      else
        bad "G2.3 ISO steam.desktop/template/hook/live-apply incomplete"
      fi
      if grep -q 'command -v steam' "$EXT/usr/local/bin/etheris" 2>/dev/null \
        && grep -q 'not installed (lean disk install)' "$EXT/usr/local/bin/etheris" 2>/dev/null; then
        pass "G2.4 ISO hub gaming honesty"
      else
        bad "G2.4 ISO hub still always pre-installed (rebake needed)"
      fi
      if [[ -x "$EXT/usr/local/bin/etheris-ensure-gaming-groups" ]] \
        && grep -q 'etheris-ensure-gaming-groups' "$EXT/etc/systemd/system/etheris-live-ready.service" 2>/dev/null \
        && grep -qE 'nvidia_drm[[:space:]]+modeset=1' "$EXT/etc/modprobe.d/etheris-nvidia.conf" 2>/dev/null; then
        pass "G2.5 ISO modeset + gaming-groups + live-ready"
      else
        bad "G2.5 ISO missing modeset/groups/live-ready seals"
      fi
    else
      bad "G2.1 no airootfs.sfs"
      bad "G2.2 no airootfs.sfs"
      bad "G2.3 no airootfs.sfs"
      bad "G2.4 no airootfs.sfs"
      bad "G2.5 no airootfs.sfs"
    fi
    sudo umount "$MNT" || true
  else
    bad "G2 mount ISO failed"
    bad "G2.2 mount ISO failed"
    bad "G2.3 mount ISO failed"
    bad "G2.4 mount ISO failed"
    bad "G2.5 mount ISO failed"
  fi
  rmdir "$MNT" 2>/dev/null || true
  sudo rm -rf "$EXT" 2>/dev/null || rm -rf "$EXT" 2>/dev/null || true
else
  pass "G2.1–G2.5 skipped (no ISO — rebuild to seal squashfs)"
fi

# ---------- G3 evidence (optional for PASS; required for ROCK-SOLID) ----------
EVIDENCE="${ETHERIS_GAME_READY_EVIDENCE:-}"
if [[ -z "$EVIDENCE" ]]; then
  EVIDENCE="$(/bin/ls -1td "$ROOT"/out/qemu-game-ready-* 2>/dev/null | head -1 || true)"
fi
if [[ -n "$EVIDENCE" && -f "$EVIDENCE/SUMMARY.md" ]]; then
  if grep -qiE 'guest-apply via|via guest-apply|used guest-apply|HTTP inject' "$EVIDENCE/SUMMARY.md"; then
    bad "G3.8 rock-solid evidence must not use guest-apply"
  else
    pass "G3.8 evidence declares no guest-apply"
  fi
  if grep -qiE 'physical GPU PASS|Steam game PASS|real title PASS|DUT certified' "$EVIDENCE/SUMMARY.md"; then
    bad "G3.9 evidence overclaims physical/title gaming"
  else
    pass "G3.9 evidence does not overclaim physical GPU/titles"
  fi
  if grep -qE 'G3\.[1-7].*OK|OK: [1-9]' "$EVIDENCE/SUMMARY.md" \
    && ! grep -qiE 'FAIL: [1-9]|Result:.*FAIL' "$EVIDENCE/SUMMARY.md"; then
    pass "G3 live battery SUMMARY present (see $EVIDENCE)"
  else
    if grep -q 'FAIL: 0' "$EVIDENCE/SUMMARY.md"; then
      pass "G3 live SUMMARY FAIL: 0"
    else
      echo "NOTE: G3 evidence incomplete — host can still PASS; ROCK-SOLID needs live FAIL:0"
    fi
  fi
else
  echo "NOTE: no G3 live evidence yet (run scripts/test-game-ready-live.sh for ROCK-SOLID)"
fi

echo
echo "Result: $ok OK, $fail FAIL → $OUT"
{
  echo "# Game-ready host gate"
  echo "- Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "- ISO: ${ISO:-none}"
  [[ -n "${ISO:-}" && -f "$ISO" ]] && echo "- SHA256: $(sha256sum "$ISO" | awk '{print $1}')"
  echo "- OK: $ok FAIL: $fail"
  echo "- Criteria: docs/GAME-READY-CRITERIA.md"
} >"$OUT/SUMMARY.md"

((fail == 0))
