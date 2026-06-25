# AgentDesk

> Self-hosted browser workspace for AI coding agents, remote terminals, and GitOps-driven development.

AgentDesk is a practical, self-hosted remote development console for developers who want to use terminal-native AI coding agents from any browser, tablet, or lightweight device.

It is designed for:

- Claude Code
- OpenAI Codex
- Hermes
- OpenCode
- OpenClaw
- SSH workspaces
- containerized development environments

## What is AgentDesk?

AgentDesk is a browser-based workspace layer that exposes a secure remote console to your own infrastructure.

It gives you a way to:

- open a shell in the browser
- reach AI coding agents from anywhere
- connect to remote workspaces and DevOps tools
- keep the actual compute on your server, VPS, or container host

The repository currently ships with a working Docker Compose deployment that has been used successfully with Coolify, Traefik routing, Caddy as an internal proxy, and persistent remote access.

## Why AgentDesk?

Developers increasingly use Claude Code, Codex, Hermes, and other terminal-native coding agents, but they often need a secure way to access those agents from any browser, tablet, or lightweight device.

AgentDesk exists to make that workflow practical:

- no laptop required for every task
- no exposed raw shell on the public internet
- no dependency on a full remote desktop stack
- no vendor lock-in to a single hosted IDE
- no need to rebuild the same environment on every device

## Why this exists

The common pattern is simple: you have a powerful machine, a remote VPS, or a self-hosted workspace, and you want to interact with it safely from anywhere.

AgentDesk turns that into a browser-first workflow for terminal-native coding agents and operational tasks. You keep the workspace under your control, then layer on authentication, reverse proxying, and GitOps-friendly deployment.

## Who is it for?

- Developers who use Claude Code, OpenAI Codex, Hermes, OpenCode, or OpenClaw
- DevOps and platform engineers managing remote shells and admin workflows
- Builders who want a browser terminal on a VPS or home lab
- Teams that prefer self-hosted infrastructure over a SaaS IDE
- People who want to code from an iPad, phone, Chromebook, or travel laptop

## Features

- Browser-accessible remote console
- Coolify-friendly deployment
- Traefik-compatible routing
- Caddy internal reverse proxy
- Persistent remote access workflow
- Support for SSH-style and containerized development setups
- GitOps-first operating model
- Designed for secure self-hosting

## Security first

AgentDesk is intentionally positioned as a secure remote console, not a public shell endpoint.

Recommended protections:

- Cloudflare Access
- VPN
- MFA
- IP allowlists
- authenticated reverse proxying

Do not expose root shells publicly without additional protection.

See [docs/SECURITY.md](./docs/SECURITY.md) for the full guidance.

## Architecture

AgentDesk uses a layered proxy chain that keeps the browser entry point separate from the shell backend.

See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) for the diagram and component breakdown.

## Quick Start with Coolify

1. Create a new service in Coolify from this repository.
2. Keep the root [`docker-compose.yml`](./docker-compose.yml) in place.
3. Set your environment variables:
   - `HTTP_USERNAME`
   - `HTTP_PASSWORD`
4. Assign your domain in Coolify to `ttyd-proxy`, using the internal container port, for example `https://agentdesk.example.com:8080`.
5. Deploy.
6. Users will access `https://agentdesk.example.com`.
7. Put Cloudflare Access, VPN, or another authenticated edge in front of it.

If you need a step-by-step deployment guide, see [docs/COOLIFY.md](./docs/COOLIFY.md).

## Important Coolify Configuration

AgentDesk consists of two containers:

- `ttydbridge` runs `ttyd`
- `ttyd-proxy` runs Caddy

Coolify MUST point the domain to `ttyd-proxy`.

Example:

```text
Service:
ttyd-proxy

Domain:
https://agentdesk.example.com:8080
```

End users access:

```text
https://agentdesk.example.com
```

Do not attach domains to `ttydbridge`.

Do not expose `:8080` publicly.

Doing so will likely produce:

- `502 Bad Gateway`
- `504 Gateway Timeout`
- `Connection refused`

