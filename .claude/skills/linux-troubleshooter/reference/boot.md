## boot

Use for boot failures, login issues, emergency mode, and startup regressions.

Typical checks:

- bootloader state (`bootctl status` or grub config)
- failed targets/units:
  - `systemctl list-jobs --no-pager`
  - `systemctl --failed --no-pager`
- early boot logs:
  - `journalctl -b -0 --no-pager`
  - `journalctl -b -1 --no-pager` (previous boot)
- driver or initramfs failures from `dmesg`

Mitigation order:

1. Boot with previous known-good kernel/deployment when available.
2. Disable one newly failing unit if it blocks default target.
3. Rebuild initramfs/boot metadata using distro-native tooling.
