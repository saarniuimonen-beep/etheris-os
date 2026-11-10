#!/usr/bin/env bash
# Run inside Etheris guest after mounting the inject disk (often /dev/vdb1 or /run/media/*/ETHERISINJ)
set -euo pipefail
MNT="${1:-}"
if [[ -z "$MNT" ]]; then
  for c in /run/media/*/*/perf-gpu-apply.tgz /media/*/perf-gpu-apply.tgz /mnt/inject/perf-gpu-apply.tgz; do
    [[ -f "$c" ]] && MNT="$(dirname "$c")" && break
  done
fi
[[ -n "$MNT" && -f "$MNT/perf-gpu-apply.tgz" ]] || { echo "Usage: $0 /path/to/inject"; exit 1; }
sudo tar -C / -xvf "$MNT/perf-gpu-apply.tgz"
sudo systemctl daemon-reload
sudo systemctl enable --now etheris-perf.service || true
etheris-perf status
etheris-gpu status
