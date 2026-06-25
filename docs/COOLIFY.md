# Deploying AgentDesk on Coolify

AgentDesk is a Coolify-friendly Docker Compose deployment with two services:

- `ttydbridge` runs `ttyd`
- `ttyd-proxy` runs Caddy

## Deployment flow

1. Add the repository as a new Coolify service.
2. Use [`docker-compose.yaml`](../docker-compose.yaml) as the canonical compose file.
3. Set `HTTP_USERNAME` and `HTTP_PASSWORD` in Coolify environment variables.
4. Optionally set `DEFAULT_USER` and `DEFAULT_WORKSPACE` for the intended developer account and workspace path.
5. Attach the public domain to `ttyd-proxy` using the internal port, for example `https://agentdesk.example.com:8080`.
6. Deploy.
7. Users access `https://agentdesk.example.com`.

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

Do not attach the public domain to `ttydbridge`.

## Security Warning

- Never deploy AgentDesk without `HTTP_USERNAME` and `HTTP_PASSWORD`.
- Never commit real passwords.
- Rotate passwords if they appear in logs.
- Put AgentDesk behind Cloudflare Access, VPN, MFA, or IP allowlists whenever possible.
- Treat AgentDesk as privileged infrastructure because it can expose shell access through the browser.
- Configure `HTTP_USERNAME` and `HTTP_PASSWORD` in Coolify environment variables, not hardcoded in `docker-compose.yaml`.

## Coolify Variables

Required:

- `HTTP_USERNAME`
- `HTTP_PASSWORD`

Optional:

- `DEFAULT_USER`
- `DEFAULT_WORKSPACE`

Recommended:

- `DEFAULT_USER=<developer-user>`
- `DEFAULT_WORKSPACE=/home/<developer-user>/workspace`

## Port usage

- `ttydbridge` listens on host port `2222` by default.
- `ttydbridge` uses `pid: host` and binds to the host network namespace, so only one AgentDesk instance can use `PORT=2222` on the same server.
- If you deploy multiple AgentDesk instances on the same server, use different `ttydbridge` ports:
  - production: `2222`
  - test: `2223`
  - staging: `2224`
- `ttyd-proxy` / Caddy listens internally on port `8080`.
- In Coolify, attach the public domain to `ttyd-proxy` with `:8080`.
- Example: `https://agentdesk.example.com:8080`
- Users access: `https://agentdesk.example.com`
- Do not attach the public domain to `ttydbridge`.

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

## Health and routing

- `ttyd-proxy` healthcheck probes `http://127.0.0.1:8080`.
- `ttydbridge` healthcheck probes `http://127.0.0.1:${PORT:-2222}`.
- Healthy responses are `200`, `401`, or `403`.
- Authentication stays enabled; the healthcheck does not need credentials.

## Common 502 / 504 troubleshooting

If you see `502 Bad Gateway`, `504 Gateway Timeout`, `connection refused`, or `lws_socket_bind ERROR on binding fd 12 to port 2222 (-1 98)`:

- confirm the domain is attached to `ttyd-proxy`
- confirm the Coolify domain uses `:8080`
- confirm `ttydbridge` is not already running on `2222`
- confirm `PORT` is free on the host
- confirm Caddy starts successfully
- confirm `ttydbridge` is listening on the selected port

What `lws_socket_bind ... 98` means:

- the `ttydbridge` port is already in use
- another AgentDesk or `ttyd` instance is already bound to that host port

Fix:

- change `PORT` to `2223`, `2224`, or another free port
- update the Caddy `reverse_proxy` target to match the new port
- keep the domain attached to `ttyd-proxy`, not `ttydbridge`

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
