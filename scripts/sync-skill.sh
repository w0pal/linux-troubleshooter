#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/skill"

TARGETS=(
  "$ROOT/.github/skills/linux-troubleshooter"
  "$ROOT/.agents/skills/linux-troubleshooter"
  "$ROOT/.claude/skills/linux-troubleshooter"
  "$ROOT/.codex/skills/linux-troubleshooter"
)

for target in "${TARGETS[@]}"; do
  rm -rf "$target"
  mkdir -p "$(dirname "$target")"
  cp -a "$SRC" "$target"
done

echo "Synced skill to ${#TARGETS[@]} harness targets."
