## server

Use for SSH/service outages, degraded daemons, auth failures, and listener issues.

Typical checks:

- unit status and dependencies:
  - `systemctl status <unit> --no-pager`
  - `systemctl list-dependencies <unit> --no-pager`
- listener binding:
  - `ss -tulpn`
- firewall and policy denials (SELinux/AppArmor)
- auth path and rate-limit conditions

Mitigation order:

1. Restore critical listener/service availability.
2. Keep change blast radius minimal.
3. Follow with root cause and hardening.
