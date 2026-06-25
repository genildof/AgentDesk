# AgentDesk

> Self-hosted browser terminal for AI coding agents, remote development, and GitOps-first workflows.

AgentDesk is a self-hosted browser terminal and remote development console for Claude Code, OpenAI Codex, Hermes, OpenCode, OpenClaw, SSH workspaces, and containerized dev environments.

**Security warning:** AgentDesk is privileged infrastructure. Never deploy it without `HTTP_USERNAME` and `HTTP_PASSWORD`. Put it behind Cloudflare Access, VPN, MFA, or IP allowlists whenever possible.

## What is AgentDesk?

AgentDesk is a self-hosted browser workspace, web terminal, and remote development environment for AI coding agents and remote shell workflows.

It lets you:

- open a browser terminal or web terminal
- reach agent tooling from anywhere, on any device
- keep compute on your server, VPS, container host, or home lab
- manage development, DevOps, and remote administration without a full desktop

The canonical Coolify file is [`docker-compose.yaml`](./docker-compose.yaml).

## Why AgentDesk?

Developers increasingly use terminal-native AI coding agents, but they still need a safe way to access those tools from a browser, tablet, or lightweight device. AgentDesk is a self-hosted alternative for browser-based remote development without a hosted IDE.

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

## Important Coolify Configuration

AgentDesk uses two containers:

- `ttydbridge` runs `ttyd`
- `ttyd-proxy` runs Caddy

Coolify must attach the public domain to `ttyd-proxy`, not to `ttydbridge`.

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

Do not attach the public domain to `ttydbridge`. Do not expose `:8080` publicly.

## Recommended Developer Workflow

AgentDesk intentionally starts as a privileged shell.

That is useful for infrastructure administration and host-level recovery work.

For software development, switch to the account where your AI tools and workspace live.

Examples:

```bash
su - <developer-user>
cd ~/workspace
codex
```

or:

```bash
su - <developer-user>
claude
```

or:

```bash
su - <developer-user>
hermes
```

or:

```bash
su - <developer-user>
opencode
```

Benefits:

- preserves ssh keys
- preserves git credentials
- preserves codex configs
- preserves claude configs
- avoids development as root
- reduces accidental host modifications

## Recommended Workspace Layout

Users are free to customize their own layout. This is only a recommended structure.

Example:

```text
/home/<user>/
  workspace/
    cognivanta/
      AgentDesk/
      Agent_Agency/
      autonomous-media-pipeline/
    company/
      project-a/
      project-b/
    lab/
      poc/
      scratch/
  sandbox/
  .ssh/
  .codex/
  .claude/
  .hermes/
  .local/
  .config/
```

## Security Warning

- Never deploy AgentDesk without `HTTP_USERNAME` and `HTTP_PASSWORD`.
- Never commit real passwords.
- Rotate passwords if they appear in logs.
- Put AgentDesk behind Cloudflare Access, VPN, MFA, or IP allowlists whenever possible.
- Treat AgentDesk as privileged infrastructure because it can expose shell access through the browser.
- Configure `HTTP_USERNAME` and `HTTP_PASSWORD` in Coolify environment variables, not hardcoded in `docker-compose.yaml`.

## Port Usage

- `ttydbridge` listens on host port `2222` by default.
- `ttydbridge` uses `pid: host` and binds to the host network namespace, so only one AgentDesk instance can use `PORT=2222` on the same server.
- If you deploy multiple AgentDesk instances on the same host, use different `ttydbridge` ports:
  - production: `2222`
  - test: `2223`
  - staging: `2224`
- `ttyd-proxy` / Caddy listens internally on port `8080`.
- In Coolify, attach the public domain to `ttyd-proxy` with `:8080`.
- Example: `https://agentdesk.example.com:8080`
- Users access: `https://agentdesk.example.com`

## Troubleshooting

Symptoms:

- `502 Bad Gateway`
- `504 Gateway Timeout`
- `connection refused`
- `lws_socket_bind ERROR on binding fd 12 to port 2222 (-1 98)`

What it means:

- `lws_socket_bind` with code `98` means the `ttydbridge` port is already in use.
- This usually happens when another AgentDesk or `ttyd` instance is already running on the same host port.

Fix:

- change `PORT` to `2223`, `2224`, or another free port
- update the Caddy `reverse_proxy` target to match the new host port
- keep the Coolify domain attached to `ttyd-proxy`, not `ttydbridge`

See [docs/COOLIFY.md](./docs/COOLIFY.md) for the validated deployment path.

## Environment Variables

Copy the example file and edit it:

```bash
cp .env.example .env
```

Required:

- `HTTP_USERNAME`
- `HTTP_PASSWORD`

These must be configured in Coolify environment variables. Do not hardcode them in `docker-compose.yaml`.

Optional:

- `DEFAULT_USER`
- `DEFAULT_WORKSPACE`

Recommended:

- `DEFAULT_USER=<developer-user>`
- `DEFAULT_WORKSPACE=/home/<developer-user>/workspace`

## Security Model

AgentDesk is intentionally not a public shell endpoint or public `ttyd` instance.

Recommended controls:

- Cloudflare Access for identity-aware access
- VPN
- MFA
- IP allowlists
- authenticated reverse proxying in front of `ttyd`

Do not expose root shells publicly without extra protection. Prefer non-root workspaces whenever possible.

See [docs/SECURITY.md](./docs/SECURITY.md).

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

Use [`docker-compose.yaml`](./docker-compose.yaml) as the canonical compose file.

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

## Support AgentDesk

AgentDesk is an independent open-source project built to help developers run AI coding agents securely from anywhere.

If AgentDesk saves you time, helps you work without carrying a laptop, or inspires your own setup, consider supporting the project.

<a href="https://www.buymeacoffee.com/genildof" target="_blank">
<img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png"
alt="Buy Me A Coffee"
style="height: 60px !important;width: 217px !important;">
</a>

<p align="center">

<a href="https://buymeacoffee.com/genildof">

<img
src="assets/bmc_qr.png"
alt="Buy Me a Coffee QR Code"
width="180">

</a>

</p>

## Credits

AgentDesk stands on the shoulders of great open-source projects.

Special thanks to Cp0204 for ttydBridge, which served as one of the foundational building blocks that inspired AgentDesk. See [ttydBridge](https://github.com/Cp0204/ttydBridge).

## License

See [LICENSE](./LICENSE).

---

Built with ❤️ for developers running AI agents from anywhere.
