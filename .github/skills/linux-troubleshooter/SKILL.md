---
name: linux-troubleshooter
description: Use when troubleshooting Linux issues across distro families and deployment models, including mutable and immutable systems, desktop and server environments.
version: 2.1.0
user-invocable: true
argument-hint: "[triage|boot|network|packages|virtualization|storage|performance|desktop|server|immutable|security|containers|kernel|logs] [symptom]"
license: Apache-2.0
---

Troubleshoots Linux incidents with a distro-aware, evidence-first workflow for mutable and immutable systems, desktop and server roles, and containerized workflows.

## Scope

Use this skill for:

- Boot failures, degraded services, and login issues
- Network and DNS failures
- Package/update/rollback problems
- Desktop stack issues (Wayland/X11, audio, GPU, input)
- Server incidents (SSH, firewall, daemon failures, disk pressure)
- Immutable systems (rpm-ostree, transactional-update, NixOS)
- Container stack issues (Distrobox, Podman, Docker, cgroups, namespace boundaries)
- Virtualization stack issues (KVM/libvirt, QEMU, VirtualBox, VMware, nested virtualization)
- Kernel/driver faults and log-heavy debugging workflows

## Safety rules

1. Evidence before changes. Reproduce, gather logs, then fix.
2. Prefer reversible actions first.
3. Never run destructive commands unless explicitly requested.
4. Ask before rebooting, reimaging, repartitioning, or data migration.
5. For production servers, prioritize minimal-impact mitigation first.
6. Before applying any fix command, confirm whether the user wants the AI to run it or wants to run it themselves.
7. When unsure, stop and ask one focused question before risky changes.

## Setup (always run first)

0. Establish run context before diagnostics. If the user has not already answered, ask:

- **Target device**: main system/host, current sandbox/container, or another device over SSH?
- **Execution mode**: should the AI run approved fix commands, or should it provide commands for the user to run manually?

If the target is another device over SSH, ask for the SSH target string and do not run local diagnostics as if they describe the remote device. If the user chooses manual execution, gather read-only evidence when possible and present fix commands without running them.

1. Run mode detection on the chosen target:

```bash
uname -a
cat /etc/os-release
systemd-detect-virt || true
ps -p 1 -o comm=
```

2. Classify:

- **Family**: Debian/Ubuntu, Fedora/RHEL, Arch, openSUSE, Alpine, NixOS, other
- **Model**: mutable or immutable
- **Role**: desktop, server, mixed
- **Init**: systemd or alternative
- **Container context**: host, container, nested container
- **Target**: local host, current sandbox/container, or SSH remote
- **Execution mode**: AI-runs-approved-fixes or user-runs-fixes

3. Load these shared references before focused troubleshooting:

- [reference/evidence-checklist.md](reference/evidence-checklist.md)
- [reference/distro-matrix.md](reference/distro-matrix.md)
- [reference/rollback-patterns.md](reference/rollback-patterns.md)
- [reference/verification-patterns.md](reference/verification-patterns.md)

4. If first token matches a command, load its reference file and follow it.

## Command menu

If no argument is provided, first ask the run-context questions from Setup step 0, then show this table and ask what to run.

| Command | Focus | Typical checks |
|---|---|---|
| `triage [symptom]` | General incident intake | scope, impact, timeline, recent changes |
| `boot [symptom]` | Boot/login/startup | bootctl/grub, journal, targets, drivers |
| `network [symptom]` | Connectivity and DNS | link, routes, resolver, firewall, MTU |
| `packages [symptom]` | Package/update errors | repo health, locks, conflicts, signatures |
| `virtualization [symptom]` | Hypervisors and VMs | kvm modules, libvirt units, nested virt, guest boot |
| `storage [symptom]` | Disk and filesystem | usage, inode pressure, fs errors, mounts |
| `performance [symptom]` | CPU/memory/io bottlenecks | pressure, hot processes, io wait |
| `desktop [symptom]` | GUI/session/media/input | display manager, compositor, pipewire |
| `server [symptom]` | Services and remote access | systemd units, ports, auth, limits |
| `immutable [symptom]` | ostree/snapshots/declarative | deployment status, rollback/rebase |
| `security [symptom]` | auth/policy failures | sudo/polkit, SELinux/AppArmor, SSH |
| `containers [symptom]` | Distrobox/Podman/Docker issues | runtime, namespace, cgroup, bind mounts |
| `kernel [symptom]` | kernel modules/drivers/crashes | dmesg, module state, taint, firmware |
| `logs [symptom]` | log-centric diagnostics | journal slicing, service pivots, correlation |

If first word matches a command, focus the workflow on that area.
If not, treat the full input as a symptom and run `triage`.

## References

Command references:

- [reference/triage.md](reference/triage.md)
- [reference/boot.md](reference/boot.md)
- [reference/network.md](reference/network.md)
- [reference/packages.md](reference/packages.md)
- [reference/virtualization.md](reference/virtualization.md)
- [reference/storage.md](reference/storage.md)
- [reference/performance.md](reference/performance.md)
- [reference/desktop.md](reference/desktop.md)
- [reference/server.md](reference/server.md)
- [reference/immutable.md](reference/immutable.md)
- [reference/security.md](reference/security.md)
- [reference/containers.md](reference/containers.md)
- [reference/kernel.md](reference/kernel.md)
- [reference/logs.md](reference/logs.md)

Shared references:

- [reference/evidence-checklist.md](reference/evidence-checklist.md)
- [reference/distro-matrix.md](reference/distro-matrix.md)
- [reference/rollback-patterns.md](reference/rollback-patterns.md)
- [reference/verification-patterns.md](reference/verification-patterns.md)

## Output contract

For each troubleshooting run, provide:

1. **Diagnosis**: most likely root cause, with confidence level
2. **Immediate fix**: minimal-risk steps
3. **Durable fix**: long-term correction
4. **Rollback**: exact undo path
5. **Verification**: commands and expected healthy signals
6. **Incident doc**: create or update a concise Markdown report under `${LINUX_TROUBLESHOOTER_DOCS_DIR:-$HOME/docs}` before the final response

Also state the selected **target device** and **execution mode** in the final response and incident doc. For fix commands, distinguish commands already run by the AI from commands the user still needs to run manually.

Use the bundled helper from the active skill checkout when available:

````bash
bash scripts/new-incident-doc.sh "<topic>" <<'EOF'
# Incident: <topic>

## Diagnosis

## Immediate fix

## Durable fix

## Rollback
```bash
```

## Verification
```bash
```
EOF
````

If the helper is not available in the active harness copy, write the same report directly to `${LINUX_TROUBLESHOOTER_DOCS_DIR:-$HOME/docs}/$(date +%F)-<slug>.md`. Include the report path in the final answer. If the filesystem blocks writing the report, state that explicitly and provide the intended contents.

If information is missing, ask focused questions before applying risky changes.
