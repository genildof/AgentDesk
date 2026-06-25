# AgentDesk

> Self-hosted browser terminal for AI coding agents, remote development, and GitOps-first workflows.

AgentDesk is a self-hosted browser terminal and remote development console for Claude Code, OpenAI Codex, Hermes, OpenCode, OpenClaw, SSH workspaces, and containerized dev environments.

**Security first:** this is a remote shell surface. Put it behind Cloudflare Access, VPN, MFA, or IP allowlists. Do not expose ttyd directly to the internet.

## Important Coolify Configuration

AgentDesk has two services:

- `ttydbridge` runs `ttyd`
- `ttyd-proxy` runs Caddy

Coolify must attach the domain to `ttyd-proxy`, not to `ttydbridge`.

Example:

```text
Service:
ttyd-proxy

Domain:
https://agentdesk.example.com:8080
```

Users access:

```text
https://agentdesk.example.com
```

Do not expose `:8080` publicly. If the domain is attached to `ttydbridge`, you will likely hit `502 Bad Gateway`, `504 Gateway Timeout`, or `Connection refused`.

See [docs/COOLIFY.md](./docs/COOLIFY.md) for the validated deployment path.

## What is AgentDesk?

AgentDesk is a self-hosted browser workspace, web terminal, and remote development environment for AI coding agents and remote shell workflows.

It lets you:

- open a browser terminal or web terminal
- reach agent tooling from anywhere, on any device
- keep compute on your server, VPS, container host, or home lab
- manage development, DevOps, and remote administration without a full desktop

The root `docker-compose.yaml` is the file Coolify looks for in this repo. The matching `docker-compose.yml` is kept alongside it for compatibility.

## Why AgentDesk?

Developers increasingly use terminal-native AI coding agents, but they still need a safe way to access those tools from a browser, tablet, or lightweight device. AgentDesk is a self-hosted alternative that makes browser-based remote development practical without depending on a hosted IDE or carrying a laptop everywhere.

## Why this exists

You may have a powerful machine, a VPS, a home lab, or a Kubernetes node, but you still want to interact with it safely from a browser. AgentDesk turns that into a clean, self-hosted remote development workflow for coding agents, SSH access, and operational work.

## Who is it for?

- Developers using Claude Code, OpenAI Codex, Hermes, OpenCode, or OpenClaw
- DevOps, platform, and infrastructure engineers
- VPS, bare metal, and home lab users
- Teams that prefer self-hosted infrastructure over SaaS cloud IDEs
- People who want to code from an iPad, phone, Chromebook, or travel laptop

## Features

- Browser-accessible remote console and browser terminal
- Coolify-friendly deployment with Docker Compose
- Traefik-compatible routing behind an authenticated edge
- Caddy as an internal reverse proxy bridge
- GitOps-first workflow for remote development
- SSH and containerized workspace support
- Designed for secure self-hosting and private access

## Architecture

AgentDesk uses a layered proxy chain:

```text
Internet -> Cloudflare Access -> Coolify/Traefik -> Caddy -> ttydbridge -> Host/Workspace
```

See [docs/ARCHITECTURE.md](./docs/ARCHITECTURE.md) for the full diagram.

## Quick Start with Coolify

1. Add this repository as a new service in Coolify.
2. Keep the root [`docker-compose.yaml`](./docker-compose.yaml) in place. `docker-compose.yml` remains available too.
3. Set `HTTP_USERNAME` and `HTTP_PASSWORD`.
4. Attach the domain to `ttyd-proxy` using `https://agentdesk.example.com:8080`.
5. Deploy.
6. Users access `https://agentdesk.example.com`.
7. Put Cloudflare Access, VPN, MFA, or IP allowlists in front of it.

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

Do not attach the public domain to `ttydbridge`.

## Environment Variables

Copy the example file and edit it:

```bash
cp .env.example .env
```

Required:

- `HTTP_USERNAME`
- `HTTP_PASSWORD`

## Security Model

AgentDesk is intentionally not a public shell endpoint or public ttyd instance.

Recommended controls:

- Cloudflare Access for identity-aware access
- VPN
- MFA
- IP allowlists
- authenticated reverse proxying in front of ttyd

Do not expose root shells publicly without extra protection. Prefer non-root workspaces whenever possible.

See [docs/SECURITY.md](./docs/SECURITY.md).

## Cloudflare Access Recommendation

If AgentDesk is reachable from the internet, place Cloudflare Access in front of it. That gives you identity-aware protection before traffic reaches the shell backend.

## GitHub / GitOps Workflow

AgentDesk fits a GitOps-first workflow for self-hosted remote development:

- change config in Git
- push to your repo
- let Coolify redeploy
- keep runtime secrets in environment variables and never commit them
- treat the workspace as infrastructure, not a local-only snowflake machine

```bash
git clone <your-fork-or-origin>
cd AgentDesk
cp .env.example .env
# edit .env

git add .
git commit -m "Update AgentDesk"
git push
```

## Deploy in Coolify

The current stack is intentionally small and works well for Coolify browser terminal deployments:

- `ttydbridge` provides the terminal backend
- `ttyd-proxy` provides the internal Caddy bridge
- Coolify/Traefik handles public routing for the browser workspace

Use the root compose file as-is unless you are intentionally changing the deployment model.

## Use Cases

- Run Claude Code in a browser
- Access OpenAI Codex remotely
- Use Hermes from a browser session
- Work from an iPad or phone
- Manage SSH workspaces while traveling
- Operate a browser terminal on a VPS, home lab, or bare metal server
- Run DevOps tasks without exposing a raw shell

## Roadmap

See [docs/ROADMAP.md](./docs/ROADMAP.md).

## FAQ

### How do I run Claude Code in a browser?

Deploy AgentDesk, protect it with an authenticated edge, and use the browser console to reach your remote shell.

### How do I access OpenAI Codex remotely?

Expose AgentDesk through Coolify, then put Cloudflare Access, VPN, MFA, or IP allowlists in front of it.

### Can I use AgentDesk with Hermes?

Yes. If Hermes runs in a terminal or containerized workspace, AgentDesk can provide browser access to it.

### Can I deploy AgentDesk with Coolify?

Yes. This repo is built around a working Coolify-friendly Docker Compose deployment.

### Is AgentDesk a replacement for GitHub Codespaces?

No. It is a self-hosted browser workspace and remote console. It can cover similar workflows, but it is centered on your own infrastructure.

### Should I expose ttyd directly to the internet?

No. Keep it behind an authenticated reverse proxy and additional perimeter controls.

### Can I use AgentDesk from an iPad or phone?

Yes. That is one of the core use cases.

## GitHub Topic Recommendations

`claude-code`, `codex`, `openai-codex`, `hermes`, `opencode`, `openclaw`, `ai-agent`, `coding-agent`, `browser-terminal`, `web-terminal`, `remote-development`, `cloud-ide`, `coolify`, `docker`, `gitops`, `self-hosted`, `ssh`, `cloudflare-access`, `devops`, `vps`

## Keywords

Self-hosted browser workspace, remote development console, browser terminal, web terminal, AI coding agent workspace, secure remote shell, Coolify deployment, GitOps remote development, Cloudflare Access protected terminal, SSH workspace, containerized development environment.

## License

See [LICENSE](./LICENSE).
