## storage

Use for disk-full, inode pressure, mount failures, and filesystem errors.

Typical checks:

- capacity: `df -h`, `df -i`
- top consumers:
  - `du -xh --max-depth=1 /var | sort -h`
- mount health: `findmnt`, `mount`
- filesystem signals:
  - `dmesg | grep -Ei "ext4|xfs|btrfs|i/o error"`
- journal pressure and log growth

Mitigation order:

1. Free low-risk space (cache/log rotation artifacts).
2. Stop crash loops generating logs.
3. Repair mount or fstab entry.
4. Schedule deeper fs repair if needed.
