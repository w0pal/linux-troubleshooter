## triage

Use for unknown or mixed symptoms.

Workflow:

1. Frame impact and timeline.
2. Classify likely layer:
   - hardware, kernel, init, network, service, app
3. Gather minimal high-value evidence:
   - `systemctl --failed --no-pager`
   - `journalctl -b -p warning..alert --no-pager | tail -n 200`
   - `dmesg --level=err,warn | tail -n 200`
4. Choose one focused next command (`boot`, `network`, `storage`, etc.).
5. Deliver diagnosis + immediate mitigation + durable path.
