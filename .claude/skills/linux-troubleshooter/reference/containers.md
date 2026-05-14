## containers

Use for Distrobox/Podman/Docker failures, runtime mismatch, cgroup issues, and host integration problems.

Typical checks:

- runtime versions and active backend
- rootless vs rootful mode
- cgroup driver/version compatibility
- namespace visibility and bind mount paths
- service manager expectations inside containers (`systemctl` vs `systemctl --user`)

Distrobox-specific guidance:

1. Confirm whether the goal needs system scope or user scope services.
2. In Distrobox, prefer user services for long-running workloads.
3. For full system manager behavior, use a dedicated container workflow designed for it.
