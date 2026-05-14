## Distro and model matrix

Prefer native tooling. Do not mix package ecosystems.

### Mutable systems

- Debian/Ubuntu: `apt`, `apt-cache`, `dpkg`
- Fedora/RHEL/CentOS: `dnf`, `rpm`, `dnf history`
- Arch: `pacman`, `pacman-key`
- openSUSE: `zypper`, `rpm`
- Alpine: `apk`

### Immutable systems

- Fedora Silverblue/Kinoite/CoreOS: `rpm-ostree status`, deploy, rollback
- openSUSE MicroOS/Aeon: `transactional-update`, snapshot boot entries
- NixOS: `nixos-rebuild`, generation rollback

### Containerized environments

- Distrobox: host-integrated userland, not a full VM
- Podman/Docker: verify runtime, cgroup mode, and namespace constraints
- For service-manager behavior, distinguish system scope and user scope explicitly.
