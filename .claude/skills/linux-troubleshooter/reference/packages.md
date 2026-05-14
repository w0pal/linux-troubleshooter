## packages

Use for update/install/remove conflicts, locks, signature failures, and dependency breaks.

Rules:

- Use distro-native package manager only.
- Confirm repo and key health before forceful actions.
- Prefer targeted fixes over broad reinstall.

Typical checks:

1. manager lock state
2. repo/index freshness
3. signature/key validity
4. conflict chain from solver output
5. transaction history (where supported)
6. repo enablement/priority and stale mirror issues

Package-manager quick map:

- Debian/Ubuntu: `apt`, `apt-cache`, `dpkg`, `/var/log/apt/`
- Fedora/RHEL: `dnf`, `rpm`, `dnf history`, `dnf repolist`
- Arch: `pacman`, `pacman-key`, mirror freshness
- openSUSE: `zypper`, solver and repo priorities
- Alpine: `apk`, branch consistency
- NixOS: `nixos-rebuild`, generation diff
- Immutable Fedora: `rpm-ostree status`, deployment rollback
- Immutable openSUSE: `transactional-update`, snapshots

Lock/conflict triage:

1. Identify the locking process first.
2. Verify active transaction is truly stale before cleanup.
3. Re-run with native manager diagnostics enabled.
4. Apply the smallest resolver change necessary.

Immutable notes:

- use deployment transactions (`rpm-ostree`, `transactional-update`, `nixos-rebuild`)
- avoid mutable assumptions on image-based systems
