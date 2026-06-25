# Deploying AgentDesk on Coolify

AgentDesk is designed to work with a Coolify-managed Docker Compose deployment.

## Deployment flow

1. Add the repository to Coolify as a new service.
2. Keep the root `docker-compose.yml` unchanged unless you are intentionally modifying the runtime.
3. Configure the required environment variables:
   - `HTTP_USERNAME`
   - `HTTP_PASSWORD`
4. Assign the domain to `ttyd-proxy`, using the internal container port, for example `https://agentdesk.example.com:8080`.
5. Deploy the stack.
6. End users will access `https://agentdesk.example.com`.

## Domain routing

Coolify and Traefik should route external traffic to the internal Caddy service.

In this repository, the external host is handled by Traefik labels on `ttyd-proxy`, while Caddy forwards traffic to the `ttydbridge` backend on the host gateway.

## Why the domain points to the proxy

Traefik -> Caddy -> ttydbridge is the validated path for this deployment.

Traefik cannot reliably reach `ttydbridge` directly in this setup.

Caddy acts as an internal bridge between Coolify/Traefik and the backend shell service.

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

> ⚠️ This is the single most common cause of AgentDesk deployment failures.

Do not simplify or bypass this path unless you are intentionally redesigning the deployment model.

## Port mapping

Current internal flow:

- Traefik exposes the public entry point
- Caddy listens on `:8080` inside the proxy container
- Caddy forwards to `host.docker.internal:2222`
- `ttydbridge` listens on port `2222`

## Why Caddy is used as an internal proxy

Caddy acts as a small internal reverse proxy between Coolify/Traefik and the shell backend.

Benefits:

- simple config
- predictable reverse proxy behavior
- easy health verification
- a clean separation between edge routing and backend access

## Common 502 / 504 troubleshooting

If you see 502 or 504 responses:

- confirm the domain points to `ttyd-proxy`, not `ttydbridge`
- confirm the Coolify domain uses `:8080` on the proxy service
- confirm Traefik labels are correct
- confirm Caddy is starting successfully
- confirm `ttydbridge` is running and listening on `2222`
- confirm the host gateway is reachable from the proxy container
- confirm your firewall allows the relevant inbound path

Common failure modes include:

- `502 Bad Gateway`
- `504 Gateway Timeout`
- `Connection refused`

## Confirm backend reachability

Use `curl` or `wget` from a shell on the host or from a container with network visibility:

```bash
curl -v http://127.0.0.1:8080
curl -v http://host.docker.internal:2222
wget -S -O - http://127.0.0.1:8080
```

If the proxy is healthy but the backend is not reachable, check the `ttydbridge` container logs and the host-side service state.

## Practical note

The working compose file currently depends on the existing Coolify network and routing behavior. Preserve that model unless you are intentionally redesigning the deployment.
