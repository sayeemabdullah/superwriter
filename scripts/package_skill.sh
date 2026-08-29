#!/usr/bin/env bash
# Package superwriter/ into superwriter.skill (a renamed ZIP with superwriter/ at the archive root).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

OUT="${1:-superwriter.skill}"
rm -f "$OUT"

# -X strips extra file attributes for reproducible archives; exclude junk files.
zip -r -X "$OUT" superwriter \
  -x '*.DS_Store' -x '__MACOSX/*' -x '*/.*'

echo ""
echo "built $OUT:"
unzip -l "$OUT"
