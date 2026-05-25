# linux-troubleshooter

`linux-troubleshooter` is a Codex/Copilot/Claude skill for evidence-first Linux
incident work. It helps an AI assistant identify the target system, gather the
right logs, classify the distro and deployment model, propose reversible fixes,
and write a concise incident report.

The skill is designed for real desktop, laptop, server, container, VM, and
immutable Linux troubleshooting. It favors read-only diagnostics first and asks
before privileged or risky changes.

## What It Helps With

- Boot failures, degraded services, and login issues
- Network, DNS, and firewall problems
- Package, update, rollback, and repository errors
- Desktop issues involving Wayland, X11, audio, GPU, input, and sessions
- Server incidents involving SSH, services, ports, authentication, and limits
- Storage pressure, filesystem warnings, and disk layout analysis
- Performance problems involving CPU, memory, swap, I/O wait, and pressure
- Immutable systems such as rpm-ostree, transactional-update, and NixOS
- Containers, Distrobox, Podman, Docker, cgroups, and bind mounts
- Virtualization stacks such as KVM, libvirt, QEMU, VirtualBox, and VMware
- Kernel, firmware, driver, dmesg, and journal-heavy debugging

## How It Works

Every run follows the same basic shape:

1. Detect the current environment with read-only commands.
2. Classify the target by distro family, mutability, role, init system, chassis,
   and container or virtualization context.
3. Ask only for unresolved context, such as whether to run approved fixes or
   provide manual commands.
4. Gather evidence before recommending changes.
5. Prefer reversible mitigations.
6. Include rollback and verification steps.
7. Create or update an incident report under
   `${LINUX_TROUBLESHOOTER_DOCS_DIR:-$HOME/docs}`.

## Quick Start

Invoke the skill from a supported AI harness:

```bash
$linux-troubleshooter triage laptop freezes after suspend
$linux-troubleshooter storage disk usage is high
$linux-troubleshooter logs why did this service fail
$linux-troubleshooter network DNS works in browser but not terminal
$linux-troubleshooter containers podman volume permission denied
```

These examples are tested with Codex. Other AI harnesses may use a different
skill invocation syntax, prompt prefix, or slash-command format, but the
underlying workflow is the same.

The general format is:

```bash
$linux-troubleshooter <command> <symptom>
```

You can also provide only a symptom. The skill will treat it as a triage run:

```bash
$linux-troubleshooter my laptop suddenly freezes and the disk LED stays busy
```

## Commands

| Command          | Focus                               | Typical evidence                                      |
| ---------------- | ----------------------------------- | ----------------------------------------------------- |
| `triage`         | General incident intake             | scope, impact, timeline, recent changes               |
| `logs`           | Log-first diagnostics               | journal slices, service pivots, correlated events     |
| `boot`           | Boot, login, startup                | boot entries, targets, drivers, boot journal          |
| `network`        | Connectivity and DNS                | links, routes, resolver, firewall, MTU                |
| `packages`       | Package/update failures             | repo health, locks, conflicts, signatures             |
| `storage`        | Disk and filesystem                 | `lsblk`, `df`, `findmnt`, Btrfs usage, inode pressure |
| `performance`    | CPU, memory, swap, I/O              | `vmstat`, pressure stall info, hot processes, iowait  |
| `desktop`        | GUI/session/media/input             | display manager, compositor, PipeWire, GNOME/KDE logs |
| `server`         | Services and remote access          | systemd units, ports, SSH, auth, limits               |
| `immutable`      | Ostree/snapshot/declarative systems | deployments, rollback, rebase, generations            |
| `containers`     | Container runtimes                  | Podman, Docker, Distrobox, cgroups, namespaces        |
| `virtualization` | Hypervisors and VMs                 | KVM modules, libvirt units, nested virt, guest boot   |
| `security`       | Auth and policy failures            | sudo, polkit, SELinux, AppArmor, SSH                  |
| `kernel`         | Kernel, module, firmware issues     | dmesg, taint, module state, firmware warnings         |

## Example Sessions

### Storage Pressure

```bash
User:
$linux-troubleshooter storage can you analyze why my disk is almost full?

Assistant:
- detects the host/container boundary
- gathers `lsblk`, `df`, `findmnt`, Btrfs usage, and top `du` consumers
- explains the largest directories and low-risk cleanup targets
- writes an incident note with rollback and verification commands
```

### Performance Freeze

