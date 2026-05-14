## performance

Use for CPU spikes, memory pressure, high IO wait, and latency regressions.

Typical checks:

- host pressure:
  - `uptime`
  - `vmstat 1 5`
  - `free -h`
- hot processes:
  - `ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head`
- IO bottlenecks:
  - `iostat`/`iotop` (if available)
- cgroup/container pressure and limits

Mitigation order:

1. Stabilize by limiting or restarting the top offender.
2. Reduce immediate pressure (swap, queue depth, rate limits).
3. Apply durable tuning with explicit rollback.
