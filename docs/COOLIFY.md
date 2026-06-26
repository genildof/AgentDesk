# Coolify Deployment

AgentDesk is designed to work cleanly with Coolify and Traefik while preserving a simple browser-to-host-shell path.

## Source Of Truth

Use [`../docker-compose.yaml`](../docker-compose.yaml). The compose filename is `docker-compose.yaml`.

Do not rename examples to `docker-compose.yml` unless the repository file is renamed everywhere.

## Routing Model

```text
Coolify / Traefik
  -> ttyd-proxy on port 8080
  -> Caddy
  -> host.docker.internal:2222
  -> ttydbridge
  -> host shell
```

Coolify should route external traffic to `ttyd-proxy`. The `ttydbridge` service should not be exposed directly.

## Coolify Setup

1. Create a new Docker Compose resource in Coolify.
2. Point Coolify at this repository.
3. Use [`../docker-compose.yaml`](../docker-compose.yaml) as the compose file.
4. Configure your domain for the `ttyd-proxy` service.
5. Put AgentDesk behind authenticated access before exposing it to users.

Example service mapping:

```text
Service: ttyd-proxy
Public route: https://agentdesk.example.com
Internal port: 8080
```

Users should visit the public route, not the internal `:8080` URL.

## Health And Routing

Coolify should healthcheck the browser-facing proxy, not ttydBridge directly. The proxy proves that the public route can reach Caddy. ttydBridge remains an internal part of the request path.

If Coolify reports a routing issue, verify:

- the public route targets `ttyd-proxy`
- the public route uses port `8080`
- Caddy can reach `host.docker.internal:2222`
- ttydBridge is listening on the expected host-side port
- your edge authentication is not blocking Coolify's route setup

## Common Errors

### 502 Bad Gateway

Likely causes:

- `ttydbridge` is not reachable from Caddy
- ttydBridge is not listening on the expected port
- host networking or `host.docker.internal` resolution is unavailable

### 504 Gateway Timeout

Likely causes:

- ttydBridge started slowly
- host firewall rules block the bridge port
- the host shell or workspace path is unavailable

### Address already in use

Likely causes:

- another AgentDesk instance already uses the same ttydBridge port
- a different process is bound to the same host port

Use separate ports for separate instances, for example `2222`, `2223`, and `2224`.

## Multiple Instances

For multiple AgentDesk instances, isolate:

- domain
- host-side port
- user
- workspace
- credentials or edge access policy

Example intent:

```text
agentdesk-a.example.com -> workspace project-a
agentdesk-b.example.com -> workspace project-b
agentdesk-lab.example.com -> workspace lab
```

## Security Reminder

AgentDesk exposes a shell. Do not publish it as an unauthenticated public service. Use an authenticated edge such as Cloudflare Access, Tailscale, WireGuard, a VPN, or a trusted reverse proxy access policy.
