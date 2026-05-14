## desktop

Use for session failures, compositor issues, audio/input problems, and app launch regressions.

Typical checks:

- display manager and session units
- Wayland/X11 environment and compositor logs
- GPU modules and firmware messages
- PipeWire/WirePlumber service state
- portal and desktop bus availability

Mitigation order:

1. Restore user session services.
2. Isolate compositor/driver mismatch.
3. Reset only targeted user configs if corrupted.
