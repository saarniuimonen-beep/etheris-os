#!/bin/bash
# Replace /usr/bin/mount inside the Etheris build container.
# Rootless podman cannot create kernel "devtmpfs". Rewrite those mounts to
# rbind /dev. pacstrap calls: mount udev "$root/dev" -t devtmpfs -o …
set -euo pipefail
REAL_MOUNT="${REAL_MOUNT:-/usr/bin/mount.real}"
args=("$@")

is_devtmpfs=0
for a in "${args[@]}"; do
  if [[ "$a" == "devtmpfs" ]]; then
    is_devtmpfs=1
    break
  fi
done

if [[ "$is_devtmpfs" -eq 1 ]]; then
  # Find mountpoint: first absolute path argument (pacstrap passes $root/dev early)
  target=""
  for a in "${args[@]}"; do
    if [[ "$a" == /* ]]; then
      target="$a"
      break
    fi
  done
  if [[ -z "$target" ]]; then
    target="${args[-1]}"
  fi
  mkdir -p "$target"
  "$REAL_MOUNT" --rbind /dev "$target"
  mkdir -p "$target/pts" "$target/shm"
  exit 0
fi

exec "$REAL_MOUNT" "${args[@]}"
