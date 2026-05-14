## logs

Use when the user asks for log-first investigation or symptom is too broad.

Workflow:

1. Define time window and affected component.
2. Pull relevant slices:
   - boot scope: `journalctl -b --since "<time>" --no-pager`
   - unit scope: `journalctl -u <unit> --since "<time>" --no-pager`
   - priority scope: `journalctl -p warning..alert --since "<time>" --no-pager`
3. Correlate with system events:
   - service restart loops
   - package updates
   - network link flaps
4. Produce one evidence-backed hypothesis with confidence.
