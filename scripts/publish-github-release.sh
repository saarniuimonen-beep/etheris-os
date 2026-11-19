#!/usr/bin/env bash
# Publish a public GitHub Release for Etheris OS (checksums + notes; ISO if <2GiB).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

TAG="${1:-v0.1.0-alpha}"
TITLE="${2:-Etheris OS 0.1.0-alpha}"
NOTES="${ETHERIS_RELEASE_NOTES:-$ROOT/docs/RELEASE-NOTES-0.1.0-alpha.md}"
ISO="$(/bin/ls -1t "$ROOT"/out/etheris-*.iso 2>/dev/null | head -1 || true)"
SUMS="$ROOT/out/SHA256SUMS"
REPO="${ETHERIS_GH_REPO:-saarniuimonen-beep/etheris-os}"
LIMIT=$((2 * 1024 * 1024 * 1024))

[[ -f "$NOTES" ]] || { echo "missing $NOTES" >&2; exit 1; }
[[ -f "$SUMS" ]] || { echo "missing $SUMS — bake an ISO first" >&2; exit 1; }

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI required" >&2
  exit 1
fi

assets=("$SUMS" "$NOTES")
if [[ -n "$ISO" && -f "$ISO" ]]; then
  sz=$(stat -c%s "$ISO")
  if ((sz < LIMIT)); then
    assets+=("$ISO")
    echo "Including ISO ($(numfmt --to=iec "$sz"))"
  else
    echo "ISO is $(numfmt --to=iec "$sz") (≥2 GiB GitHub limit) — publishing checksums + notes only"
    echo "  Host the ISO on a mirror and link it in the release body."
  fi
else
  echo "No ISO in out/ — publishing checksums + notes only"
fi

# Ensure tag exists on GitHub after push
if ! git rev-parse "$TAG" >/dev/null 2>&1; then
  git tag -a "$TAG" -m "$TITLE"
fi

git push github "$TAG" 2>/dev/null || git push origin "$TAG" 2>/dev/null || git push "$TAG"

if gh release view "$TAG" -R "$REPO" >/dev/null 2>&1; then
  echo "Release $TAG exists — uploading assets"
  gh release upload "$TAG" "${assets[@]}" -R "$REPO" --clobber
else
  gh release create "$TAG" "${assets[@]}" \
    -R "$REPO" \
    --title "$TITLE" \
    --notes-file "$NOTES" \
    --latest=false
fi

echo "Published: https://github.com/$REPO/releases/tag/$TAG"