```bash
User:
$linux-troubleshooter my laptop freezes and I think swap is involved

Assistant:
- checks memory, swap, zram, pressure stall info, vmstat, iostat, and journals
- separates memory pressure from I/O pressure
- recommends process-level I/O checks instead of changing `vm.swappiness`
- writes an incident note for future comparison
```

### Immutable Update Issue

```bash
User:
$linux-troubleshooter immutable rpm-ostree upgrade failed after layering package

Assistant:
- identifies the immutable model
- checks deployment status and update logs
- recommends rollback or cleanup steps with explicit undo paths
- verifies the active deployment after the fix
```

Good demo recordings should be short, readable, and safe to publish. Avoid
showing hostnames, usernames, private paths, tokens, SSH targets, local IPs,
serial numbers, or journal lines that reveal personal data.

## Repository Layout

```bash
skill/
  SKILL.md                 canonical skill instructions
  reference/               focused workflows for each command
  scripts/                 helper scripts used by the skill

scripts/
  sync-skill.sh            mirror skill/ into harness-specific skill folders
  new-incident-doc.sh      create a dated incident report

HARNESSES.md               list of mirrored harness targets
README.md                  project overview
```

The canonical source is `skill/`. Harness-specific directories are generated
mirrors.

## Sync Workflow

Edit `skill/` first, then mirror the skill into supported harness directories:

```bash
bash scripts/sync-skill.sh
```

The sync script currently mirrors to:

- `.github/skills/linux-troubleshooter/`
- `.agents/skills/linux-troubleshooter/`
- `.claude/skills/linux-troubleshooter/`
- `.codex/skills/linux-troubleshooter/`

## Incident Reports

The skill writes short incident reports so each troubleshooting session leaves a
usable trail. By default, reports go to `~/docs`.

Create one manually:

```bash
bash scripts/new-incident-doc.sh "storage pressure"
```

Override the destination:

```bash
LINUX_TROUBLESHOOTER_DOCS_DIR="$PWD/docs/incidents" \
  bash scripts/new-incident-doc.sh "storage pressure"
```

Each report should include:

- Diagnosis with confidence level
- Immediate fix
- Durable fix
- Rollback
- Verification commands and expected healthy signals
- Target device, chassis, and execution mode

## Safety Model

The skill is intentionally conservative:

- Gather evidence before changes.
- Prefer read-only diagnostics first.
- Ask before privileged fix commands.
- Never request passwords, PINs, recovery keys, tokens, or sudo secrets in chat.
- Use an interactive local prompt for privileged commands when needed.
- Avoid destructive actions unless the user explicitly requests them.
- Include rollback and verification with every non-trivial fix.

### Sudo and Password Prompts

Fingerprint authentication is convenient, but the skill must also work on
machines without a fingerprint reader. In that case, privileged commands should
use a real local authentication prompt that the user controls.

Safe patterns:

- Run privileged commands in an interactive TTY so `sudo`, polkit, or SSH can
  ask for the password locally.
- Let the user type the password into that local prompt, not into the AI chat.
- If the harness cannot provide a local interactive prompt, switch to manual
  mode and print the exact command for the user to run themselves.

Unsafe patterns:

- Do not paste passwords into chat.
- Do not use `sudo -S`.
- Do not use askpass wrappers created by the AI.
- Do not put passwords in environment variables, temporary files, shell history,
  command arguments, or scripts.

The AI agent may see the command and its normal output. It should not see the
secret used to authorize that command.

## Installed Skill Hardening

GitHub protects the remote source of truth, but it does not protect an already
installed local copy under `~/.codex/skills/`. To make the installed skill
read-only to normal chat/workspace edits, lock the local install after syncing:

```bash
sudo chown -R root:root ~/.codex/skills/linux-troubleshooter
sudo chmod -R a-w ~/.codex/skills/linux-troubleshooter
sudo chattr -R +i ~/.codex/skills/linux-troubleshooter
```

To update the installed copy later, unlock it locally, sync or reinstall from
GitHub, then lock it again:

```bash
sudo chattr -R -i ~/.codex/skills/linux-troubleshooter
sudo chown -R "$USER:$USER" ~/.codex/skills/linux-troubleshooter
sudo chmod -R u+w ~/.codex/skills/linux-troubleshooter
```

## Future Web Docs

A later web documentation site can build from the same structure:

- Overview and safety model
- Command reference pages
- Copyable prompt examples
- Troubleshooting report examples
- GIF demos and short terminal recordings
- Harness setup and sync instructions

Keep `skill/` as the source of truth, and use web docs as a friendlier reading
layer rather than a separate instruction source.

## License

Apache-2.0
