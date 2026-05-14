## Evidence checklist

Use this checklist for every command before proposing non-trivial changes.

1. Frame the incident:
   - What is broken?
   - Who is affected?
   - Since when?
   - What changed recently?
2. Capture runtime context:
   - distro family, model, init, container status
3. Collect core evidence:
   - `journalctl -b --no-pager | tail -n 200`
   - `systemctl --failed --no-pager`
   - `dmesg --level=err,warn | tail -n 200`
4. Collect area-specific evidence from the selected command reference.
5. Confirm scope boundaries:
   - single host or fleet
   - user session only or whole system
6. Make one reversible mitigation first when possible.
