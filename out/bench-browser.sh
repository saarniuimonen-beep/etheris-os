#!/bin/bash
# Bench warm-path open latency (scratchpad show). Expect <1s when preload succeeded.
set -euo pipefail
swaymsg '[app_id="firefox"] move scratchpad' >/dev/null 2>&1 || true
sleep 0.15
if ! pgrep -x firefox >/dev/null; then
  echo 'NO_FIREFOX cold-starting preload...'
  etheris-browser --preload
  for i in $(seq 1 80); do
    pgrep -x firefox >/dev/null && break
    sleep 0.1
  done
  sleep 0.5
  swaymsg '[app_id="firefox"] move scratchpad' >/dev/null 2>&1 || true
fi
start=$(date +%s%N)
etheris-browser
end=$(date +%s%N)
awk -v s="$start" -v e="$end" 'BEGIN { printf "open_ms=%.1f\n", (e-s)/1e6 }'
etheris-browser --status || true
