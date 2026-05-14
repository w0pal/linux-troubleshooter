## immutable

Use for image-based or declarative systems where mutable fixes are constrained.

Typical checks:

- deployment status and booted deployment
- layered package count and divergence
- pending deployment vs currently booted state
- rollback target availability

Strategy:

1. Prefer rollback to known-good deployment/generation.
2. If immediate mitigation is required, use supported mutable sidecar (container/toolbox/live environment).
3. Apply durable image/declarative fix, then redeploy.

Do not recommend mutable package hacks that bypass the platform model.
