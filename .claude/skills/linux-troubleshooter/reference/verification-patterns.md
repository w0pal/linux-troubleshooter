## Verification patterns

Every fix must include post-change validation.

Use these patterns:

1. Symptom check
   - user-observable behavior is restored
2. Service health
   - `systemctl is-active <unit>`
   - `systemctl is-failed <unit>`
3. Log sanity
   - `journalctl -u <unit> -n 100 --no-pager`
   - no crash loops or new critical errors
4. Adjacent impact
   - at least one nearby feature still works
5. Persistence
   - behavior survives restart/relogin when relevant
