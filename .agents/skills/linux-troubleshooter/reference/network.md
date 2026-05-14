## network

Use for link, routing, DNS, and intermittent connectivity issues.

Typical checks:

- link and addresses: `ip -br link`, `ip -br addr`
- routes: `ip route`
- DNS resolver:
  - `resolvectl status` (systemd-resolved)
  - `/etc/resolv.conf` ownership/source
- reachability:
  - gateway ping
  - external IP ping
  - domain lookup (`getent hosts`, `dig`, `nslookup`)
- firewall/policy:
  - nftables/firewalld/ufw status

Mitigation order:

1. Restore link and default route.
2. Restore resolver path.
3. Correct firewall rule with minimal scope.
4. Validate MTU if only some destinations fail.
