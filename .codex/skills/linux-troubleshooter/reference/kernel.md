## kernel

Use for module load failures, driver regressions, firmware issues, and kernel panic-related analysis.

Typical checks:

- kernel and module versions
- module state (`lsmod`, `modinfo`)
- taint and panic indicators in `dmesg`
- firmware load errors
- regression correlation with recent kernel updates

Mitigation order:

1. Boot previous known-good kernel where available.
2. Revert the single offending driver/module change.
3. Apply durable fix after confirming reproducibility.
