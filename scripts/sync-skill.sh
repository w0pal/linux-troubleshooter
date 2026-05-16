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

synced=0

for target in "${TARGETS[@]}"; do
  if [[ -e "$target" && ! -w "$target" ]]; then
    echo "Skipping read-only target: $target" >&2
    continue
  fi
  rm -rf "$target"
  mkdir -p "$(dirname "$target")"
  cp -a "$SRC" "$target"
  synced=$((synced + 1))
done

echo "Synced skill to $synced harness targets."
