---
name: linux-troubleshooter
description: Use when troubleshooting Linux issues across distro families and deployment models, including mutable and immutable systems, desktop and server environments.
version: 2.2.2
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
8. Never ask the user to paste passwords, PINs, recovery keys, tokens, or other secrets into chat. If a privileged command needs authentication and the execution harness supports an interactive terminal, run it with a TTY so sudo/polkit/SSH can read the secret locally from the prompt. If the user accidentally pastes a secret into chat, do not repeat it, store it, or use it; tell the user to enter secrets only in the local prompt.

## Authentication for privileged commands

When the user chooses AI-runs-approved-fixes and a command requires privilege:

- Prefer the harness/tool option that allocates an interactive TTY, so `sudo`, fingerprint, polkit, or SSH password prompts are handled outside chat.
- Do not use `sudo -S`, askpass wrappers, environment variables, shell history, temporary files, or chat-provided secrets to pass passwords.
- If authentication times out or the user interrupts it, check for partially completed work before retrying.
- If TTY authentication is unavailable or repeatedly fails, switch to user-runs-fixes mode for that command and provide the exact command for the user to run manually.
- After an interrupted privileged operation, verify the system state before continuing, especially for operations that can leave services stopped or devices inactive.

## Setup (always run first)

0. Establish run context before diagnostics.

First, automatically identify the current target when read-only local detection is available. Prefer the bundled helper from the active skill checkout:

```bash
bash scripts/detect-mode.sh
```

If the helper is unavailable, use read-only detection commands directly:

```bash
hostname
hostnamectl chassis 2>/dev/null || true
hostnamectl status 2>/dev/null || true
uname -a
cat /etc/os-release
systemd-detect-virt || true
ps -p 1 -o comm=
```

Use the detection output to infer whether the current execution context is a host, desktop, server, mixed-use workstation, immutable system, container, VM, or hypervisor-capable system. Treat `hostnamectl` chassis/deployment, `/etc/os-release`, PID 1, virtualization/container detection, display-manager/session signals, service signals, package-manager availability, container-runtime availability, and virtualization tooling as evidence. Interpret `hostnamectl chassis` values such as `laptop`, `desktop`, `convertible`, `tablet`, or `handset` as desktop-class evidence, and `server` as server-class evidence unless stronger contrary evidence exists.

Before asking the first prompt, show a short detected profile that includes at least: target hostname, chassis, deployment when known, OS/family, model, role, init, virtualization/container context, and recommended commands. If `chassis=unknown`, state that chassis was unavailable instead of omitting it.

After detection, ask only for unresolved context. If detection clearly shows the active troubleshooting target and the user did not ask for SSH or another machine, use the detected local target without asking the target-device question. Ask the target-device question only when:

- the user explicitly mentions another device, remote host, SSH, production host, VM guest, or host system outside the current sandbox/container;
- detection shows a sandbox/container but the symptom sounds like host hardware, boot, kernel, desktop session, disk partitioning, or another host-level issue;
- the target is ambiguous enough that local diagnostics could describe the wrong machine.

Always establish execution mode before applying fixes. If the user has not already answered, ask:

- **Execution mode**: should the AI run approved fix commands, or should it provide commands for the user to run manually?

Use selectable UI prompts for these required choices whenever the active harness provides them, so the user can choose with arrow keys instead of typing. If a selectable prompt supports only a few choices, ask in stages rather than falling back to free-text input:

- Target device, only when unresolved: detected local target, main system/host, current sandbox/container, or SSH remote.
- Execution mode: AI runs approved fix commands, or user runs commands manually.

If the target is another device over SSH, ask for the SSH target string and do not run local diagnostics as if they describe the remote device. If the user chooses manual execution, gather read-only evidence when possible and present fix commands without running them.

1. Run mode detection on the chosen target. If the helper was not already run in step 0, run it now:

```bash
bash scripts/detect-mode.sh
```

If the helper is unavailable, run the fallback commands from step 0.

2. Classify:

