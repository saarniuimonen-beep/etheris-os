#!/usr/bin/env bash
# Channel “soak” automation — validate Archive reachability + record promotion checklist.
# Does not mutate the running system channel.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/out/channel-soak-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$OUT"

"$ROOT/scripts/channel-validate.sh" | tee "$OUT/validate.txt"
cp -f "$ROOT"/out/channel-validate-*.md "$OUT/" 2>/dev/null || true

cat >"$OUT/SOAK-CHECKLIST.md" <<EOF
# Channel soak checklist

Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)

## Automated (this run)

- [x] Stable/RC Archive DB reachability (\`channel-validate.sh\`)

## Manual soak (operator)

- [ ] Disposable machine on \`rc\` for ≥3 days
- [ ] Daily: \`etheris-update check\` + smoke Super+A/D + auth-check
- [ ] One interrupt/recover drill (\`UPDATE-RECOVERY.md\`)
- [ ] Promote: refresh stable lag / mirror only after rc green

## 1.0 gate link

See \`docs/RELEASE-PREP-1.0.md\`.
EOF

echo "Soak bundle: $OUT"
