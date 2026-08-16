# Security

AgentDesk exposes an interactive SSH shell through a browser. Treat it as
remote shell access, not as a sandbox.

## Recommended baseline

- HTTPS at Coolify or another trusted edge.
- Tailscale or a private network between Coolify and the remote VPS.
- A dedicated, non-root Linux user on the remote VPS.
- A dedicated SSH key with no broader access than necessary.
- `SSH_STRICT_HOST_KEY_CHECKING=yes` and a pinned `SSH_KNOWN_HOSTS` value.
- Strong optional `WEB_USERNAME` and `WEB_PASSWORD` values.
- No secrets committed to Git.

## Private keys

`SSH_PRIVATE_KEY` is passed to the container as a Coolify secret and written
only to a runtime file with mode `0600`. Rotate the key if the Coolify
resource, VPS, or operators change.

Never place a private key in `.env.example`, issues, screenshots, logs, or a
public repository.

## Remote user

The remote user can execute commands, read its files, access its credentials,
and modify its projects. Do not connect AgentDesk to a root account or use it
for untrusted users without an additional isolation layer.

## Host-key verification

Keep `SSH_STRICT_HOST_KEY_CHECKING=yes`. Generate `SSH_KNOWN_HOSTS` from a
trusted network and review the fingerprint before saving it in Coolify.

## What AgentDesk does not do

AgentDesk does not provide multi-tenant isolation, project sandboxing, user
management, or an OpenAI API proxy. Those concerns belong to the deployment
edge and the remote operating system.
