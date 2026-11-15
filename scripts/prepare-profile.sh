#!/usr/bin/env bash
# Sync skel → live home, stamp version metadata, clean build junk before mkarchiso.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="$ROOT/profile/etheris/airootfs"
VERSION="$(tr -d '[:space:]' <"$ROOT/VERSION")"
LAG_DAYS="$(awk -F= '/^STABLE_LAG_DAYS=/{print $2; exit}' "$BASE/etc/etheris/channels.conf" 2>/dev/null || echo 14)"
LAG_DAYS="${LAG_DAYS:-14}"
BUILD_ID="rolling-lag${LAG_DAYS}"

rm -rf "$BASE/home/etheris"
mkdir -p "$BASE/home"
cp -a "$BASE/etc/skel" "$BASE/home/etheris"

# Executable bits for Etheris tooling (profiledef also enforces these)
find "$BASE/usr/local/bin" -maxdepth 1 -type f -name 'etheris*' -exec chmod 755 {} +
# Never ship bytecode — check-profile rejects any __pycache__ under airootfs
find "$BASE" -type d -name '__pycache__' -prune -exec rm -rf {} +
find "$BASE" -type f \( -name '*.pyc' -o -name '*.pyo' \) -delete
# ReGreet skip_selection reads CACHE_PATH=/var/lib/regreet/state.toml
# (upstream ReGreet — not cache.toml). Session key is desktop Name=.
mkdir -p "$BASE/var/lib/regreet"
cat >"$BASE/var/lib/regreet/state.toml" <<'EOF'
# Etheris live defaults — ReGreet CACHE_PATH is state.toml (not cache.toml).
# skip_selection requires last_user + a mapped last session (desktop Name=).
last_user = "etheris"

[user_to_last_sess]
etheris = "Etheris (Sway)"
EOF
# Drop legacy wrong filenames if present from older trees
rm -f "$BASE/var/lib/regreet/cache.toml" "$BASE/var/lib/regreet/cache.json"
chmod 755 "$BASE/var/lib/regreet"
chmod 644 "$BASE/var/lib/regreet/state.toml"

# Design tokens SoT: repo design/phase-2/tokens → on-ISO share (panel 28/0, blur off)
if [[ -f "$ROOT/design/phase-2/tokens/etheris.tokens.json" ]]; then
  mkdir -p "$BASE/usr/local/share/etheris/design"
  cp -f "$ROOT/design/phase-2/tokens/etheris.tokens.json" \
    "$BASE/usr/local/share/etheris/design/etheris.tokens.json"
fi

# Stamp VERSION into image + os-release (keeps IMAGE_VERSION / PRETTY_NAME / BUILD_ID honest)
mkdir -p "$BASE/usr/local/share/etheris" "$BASE/etc/etheris"
cp -f "$ROOT/VERSION" "$BASE/usr/local/share/etheris/VERSION"
cp -f "$ROOT/VERSION" "$BASE/etc/etheris-version"
cat >"$BASE/etc/os-release" <<EOF
NAME="Etheris OS"
PRETTY_NAME="Etheris OS ${VERSION}"
ID=etheris
ID_LIKE=arch
BUILD_ID=${BUILD_ID}
ANSI_COLOR="0;38;2;167;139;250"
HOME_URL="file:///usr/local/share/etheris/docs/README.md"
DOCUMENTATION_URL="file:///usr/local/share/etheris/docs/README.md"
SUPPORT_URL="file:///usr/local/share/etheris/docs/README.md"
BUG_REPORT_URL="file:///usr/local/share/etheris/docs/README.md"
LOGO=etheris
IMAGE_ID=etheris
IMAGE_VERSION=${VERSION}
VARIANT="Stable (Archive lag)"
VARIANT_ID=stable
EOF

# Curated on-ISO docs (subset of repo docs/) — keep in sync at bake time
DOCS_DST="$BASE/usr/local/share/etheris/docs"
mkdir -p "$DOCS_DST"
for doc in \
  CHANNELS.md DRIVER-RECOVERY.md FLOW.md GAMING.md HARDWARE-TEST-MATRIX.md HARDWARE.md \
  IMMUTABLE.md INSTALL-PERSISTENCE.md INSTALLER-FAILURE-MODES.md KEYBOARD.md LOGIN.md OOBE.md \
  PERFORMANCE-MANAGER.md POLKIT.md PUBLISH-APPROVAL.md RELEASE-CHECKLIST.md \
  RELEASE-POLICY.md RENAME-VERIFICATION.md ROADMAP.md SECURITY.md SOUNDS.md TRANSFERS.md \
  DEVELOPMENT-ROADMAP.md TESTING-STRATEGY.md UPDATE-RECOVERY.md SECURITY-UPDATES.md \
  LUKS-PLAN.md SECURE-BOOT-PLAN.md SELINUX-STUDY.md PACKAGE-GROUPS.md SOFTWARE-CENTER.md \
  RECOVERY.md REPRODUCIBILITY.md RELEASE-PREP-1.0.md PRIVACY-DASHBOARD.md
do
  [[ -f "$ROOT/docs/$doc" ]] && cp -f "$ROOT/docs/$doc" "$DOCS_DST/$doc"
done
# On-ISO README stays the short index if present; refresh from tree when available
if [[ -f "$DOCS_DST/README.md" ]]; then
  :
elif [[ -f "$ROOT/docs/development.md" ]]; then
  cp -f "$ROOT/docs/development.md" "$DOCS_DST/README.md"
fi

# Stage 1 — refresh tokens-*.conf from etheris.tokens.json when generator is present
if [[ -x "$BASE/usr/local/bin/etheris-tokens-generate" ]]; then
  ETHERIS_SHARE="$BASE/usr/local/share/etheris" \
    "$BASE/usr/local/bin/etheris-tokens-generate" \
    --design-dir "$BASE/usr/local/share/etheris/design" || true
fi

echo "Live user home synced from skel."
echo "Version stamped: ${VERSION} (${BUILD_ID})"
