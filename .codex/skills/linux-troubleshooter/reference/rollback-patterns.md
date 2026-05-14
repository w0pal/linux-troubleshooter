## Rollback patterns

Always include an explicit undo path in every response.

Common rollback forms:

1. Service changes
   - `systemctl disable --now <unit>`
   - restore previous unit file
   - `systemctl daemon-reload`
2. Package updates
   - distro-native downgrade/history undo
3. Config edits
   - restore backup
   - restart/reload affected unit
4. Immutable deployment changes
   - rollback to previous deployment/generation

If no safe rollback exists, state that clearly before remediation.
