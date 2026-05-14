## Custom skill authoring checklist

Directory pattern:

`~/.copilot/skills/<skill-name>/`

Required:

- `SKILL.md` with frontmatter:
  - `name`
  - `description`
  - `version`
  - `user-invocable`
  - optional `argument-hint`, `license`

Recommended:

- `reference/` for focused procedure docs
- `scripts/` for deterministic helper commands

Authoring rules:

1. Define a clear scope and command menu.
2. Include setup steps that gather evidence first.
3. Define a strict output contract for consistency.
4. Keep commands reversible and explicit.
