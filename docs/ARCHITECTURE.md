# Architecture

AgentDesk is intentionally a small SSH-to-browser adapter.

```text
Browser
  -> Coolify / Traefik
  -> AgentDesk container :8080
  -> SSH over Tailscale
  -> remote Linux shell
  -> Codex or another terminal agent
```

The canonical deployment is [`../docker-compose.yaml`](../docker-compose.yaml).
It builds one unprivileged container containing `ttyd` and the OpenSSH client.
The container does not mount the host filesystem, use host PID namespaces, or
require Docker socket access.

## Request and session flow

1. Coolify routes HTTPS traffic to port `8080`.
2. `ttyd` creates a browser terminal and starts SSH.
3. SSH authenticates with `SSH_PRIVATE_KEY`.
4. The remote VPS runs the user's shell or `SSH_REMOTE_COMMAND`.
5. The user starts `codex` in that remote shell.

WebSocket support is handled by `ttyd` and Coolify's reverse proxy. No special
public port is required beyond the web service port.

## Persistence

A normal SSH shell ends when its browser session ends. Set
`SSH_SESSION_PERSISTENT=true` to run:

```bash
tmux new-session -A -s agentdesk
```

The remote VPS must have `tmux` installed. This preserves the terminal process
across browser refreshes and temporary network interruptions.

## Boundaries

The container has the permissions of the remote SSH user, not root access to
the Coolify host. The remote SSH user can still modify everything that its
Linux permissions allow, so use a dedicated account for untrusted work.
