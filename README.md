# AgentDesk

> Self-hosted Codespaces for AI coding agents. Run Claude Code, OpenAI Codex, Hermes, OpenCode, or OpenClaw from any browser, tablet, or locked-down workstation.

[![Docker](https://img.shields.io/badge/Docker-ready-2496ED?logo=docker&logoColor=white)](#quick-start)
[![Coolify](https://img.shields.io/badge/Coolify-friendly-111827)](docs/COOLIFY.md)
[![Self-hosted](https://img.shields.io/badge/self--hosted-yes-16a34a)](#why-agentdesk)
[![Security](https://img.shields.io/badge/security-authenticated%20edge-critical)](docs/SECURITY.md)

AgentDesk is a browser workspace for coding agents and terminal-native developer workflows. It gives you a remote developer workspace with SSH in the browser, Docker-based deployment, and a GitOps-friendly path for running AI coding agents on your own VPS, homelab, or lab server.

Use it when you want to:

- run Claude Code in a browser
- use OpenAI Codex from an iPad or tablet
- access Hermes, OpenCode, or OpenClaw remotely
- keep a persistent Docker workspace on your own infrastructure
- expose a browser terminal through Coolify, Traefik, Cloudflare Access, Tailscale, or a VPN
- create a self-hosted AI workstation without adopting a full cloud IDE platform

## Why AgentDesk

Most browser IDEs assume the editor is the product. AgentDesk assumes the agent and terminal are the product.

AgentDesk keeps the runtime simple: Coolify or Traefik routes to a Caddy proxy, Caddy forwards to ttydBridge, and ttydBridge attaches to a host shell. The result is a browser terminal for serious AI-assisted development without hiding the machine from you.

## Architecture

```text
Browser
  -> Coolify / Traefik
  -> ttyd-proxy on port 8080
  -> Caddy
  -> host.docker.internal:2222
  -> ttydbridge
  -> host shell
```

The working compose file is [`docker-compose.yaml`](./docker-compose.yaml). Do not rename it to `docker-compose.yml` in docs, automation, or examples.

## Features

- Browser terminal for Claude Code, OpenAI Codex, Hermes, OpenCode, OpenClaw, shell tools, and Git workflows.
- Coolify-friendly Docker Compose deployment using [`docker-compose.yaml`](./docker-compose.yaml).
- Works from laptops, tablets, iPad, Chromebooks, and restricted corporate devices with a modern browser.
- Persistent host workspace mounted into the remote session.
- Useful for VPS development, homelab automation, client environments, DevOps labs, and AI agent workstations.
- Simple enough to audit: Caddy, ttydBridge, Docker, and your existing host shell.

## Quick Start

1. Clone the repository.

```bash
git clone https://github.com/genildof/AgentDesk.git
cd AgentDesk
```

2. Create your environment file.

```bash
cp .env.example .env
```

3. Review the values in `.env` and deploy with Coolify or Docker Compose.

```bash
docker compose -f docker-compose.yaml up -d
```

4. Open your configured domain and sign in through your edge protection or configured authentication.

For Coolify-specific setup, read [docs/COOLIFY.md](./docs/COOLIFY.md).

## Domain Configuration

AgentDesk uses the `DOMAIN` environment variable for the Traefik host rule in [`docker-compose.yaml`](./docker-compose.yaml). Set it to the hostname users will open in their browser.

```bash
DOMAIN=my-agentdesk.example.com
```

Common examples:

```bash
DOMAIN=agentdesk.example.com
DOMAIN=agentdesk.internal
DOMAIN=agentdesk.company.com
```

Coolify example:

```text
Environment variable: DOMAIN=agentdesk.example.com
Public domain: https://agentdesk.example.com
Service: ttyd-proxy
Port: 8080
```

## Common Workflows

Start a coding agent from the browser terminal:

```bash
cd ~/workspace
claude
```

```bash
cd ~/workspace
codex
```

```bash
cd ~/workspace
hermes
```

```bash
cd ~/workspace
opencode
```

Use separate project folders for different workstreams:

```text
~/workspace/
  project-a/
  project-b/
  clients/
  opensource/
  lab/
```

## Security Model

AgentDesk exposes a shell. Treat it like SSH in a browser.

Recommended controls:

- Put AgentDesk behind Cloudflare Access, Tailscale, WireGuard, a VPN, or another authenticated edge.
- Use HTTPS at the edge.
- Use strong credentials when HTTP authentication is enabled.
- Run day-to-day work as a non-root user.
- Do not expose the service unauthenticated on the public internet.

Read the full security guidance in [docs/SECURITY.md](./docs/SECURITY.md).

## Documentation

- [Architecture](./docs/ARCHITECTURE.md): how requests flow from the browser to the host shell.
- [Coolify deployment](./docs/COOLIFY.md): deployment, routing, and troubleshooting notes.
- [Bootstrap guide](./docs/BOOTSTRAP.md): preparing a host for AI coding agents and developer tools.
- [Security](./docs/SECURITY.md): recommended controls and threat model.
- [Roadmap](./docs/ROADMAP.md): planned improvements and repository growth ideas.
- [Contributing](./CONTRIBUTING.md): how to propose changes without breaking the runtime architecture.

## FAQ

### How do I run Claude Code in a browser?

Deploy AgentDesk, open the browser terminal, move into your workspace, and run `claude`. AgentDesk provides the remote browser shell; Claude Code runs inside your host environment.

### How do I access OpenAI Codex remotely?

Open AgentDesk from your browser, authenticate through your configured edge, and run `codex` in the terminal. This is useful for using Codex from an iPad, tablet, Chromebook, or workstation where local setup is inconvenient.

### Can I use AgentDesk from an iPad?

Yes. AgentDesk is designed for browser access, so an iPad can connect to your remote developer workspace and run terminal-native AI coding agents.

### Can I run Hermes on a VPS?

Yes. Install Hermes on the host, deploy AgentDesk with [`docker-compose.yaml`](./docker-compose.yaml), and start `hermes` inside the browser terminal.

### Can I expose ttyd securely?

Yes, but do not expose it directly without authentication. Put AgentDesk behind an authenticated edge such as Cloudflare Access, Tailscale, WireGuard, a VPN, or a trusted reverse proxy with HTTPS and access control.

### Can AgentDesk replace GitHub Codespaces?

AgentDesk can replace Codespaces for terminal-first workflows where you want your own host, persistent workspace, and AI coding agents in a browser. It is not a full hosted IDE marketplace and does not try to manage ephemeral cloud workspaces for you.

### Can I use AgentDesk with Coolify?

Yes. AgentDesk is designed to deploy cleanly through Coolify using [`docker-compose.yaml`](./docker-compose.yaml). See [docs/COOLIFY.md](./docs/COOLIFY.md).

### How do I use SSH in a browser?

AgentDesk gives you an SSH-like browser terminal that reaches a host shell through ttydBridge. Protect it like SSH: authenticate at the edge, use HTTPS, and restrict who can connect.

### Can AgentDesk host multiple AI agents?

Yes. You can run different terminal-native agents, such as Claude Code, Codex, Hermes, OpenCode, or OpenClaw, from the same workspace. For isolated teams or projects, deploy separate instances with separate ports, domains, users, and workspaces.

### Can AgentDesk run on a homelab?

Yes. AgentDesk works well on homelab machines, small VPS instances, and lab servers when the host has Docker, a reachable domain or tunnel, and enough resources for your tools.

## Screenshots And Assets

The repository would be more star-worthy with visual proof. Recommended assets:

- `assets/screenshot-browser.png`: desktop browser session running an AI coding agent.
- `assets/screenshot-ipad.png`: tablet view showing AgentDesk in use.
- `assets/diagram.png`: architecture diagram matching the flow above.
- `assets/demo.gif`: short demo from login to running `claude` or `codex`.
- `assets/terminal-workflow.png`: example project workflow in the browser terminal.

## GitHub Topic Recommendations

Suggested repository topics:

`claude-code`, `codex`, `openai-codex`, `anthropic`, `hermes`, `opencode`, `openclaw`, `ai-agent`, `coding-agent`, `browser-terminal`, `web-terminal`, `remote-development`, `cloud-ide`, `coolify`, `docker`, `gitops`, `ssh`, `self-hosted`, `homelab`, `cloudflare-access`, `developer-tools`, `devops`, `ai-devops`, `docker-workspace`, `self-hosted-ai`

## Competitive Position

AgentDesk overlaps with GitHub Codespaces, Coder, code-server, OpenVSCode Server, ttyd, Theia, Cloud9, and JetBrains Gateway, but its center of gravity is different. It is not trying to be a full IDE platform. It is a small, auditable browser workspace for AI coding agents, remote terminals, and GitOps-native development on your own machine.

What differentiates AgentDesk:

- AI-agent-first positioning instead of editor-first positioning.
- Self-hosted control over the machine, shell, credentials, and workspace.
- Coolify-friendly deployment for people already running GitOps infrastructure.
- Simple architecture that can be understood quickly.

What would make it category-leading:

- polished screenshots and a short demo GIF
- one-command bootstrap for common hosts
- multiple-instance examples for teams and labs
- optional hardened deployment profiles
- documented integrations for Cloudflare Access, Tailscale, and common agent CLIs

## Support

If AgentDesk saves you time, starring the repository helps other developers find it. Issues and pull requests are welcome when they keep the runtime architecture clear and secure.

<a href="https://www.buymeacoffee.com/genildof"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

<a href="https://buymeacoffee.com/genildof"><img src="assets/bmc_qr.png" alt="Buy Me A Coffee QR code" width="180"></a>

## Credits

AgentDesk builds on [ttydBridge](https://github.com/Cp0204/ttydBridge), Caddy, Docker, and the broader self-hosted developer tools ecosystem.

## License

See [LICENSE](./LICENSE) for license details.
