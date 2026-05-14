## Codex CLI diagnostics

Use these checks before deeper changes:

1. Binary and version:
   - `command -v codex`
   - `codex --version`
2. Shell and PATH:
   - `echo "$SHELL"`
   - `echo "$PATH"`
3. Workspace context:
   - `pwd`
   - `git rev-parse --show-toplevel 2>/dev/null || echo "not a git repo"`
4. Fast error capture:
   - Re-run failing command once and capture stderr verbatim.

Prefer fixing one root cause at a time.
