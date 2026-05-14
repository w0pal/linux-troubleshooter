## security

Use for sudo/polkit/SSH denials, policy enforcement blocks, and auth regressions.

Typical checks:

- auth logs:
  - `journalctl -u sshd --no-pager`
  - distro auth logs when applicable
- sudo/polkit behavior for impacted users
- SELinux/AppArmor denials and enforcing mode
- key/permission ownership for SSH paths

Mitigation order:

1. Restore least-privilege access for affected principals.
2. Fix policy root cause, do not permanently weaken controls.
3. Document policy exception path if temporary relax is needed.
