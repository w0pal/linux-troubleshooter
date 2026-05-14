---
name: codex-cli
description: Use when working with Codex CLI workflows, troubleshooting, and custom skill authoring.
version: 1.0.0
user-invocable: true
argument-hint: "[triage|setup|auth|models|skills|agents|workflow] [goal]"
license: Apache-2.0
---

Guides practical Codex CLI usage with an evidence-first, command-oriented workflow.

## Scope

Use this skill for:

- Installing or upgrading Codex CLI
- Authentication and account/session issues
- Model selection and runtime behavior questions
- Agent and tool usage patterns
- Creating and maintaining local custom skills
- Diagnosing common command or environment failures

## Safety rules

1. Prefer read-only diagnostics before making changes.
2. Use minimal-impact, reversible actions first.
3. Do not run destructive commands unless the user explicitly asks.
4. Ask one focused question when requirements are ambiguous.

## Setup (always run first)

1. Gather runtime facts:

```bash
pwd
uname -a
codex --version || true
echo "$SHELL"
```

2. Classify context:

- OS and shell
- Repository or non-repository workspace
- Whether the request is usage help, troubleshooting, or skill authoring

3. Load shared references:

- [reference/diagnostics.md](reference/diagnostics.md)
- [reference/skills.md](reference/skills.md)

## Command menu

If no argument is provided, show this table and ask what to run.

| Command | Focus | Typical checks |
|---|---|---|
| `triage [symptom]` | General intake | scope, impact, errors, recent changes |
| `setup [goal]` | Install and environment setup | binary, PATH, version, shell profile |
| `auth [symptom]` | Sign-in and token issues | auth state, account, credential store |
| `models [goal]` | Model selection and behavior | model id, capability, cost/speed tradeoff |
| `skills [goal]` | Custom skill creation/maintenance | directory layout, metadata, references |
| `agents [goal]` | Sub-agent strategy | delegation boundaries, background handling |
| `workflow [goal]` | Day-to-day CLI workflow | search/edit/test loops, batching, verification |

If the first word matches a command, focus on that area.
If not, treat the full input as a symptom and run `triage`.

## Output contract

For each run, provide:

1. **Diagnosis**: likely cause and confidence
2. **Immediate fix**: lowest-risk next step
3. **Durable fix**: longer-term improvement
4. **Rollback**: exact undo path
5. **Verification**: commands and healthy expected output
