# Security

AgentDesk is a remote shell and browser workspace. Treat it like a sensitive administration surface.

## Baseline guidance

- Do not expose root shells publicly without extra protection.
- Put Cloudflare Access, VPN, MFA, or IP allowlists in front of the service.
- Rotate leaked passwords immediately.
- Prefer non-root development workspaces wherever possible.
- Keep ttyd-style access behind an authenticated reverse proxy.

## Recommended access model

1. Keep the service private by default.
2. Publish it only through an authenticated edge.
3. Restrict access with identity-aware controls.
4. Use strong unique credentials for any HTTP authentication layer.
5. Limit the shell user privileges to the minimum needed for the workload.

## Operational notes

- Never commit secrets into Git.
- Treat `.env` files as local-only configuration.
- Audit exposed ports before going live.
- If you suspect credential leakage, rotate credentials first and investigate second.

## What not to do

- Do not publish an unauthenticated shell to the public internet.
- Do not assume obscurity is a security control.
- Do not run long-lived privileged workloads unless you have a clear reason.

## Safer default

If you need internet access, place the service behind Cloudflare Access or another authenticated reverse proxy and keep the workspace itself as private as possible.
