# Security

AgentDesk exposes a browser-accessible shell. Treat it with the same care as SSH access to the host.

## Recommended Deployment

Use at least one authenticated access layer before users reach AgentDesk:

- Cloudflare Access
- Tailscale
- WireGuard
- VPN
- trusted reverse proxy with HTTPS and access control

Recommended baseline:

1. HTTPS at the edge.
2. Authenticated access before the browser terminal loads.
3. Strong credentials when HTTP authentication is enabled.
4. Non-root day-to-day user for development work.
5. Limited access to trusted operators only.

## What Not To Do

Do not expose AgentDesk as an unauthenticated public internet service.

Do not treat the browser terminal as a sandbox for untrusted users.

Do not run unknown workloads unless you would also run them in a normal SSH session on the same host.

## Threat Model

AgentDesk is intended for trusted developers and operators who need remote browser access to a development shell. The main risks are the same risks as remote shell access:

- credential theft
- weak access control
- exposed public endpoints
- command execution by an unauthorized user
- accidental changes to host files or services
- secrets visible in the terminal environment

## Secrets

Keep secrets out of screenshots, logs, issues, and demo recordings. Avoid pasting API keys into public bug reports.

If you suspect a secret was exposed, rotate it immediately.

## Network Exposure

The recommended public entrypoint is the browser-facing proxy service behind an authenticated edge. Do not expose internal bridge ports directly to the public internet.

For Coolify deployment notes, see [COOLIFY.md](./COOLIFY.md).

## Reporting Security Issues

Please avoid filing public issues for exploitable security reports. Use the repository owner's preferred private contact path if one is listed on GitHub, or open a minimal issue asking for a secure disclosure channel without including exploit details.