- **Family**: Debian/Ubuntu, Fedora/RHEL, Arch, openSUSE, Alpine, NixOS, other
- **Model**: mutable or immutable
- **Chassis**: `hostnamectl chassis` value when available, otherwise unknown
- **Role**: desktop, server, mixed
- **Init**: systemd or alternative
- **Container context**: host, container, nested container
- **Target**: local host, current sandbox/container, or SSH remote
- **Execution mode**: AI-runs-approved-fixes or user-runs-fixes
- **Recommended commands**: filtered troubleshooting commands derived from the classification

3. Load prior incident context from `${LINUX_TROUBLESHOOTER_DOCS_DIR:-$HOME/docs}` when available.

Use prior docs as context, not as proof. Prefer recent and topic-relevant Markdown files, especially incident reports created by this skill. Keep this selective:

```bash
find "${LINUX_TROUBLESHOOTER_DOCS_DIR:-$HOME/docs}" -maxdepth 1 -type f -name '*.md' -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -20
```

Then search/read only likely relevant files, using filenames, headings, and keywords from the current symptom, service names, device names, package names, and error text. For example:

```bash
rg -n -i 'keyword|service|device|error' "${LINUX_TROUBLESHOOTER_DOCS_DIR:-$HOME/docs}" 2>/dev/null
```

Summarize any relevant prior findings, fixes, rollback notes, and verification results before deciding on a new fix. Do not bulk-load unrelated notes or treat stale docs as current system state.

4. Load these shared references before focused troubleshooting:

- [reference/evidence-checklist.md](reference/evidence-checklist.md)
- [reference/distro-matrix.md](reference/distro-matrix.md)
- [reference/rollback-patterns.md](reference/rollback-patterns.md)
- [reference/verification-patterns.md](reference/verification-patterns.md)

5. If first token matches a command, load its reference file and follow it.

## Command menu

If no argument is provided, first run the detection and run-context flow from Setup step 0, then build a filtered troubleshooting menu from the detected system profile. Do not show every command by default. Present only commands that fit the selected target, plus `triage` and `logs` as universal fallbacks. Do not require the user to type a command name when a selection control can be used.

Use these filtering rules unless the helper already produced a `recommended_commands` list:

- Always include: `triage`, `logs`, `network`, `storage`, `performance`, `security`.
- Include `packages` when a package manager or immutable deployment tool exists.
- Include `boot` and `kernel` only for host/VM targets, not ordinary containers.
- Include `desktop` only when display/session/display-manager evidence exists, or the role is desktop/mixed.
- Include `server` when server services, SSH, service-manager use, or headless/server role evidence exists.
- Include `immutable` only for rpm-ostree, ostree-booted, transactional-update, NixOS, or snapshot/declarative systems.
- Include `containers` when the target is a container or has Podman, Docker, containerd, Distrobox, or cgroup/container namespace symptoms.
- Include `virtualization` only when the target is not an ordinary container and KVM/libvirt/QEMU/VirtualBox/VMware/nested-virt evidence exists, or the symptom explicitly concerns VMs.

If a user enters a command directly, honor it even if it was filtered out of the menu, then note why it was not part of the recommended menu. If the symptom strongly implies a filtered-out command, add that command back for this run.

For selectable prompts with small choice limits, use staged selection:

1. Choose a group, but include only groups that contain at least one recommended command:
   - Intake and logs: `triage`, `logs`, `security`
   - System and platform: `boot`, `packages`, `immutable`, `kernel`, `virtualization`
   - Operations and runtime: `network`, `storage`, `performance`, `desktop`, `server`, `containers`
2. Choose the command inside the selected group after removing commands not recommended for the detected target. If the group has more choices than the UI supports, split it into short pages and include a "more" choice.
3. Ask for an optional symptom as free text only after the command is selected. Allow the user to skip it.

When selectable prompts are unavailable, show a filtered table using the detected profile and accept either a command name, a number, or a full symptom. If the input is a number, map it to the filtered table order. Use the full table below only as the command catalog and as the fallback if detection cannot run.

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

Also state the selected **target device**, detected **chassis**, and **execution mode** in the final response and incident doc. For fix commands, distinguish commands already run by the AI from commands the user still needs to run manually.

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
