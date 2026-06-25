# Bootstrapping an AgentDesk Development Environment

This document describes a practical Ubuntu 24.04 bootstrap path for an AgentDesk development machine.

## Target environment

- Ubuntu 24.04
- NodeJS
- npm
- pnpm
- typescript
- tsx
- vite
- turbo
- eslint
- prettier
- git
- gh
- docker
- docker compose
- pipx
- python3
- venv
- uv
- poetry
- ffmpeg
- espeak-ng
- jq
- curl
- wget
- tmux
- zsh
- starship

## Example bootstrap commands

Use `apt` for system packages:

```bash
sudo apt update
sudo apt install -y   git   curl   wget   jq   ffmpeg   espeak-ng   tmux   zsh   python3   python3-pip   pipx
```

Enable `pipx` in the current shell session:

```bash
pipx ensurepath
```

Install common JavaScript tooling:

```bash
npm install -g   pnpm   typescript   tsx   turbo   vite   eslint   prettier
```

Install `gh`, `docker`, `docker compose`, `uv`, `poetry`, `starship`, `NodeJS`, and any other platform-specific dependencies following their official Ubuntu 24.04 installation instructions.

## Agent tooling

Install Codex, Claude Code, Hermes, OpenCode, and OpenClaw following their own documentation.

These tools typically manage their own runtime dependencies, login flows, and config directories, so it is better to follow the vendor instructions than to guess at a generic install path.

## Workspace preparation

After bootstrapping the system packages, create or select a non-root development account and prepare the workspace layout described in the main README.

That keeps credentials, SSH keys, and tool config in the intended user profile instead of the privileged shell.
