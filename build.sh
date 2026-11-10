#!/usr/bin/env bash
# Build Etheris OS ISO using Podman + official Arch + archiso
# Milestone 1: workdir inside container; mount-wrapper for rootless pacstrap.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE="$ROOT/profile/etheris"
OUT="$ROOT/out"
CACHE="$ROOT/work/pacman-cache"
WORKDIR="$ROOT/work/mkarchiso"
LOG="$OUT/build-$(date -u +%Y%m%dT%H%M%SZ).log"
export SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-$(date -u +%s)}"

mkdir -p "$OUT" "$CACHE" "$WORKDIR"
# Fresh mkarchiso work tree each bake (keeps /home space visible; avoids overlay quota traps)
rm -rf "$WORKDIR"/*
"$ROOT/scripts/prepare-profile.sh"

if ! command -v podman >/dev/null 2>&1; then
  echo "podman is required (ask before installing on Fedora)"
  exit 1
fi

cat > "$PROFILE/airootfs/etc/pacman.d/mirrorlist" <<'EOF'
# Etheris OS Milestone-1 live mirrors (official Arch)
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
EOF

echo "==> Etheris OS ISO build (archiso)"
echo "    version: $(cat "$ROOT/VERSION")"
echo "    profile: $PROFILE"
echo "    log:     $LOG"
echo "    SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}"
df -h "$ROOT" | tail -1
echo

# Prefer rootful sudo podman when available (best). Else rootless + mount wrapper.
PODMAN=(podman)
if sudo -n true 2>/dev/null; then
  PODMAN=(sudo podman)
  echo "    using: sudo podman (rootful)"
else
  echo "    using: rootless podman + mount-wrapper (devtmpfs workaround)"
fi

set +e
"${PODMAN[@]}" run --rm --privileged \
  --security-opt label=disable \
  --security-opt seccomp=unconfined \
  --name etheris-build \
  -e "SOURCE_DATE_EPOCH=${SOURCE_DATE_EPOCH}" \
  -v "$PROFILE:/profile:ro,Z" \
  -v "$OUT:/out:Z" \
  -v "$CACHE:/var/cache/pacman/pkg:Z" \
  -v "$WORKDIR:/work:Z" \
  -v "$ROOT/scripts/mount-wrapper.sh:/usr/local/sbin/mount:ro,Z" \
  docker.io/archlinux:latest \
  bash -lc '
    set -euo pipefail
    export PACMAN_OPTS="--noconfirm --needed"
    # pacstrap needs /usr/bin/mount replaced: rootless cannot mount real devtmpfs
    if [[ -f /usr/local/sbin/mount ]]; then
      cp -a /usr/bin/mount /usr/bin/mount.real
      cp /usr/local/sbin/mount /usr/bin/mount
      chmod 755 /usr/bin/mount
      export REAL_MOUNT=/usr/bin/mount.real
      echo "mount wrapper installed over /usr/bin/mount"
    fi

    cat > /etc/pacman.d/mirrorlist <<EOF
Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://mirror.rackspace.com/archlinux/\$repo/os/\$arch
EOF
    pacman-key --init
    pacman-key --populate archlinux
    pacman -Sy --noconfirm --needed archiso arch-install-scripts
    echo "archiso: $(pacman -Q archiso)"
    df -h /work /out /var/cache/pacman/pkg | sed "s/^/    /"

    rm -rf /build-profile
    # Keep /work (host-mounted); only clear previous mkarchiso trees
    rm -rf /work/x86_64 /work/iso /work/bootstrap /work/efiboot /work/esp 2>/dev/null || true
    find /work -mindepth 1 -maxdepth 1 -exec rm -rf {} + 2>/dev/null || true
    cp -a /profile /build-profile
    # Start from archiso releng pacman.conf, then ensure [multilib] for Steam/lib32.
    # NOTE: this block runs inside bash -lc with single quotes — avoid nested quotes.
    cp /usr/share/archiso/configs/releng/pacman.conf /build-profile/pacman.conf
    if ! grep -q "^\[multilib\]" /build-profile/pacman.conf; then
      printf "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n" >> /build-profile/pacman.conf
    fi
    if ! grep -q "^\[multilib\]" /build-profile/pacman.conf; then
      echo "ERROR: failed to enable [multilib] in build pacman.conf" >&2
      exit 1
    fi
    # Steam depends on lsb-release; keep Etheris /etc/lsb-release from airootfs
    if ! grep -q "^NoExtract.*etc/lsb-release" /build-profile/pacman.conf; then
      if grep -q "^NoExtract" /build-profile/pacman.conf; then
        sed -i "s|^NoExtract.*|& etc/lsb-release|" /build-profile/pacman.conf
      else
        sed -i "/^HoldPkg/a NoExtract   = etc/lsb-release" /build-profile/pacman.conf
      fi
    fi
    grep -n -A2 "^\[multilib\]" /build-profile/pacman.conf
    grep -n "^NoExtract" /build-profile/pacman.conf || true
    mkdir -p /work /out /var/cache/pacman/pkg

    # Smoke-test the mount path pacstrap uses
    mkdir -p /work/_test/dev
    mount -t devtmpfs udev /work/_test/dev
    echo "devtmpfs/bind smoke: OK"
    umount /work/_test/dev || umount -l /work/_test/dev || true
    rmdir /work/_test/dev /work/_test 2>/dev/null || true

    # stdin closed: pinned providers in packages.x86_64 (iptables, pipewire-jack)
    mkarchiso -v -w /work -o /out /build-profile </dev/null
  ' 2>&1 | tee "$LOG"
  rc=${PIPESTATUS[0]}
set -e

echo
if [[ $rc -ne 0 ]]; then
  echo "==> BUILD FAILED (exit $rc). See $LOG"
  echo "If mount still fails, re-run after: sudo -v   # then ./build.sh uses sudo podman"
  exit "$rc"
fi

echo "==> Build finished. Artifacts:"
ls -lh "$OUT"/*.iso 2>/dev/null || { echo "No ISO produced"; exit 1; }
(
  cd "$OUT"
  sha256sum etheris-*.iso | tee SHA256SUMS
)
echo "Log: $LOG"
