# Bootstrap Guide

This guide prepares a host for AgentDesk and terminal-native AI coding agents.

## Target Host

AgentDesk works well on a VPS, homelab server, lab machine, or workstation that can run Docker and expose a protected web route.

Recommended baseline:

- Ubuntu 22.04 or 24.04, Debian, or another Docker-capable Linux host
- Docker and Docker Compose plugin
- a non-root developer user
- a persistent workspace directory
- authenticated edge access before the browser terminal

## Install Common Tools

Install the tools your workflows need. A typical developer host may include:

```bash
sudo apt update
sudo apt install -y git curl ca-certificates jq python3 python3-pip pipx nodejs npm
```

Install package managers or runtimes used by your projects, such as `pnpm`, `uv`, Go, Rust, or language-specific tooling.

## Prepare A Workspace

Create a workspace for development projects:

```bash
mkdir -p ~/workspace/{project-a,project-b,opensource,clients,lab}
```

Typical layout:

```text
~/workspace/
  project-a/
  project-b/
  opensource/
  clients/
  lab/
```

## Install AI Coding Agents

Install the agent CLIs you plan to use on the host, then run them inside the AgentDesk browser terminal.

Common commands once installed:

```bash
cd ~/workspace
claude
```

```bash
cd ~/workspace
codex
```

```bash
cd ~/workspace
hermes
```

```bash
cd ~/workspace
opencode
```

## Configure AgentDesk

Create the environment file:

```bash
cp .env.example .env
```

Review `.env` and [`../docker-compose.yaml`](../docker-compose.yaml) before deployment. Keep the compose filename as `docker-compose.yaml`.

## Deploy

For Docker Compose:

```bash
docker compose -f docker-compose.yaml up -d
```

For Coolify, see [COOLIFY.md](./COOLIFY.md).

## Verify

After deployment:

1. Open the configured domain.
2. Authenticate through your access layer.
3. Confirm the browser terminal loads.
4. Run `pwd`, `git --version`, and one installed agent CLI.
5. Confirm your workspace directory is available.

## Operational Notes

- Keep host packages updated.
- Rotate credentials when access changes.
- Use separate users and workspaces for separate teams or environments.
- Do not expose the service without authentication.
