# Architecture

AgentDesk is a browser-accessible development workspace for terminal-native AI coding agents. The architecture is intentionally small so operators can understand every hop between the browser and the host shell.

## Request Flow

```text
Browser
  -> Coolify / Traefik
  -> ttyd-proxy on port 8080
  -> Caddy
  -> host.docker.internal:2222
  -> ttydbridge
  -> host shell
```

The source of truth for the running stack is [`../docker-compose.yaml`](../docker-compose.yaml).

## Components

### Coolify / Traefik

Coolify and Traefik provide the public routing layer. They terminate or route web traffic to the `ttyd-proxy` service.

### ttyd-proxy

`ttyd-proxy` runs Caddy and exposes the browser-facing service on port `8080`. It forwards traffic to ttydBridge through `host.docker.internal:2222`.

### Caddy

Caddy is the lightweight reverse proxy inside the `ttyd-proxy` service. It keeps the browser-facing container simple and forwards requests to the host-side bridge.

### ttydbridge

`ttydbridge` connects the web terminal to the host shell. It is the component that makes AgentDesk feel like SSH in a browser.

### Host Shell

The host shell is where developer tools and AI coding agents run. Typical commands include `claude`, `codex`, `hermes`, `opencode`, and regular shell, Git, Docker, and editor workflows.

## Ports

- `8080`: browser-facing proxy service.
- `2222`: host-side ttydBridge endpoint used by the proxy.

When running multiple instances, allocate separate host ports, users, domains, and workspaces for each instance.

## Workspace Model

AgentDesk is designed around a persistent host workspace, for example:

```text
~/workspace/
  project-a/
  project-b/
  opensource/
  clients/
  lab/
```

The exact workspace path is configured through the existing environment and compose settings. See [`../docker-compose.yaml`](../docker-compose.yaml) and [BOOTSTRAP.md](./BOOTSTRAP.md).

## Security Boundary

AgentDesk exposes an interactive shell. The important security boundary is the authenticated edge in front of the browser endpoint. Use Cloudflare Access, Tailscale, WireGuard, a VPN, or another trusted access layer.

See [SECURITY.md](./SECURITY.md) for the full security model.

## What AgentDesk Is Not

AgentDesk is not a multi-tenant IDE platform, a replacement for operating-system access control, or a sandbox for untrusted workloads. It is a focused remote developer workspace for trusted users and trusted machines.
