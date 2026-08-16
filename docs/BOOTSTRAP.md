# Bootstrap guide

This guide prepares the remote VPS where Codex and your projects will run.
AgentDesk itself can then be deployed as a normal Compose application in Coolify.

## Remote Codex VPS

Recommended baseline:

- Ubuntu 22.04/24.04, Debian, or another Docker-capable Linux distribution.
- Tailscale connected to the same tailnet as Coolify.
- OpenSSH server enabled.
- A dedicated non-root user and persistent workspace.

Install common tools:

```bash
sudo apt update
sudo apt install -y openssh-server git curl ca-certificates jq tmux
```

Create a user and workspace:

```bash
sudo adduser codex
sudo -u codex mkdir -p /home/codex/workspace
```

Install the agent CLIs on this VPS and verify:

```bash
sudo -u codex -H bash -lc 'cd ~/workspace && codex --version'
```

## SSH key

Generate a dedicated key on a trusted machine or in Coolify's deployment
environment:

```bash
ssh-keygen -t ed25519 -f agentdesk_codex -C agentdesk-codex
```

Add `agentdesk_codex.pub` to the remote user's `~/.ssh/authorized_keys`.
Store the private key as `SSH_PRIVATE_KEY` in Coolify, never in Git.

## Known hosts

From a trusted machine:

```bash
ssh-keyscan -H 100.64.0.12
```

Review the fingerprint and save the complete output as `SSH_KNOWN_HOSTS` in
Coolify.

## Verify before Coolify

```bash
ssh -i agentdesk_codex codex@100.64.0.12
```

Then run `whoami`, `hostname`, and `codex --version`.

## Coolify

Deploy the repository using `docker-compose.yaml`, service `agentdesk`, and
port `8080`. Copy the variables from `.env.example` into the Coolify resource.
The detailed reference is in [COOLIFY.md](./COOLIFY.md).
