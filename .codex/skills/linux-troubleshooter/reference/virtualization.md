## virtualization

Use for host/guest virtualization failures: KVM/libvirt, QEMU, VirtualBox, VMware, and nested virtualization issues.

Typical checks:

1. CPU virtualization flags and module state:
   - `lscpu | rg -i 'virtualization|hypervisor'`
   - `lsmod | rg -E 'kvm|kvm_amd|kvm_intel|vbox|vmw'`
2. Hypervisor service health:
   - `systemctl status libvirtd --no-pager`
   - `systemctl --user status podman --no-pager` (if rootless VM workflows apply)
3. Device access and permissions:
   - `/dev/kvm` presence and ownership
   - user membership for virtualization groups when required
4. Guest launch/log evidence:
   - `virsh list --all`
   - `journalctl -u libvirtd --no-pager | tail -n 120`
5. Nested virtualization constraints:
   - check host hypervisor and whether nested virt is enabled

Mitigation order:

1. Restore host hypervisor service and `/dev/kvm` access.
2. Validate one known-good VM start path.
3. Apply durable module/service configuration only after evidence confirms root cause.
