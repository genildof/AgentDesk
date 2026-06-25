# Deploying AgentDesk on Coolify

AgentDesk is a Coolify-friendly Docker Compose deployment with two services:

- `ttydbridge` runs `ttyd`
- `ttyd-proxy` runs Caddy

## Deployment flow

1. Add the repository as a new Coolify service.
2. Keep the root `docker-compose.yml` unchanged.
3. Set `HTTP_USERNAME` and `HTTP_PASSWORD`.
4. Attach the domain to `ttyd-proxy` using the internal port, for example `https://agentdesk.example.com:8080`.
5. Deploy.
6. Users access `https://agentdesk.example.com`.

## Why the domain points to the proxy

The validated path is:

```text
Internet
    │
Cloudflare Access
(optional)
    │
Traefik (Coolify)
    │
ttyd-proxy (Caddy :8080)
    │
ttydbridge (:2222)
    │
Workspace / Host
```

Traefik routes to `ttyd-proxy`, and Caddy bridges traffic to `ttydbridge`.

Traefik cannot reliably reach `ttydbridge` directly in this setup.

> ⚠️ This is the single most common cause of AgentDesk deployment failures.

Do not attach the domain to `ttydbridge`.

## Port mapping

- Traefik exposes the public entry point
- Caddy listens on `:8080`
- Caddy forwards to `host.docker.internal:2222`
- `ttydbridge` listens on `2222`

## Common Coolify mistakes

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

Do not expose `:8080` publicly.

## Common 502 / 504 troubleshooting

If you see `502`, `504`, or `Connection refused`:

- confirm the domain is attached to `ttyd-proxy`
- confirm the Coolify domain uses `:8080`
- confirm Traefik labels are correct
- confirm Caddy starts successfully
- confirm `ttydbridge` is listening on `2222`
- confirm the host gateway is reachable from the proxy container
- confirm firewall rules allow the intended path

## Confirm backend reachability

Use `curl` or `wget` from the host or from a container with network visibility:

```bash
curl -v http://127.0.0.1:8080
curl -v http://host.docker.internal:2222
wget -S -O - http://127.0.0.1:8080
```

If the proxy is healthy but the backend is not reachable, check `ttydbridge` logs and host-side service state.

## Practical note

The current compose file depends on the existing Coolify network and routing behavior. Preserve that model unless you are intentionally redesigning the deployment.