> ⚠️ Important: If you get 502/504 errors on Coolify, ensure your domain is attached to `ttyd-proxy` with `:8080`, not to `ttydbridge`.

## Common Coolify Mistakes

Wrong:

```text
ttydbridge
https://agentdesk.example.com
```

Correct:

```text
ttyd-proxy
https://agentdesk.example.com:8080
```

## Environment Variables

Create a `.env` file from the example values:

```bash
cp .env.example .env
```

Required variables:

- `HTTP_USERNAME`
- `HTTP_PASSWORD`

Optional variables may be added later as the platform expands.

## Deploy in Coolify

The current stack is intentionally small and easy to deploy:

- `ttydbridge` handles the remote terminal backend
- `caddy:2-alpine` provides an internal proxy layer
- Traefik/Coolify handles external routing

Use the existing compose file at the repository root. Do not move it unless you are intentionally changing the deployment model.

For operational details, see [docs/COOLIFY.md](./docs/COOLIFY.md).

## Cloudflare Access recommendation

If you expose AgentDesk beyond a private network, put Cloudflare Access in front of it.

That gives you an extra authentication and policy layer before traffic ever reaches the shell backend.

Recommended access patterns:

- Cloudflare Access
- VPN-first access
- MFA-protected identity provider login
- IP allowlisted perimeter

See [docs/SECURITY.md](./docs/SECURITY.md) for the security model.

## GitHub/GitOps workflow

AgentDesk is built for a GitOps-first workflow:

- commit changes to Git
- push to your repository
- let Coolify redeploy from source
- keep runtime configuration in environment variables
- treat the shell host as infrastructure, not a snowflake machine

Typical flow:

```bash
git clone <your-fork-or-origin>
cd AgentDesk
cp .env.example .env
# edit .env with safe values
git add .
git commit -m "Document AgentDesk deployment"
git push
```

## Use cases

- Remote access to Claude Code from a browser
- Remote access to OpenAI Codex from an iPad
- SSH workspace access while traveling
- Operator consoles for DevOps work
- Container-based agent sandboxes
- Browser-based admin shells on a VPS or home lab
- Secure remote troubleshooting without a VPN-only workflow

## Roadmap

See [docs/ROADMAP.md](./docs/ROADMAP.md) for the phased roadmap.

## FAQ

### How do I run Claude Code in a browser?

Deploy AgentDesk, then connect to the browser console through the authenticated edge. The shell and agent runtime stay on your server.

### How do I access OpenAI Codex remotely?

Expose AgentDesk through Coolify, then protect it with Cloudflare Access, VPN, MFA, or an IP allowlist. Use the browser console to reach your remote workspace.

### Can I use AgentDesk with Hermes?

Yes, if your Hermes workflow runs in a terminal or containerized workspace that can be reached through the AgentDesk shell layer.

### Can I deploy AgentDesk with Coolify?

Yes. The current repository is structured around a working Coolify-friendly Docker Compose deployment.

### Is AgentDesk a replacement for GitHub Codespaces?

Not exactly. AgentDesk is a self-hosted browser workspace and remote console. It can cover similar workflows, but it is focused on your own infrastructure and GitOps control.

### Should I expose ttyd directly to the internet?

No. Keep `ttyd`-style access behind an authenticated reverse proxy and additional perimeter controls.

### Can I use AgentDesk from an iPad or phone?

Yes. That is one of the main use cases. It is designed for browser access on lightweight devices.

## GitHub topic recommendations

If you publish this repository on GitHub, recommended topics include:

`claude-code`, `codex`, `openai-codex`, `hermes`, `opencode`, `openclaw`, `ai-agent`, `coding-agent`, `browser-terminal`, `web-terminal`, `remote-development`, `cloud-ide`, `coolify`, `docker`, `gitops`, `self-hosted`, `ssh`, `cloudflare-access`, `devops`, `vps`

## Keywords

Self-hosted browser workspace, remote development console, browser terminal, web terminal, AI coding agent workspace, secure remote shell, Coolify deployment, GitOps remote development, Cloudflare Access protected terminal, SSH workspace, containerized development environment.

## License

See [LICENSE](./LICENSE).
