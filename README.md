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

## Installed skill hardening

GitHub protects the remote source of truth, but it does not protect an already installed local copy under `~/.codex/skills/`. To make the installed `linux-troubleshooter` skill read-only to normal chat/workspace edits, lock the local install after syncing:

```bash
sudo chown -R root:root ~/.codex/skills/linux-troubleshooter
sudo chmod -R a-w ~/.codex/skills/linux-troubleshooter
sudo chattr -R +i ~/.codex/skills/linux-troubleshooter
```

To update the installed copy later, unlock it locally, sync or reinstall from GitHub, then lock it again:

```bash
sudo chattr -R -i ~/.codex/skills/linux-troubleshooter
sudo chown -R "$USER:$USER" ~/.codex/skills/linux-troubleshooter
sudo chmod -R u+w ~/.codex/skills/linux-troubleshooter
```

Do not paste GitHub tokens, passwords, PINs, recovery keys, or sudo passwords into chat. Use local `sudo` prompts or `gh auth login` when authentication is needed.
