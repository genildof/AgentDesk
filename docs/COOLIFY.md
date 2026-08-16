# Coolify deployment

AgentDesk is designed to run as a normal Coolify Docker Compose resource.

## Resource configuration

Create a Docker Compose resource with:

```text
Repository: your AgentDesk repository
Branch: main
Compose file: docker-compose.yaml
Service: agentdesk
Port: 8080
Domain: https://agentdesk.example.com
```

The Compose file uses `build`, `expose`, a healthcheck, and no external Docker
network. It does not require `privileged`, host networking, host mounts, or the
Docker socket.

## Environment variables

Configure these in Coolify. Mark private key and authentication values as
secrets.

| Variable | Required | Example | Purpose |
| --- | --- | --- | --- |
| `PORT` | no | `8080` | Internal web port. Keep aligned with the service port. |
| `WEB_USERNAME` | no | `admin` | Optional browser-terminal username. |
| `WEB_PASSWORD` | no | secret | Optional browser-terminal password. Set both web variables together. |
| `SSH_HOST` | yes | `100.64.0.12` | Tailscale IP or DNS name of the Codex VPS. |
| `SSH_PORT` | yes | `22` | SSH port on the remote VPS. |
| `SSH_USER` | yes | `codex` | Remote Linux user. |
| `SSH_PRIVATE_KEY` | yes | multiline secret | Private key for the remote user. |
| `SSH_KNOWN_HOSTS` | yes | multiline secret | Pinned SSH host key. |
| `SSH_STRICT_HOST_KEY_CHECKING` | no | `yes` | Keep enabled in production. |
| `SSH_SESSION_PERSISTENT` | no | `false` | Use a persistent remote tmux session. |
| `SSH_SESSION_NAME` | no | `agentdesk` | tmux session name. |
| `SSH_REMOTE_COMMAND` | no | empty | Custom command instead of a normal shell. |

Generate the pinned host key from a trusted machine:

```bash
ssh-keyscan -H 100.64.0.12
```

Copy the complete output to `SSH_KNOWN_HOSTS`. Do not use
`SSH_STRICT_HOST_KEY_CHECKING=no` except for temporary debugging.

## Tailscale requirements

The Coolify host or the AgentDesk container must be able to route to the
remote Tailscale address. Verify from the Coolify host:

```bash
tailscale ping 100.64.0.12
nc -vz 100.64.0.12 22
```

If the Coolify host is not a Tailscale node, install Tailscale on it or use a
Tailscale subnet router. Docker containers normally inherit the host's routes;
firewall and forwarding rules must allow the connection.

## Deployment checks

After deployment:

1. Open the HTTPS domain.
2. Confirm the terminal appears.
3. Run `whoami` and `hostname`.
4. Run `codex --version`.
5. Confirm the hostname is the remote Codex VPS.

A container restart can be used to verify that SSH credentials and environment
variables are complete.
