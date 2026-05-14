# linux-troubleshooter

Linux troubleshooting skill pack with an `impeccable`-style project layout. Tested on `copilot` and `codex`.

## Structure

- `skill/`: canonical `linux-troubleshooter` source (`SKILL.md`, `reference/`, `scripts/`)
- `.github/skills/linux-troubleshooter/`: GitHub Copilot target
- `.agents/skills/linux-troubleshooter/`: Codex/OpenCode-style target
- `.claude/skills/linux-troubleshooter/`: Claude Code target
- `.codex/skills/linux-troubleshooter/`: Codex project target
- `.agents/skills/codex-cli/`: shared `codex-cli` skill for Codex/OpenCode-style harnesses
- `.codex/skills/codex-cli/`: local Codex project skill target

## AI Harness Configuration

This project uses the same skill-mirror pattern as Impeccable for the shared skill:

- edit `skill/` as the source of truth
- mirror it into `.agents/skills/`, `.codex/skills/`, `.claude/skills/`, and `.github/skills/`
- run `bash scripts/sync-skill.sh` after skill changes

It is not otherwise the same as Impeccable's native agent setup. Linux-troubleshooter currently ships harness skills only; it does not include a separate MCP server config or native Codex subagent under `.codex/agents/`. Add those only when the project needs a real tool server or a provider-native delegated agent, not just another command/reference skill.

## Usage

In a supported harness:

```text
/linux-troubleshooter triage <symptom>
/linux-troubleshooter containers <symptom>
/linux-troubleshooter immutable <symptom>
```

After each troubleshooting run, create/update a concise incident report in `~/docs/`:

```bash
bash scripts/new-incident-doc.sh "<topic>"
```

## Sync workflow

Edit `skill/` first, then sync to harness folders:

```bash
bash scripts/sync-skill.sh
```
