#!/bin/sh
set -eu
cd /tmp
curl -fsSL http://10.0.2.2:8765/browser-fast.tgz | tar xz
sh /tmp/apply.sh
