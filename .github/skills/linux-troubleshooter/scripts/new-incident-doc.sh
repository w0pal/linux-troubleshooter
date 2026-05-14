#!/usr/bin/env bash
set -euo pipefail

DOCS_DIR="${LINUX_TROUBLESHOOTER_DOCS_DIR:-$HOME/docs}"
TOPIC="${1:-incident}"
DATE="$(date +%F)"

slug="$(printf '%s' "$TOPIC" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
if [[ -z "$slug" ]]; then
  slug="incident"
fi

FILE="$DOCS_DIR/${DATE}-${slug}.md"
mkdir -p "$DOCS_DIR"

if [[ ! -t 0 ]]; then
  cat >"$FILE"
elif [[ ! -f "$FILE" ]]; then
  cat >"$FILE" <<EOF
# Incident: ${TOPIC}

## Diagnosis

## Immediate fix

## Durable fix

## Rollback
\`\`\`bash
\`\`\`

## Verification
\`\`\`bash
\`\`\`
EOF
fi

printf '%s\n' "$FILE"
