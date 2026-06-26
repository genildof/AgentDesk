# Roadmap

AgentDesk is technically functional. The next phase is making it easier to understand, deploy, secure, and share.

## Near Term

- Add polished screenshots for desktop browser and tablet usage.
- Add an architecture diagram that matches the current request flow.
- Add a short demo GIF showing login, workspace access, and running an AI coding agent.
- Document Cloudflare Access and Tailscale deployment examples.
- Add a troubleshooting matrix for common Coolify, Caddy, and ttydBridge errors.

## Deployment Improvements

- Optional hardened deployment profile.
- Multiple-instance examples for `project-a`, `project-b`, and `lab` workspaces.
- Bootstrap script for common Linux hosts.
- Document backup and restore expectations for workspaces.

## Developer Experience

- First-run checklist for new hosts.
- Example workflows for Claude Code, OpenAI Codex, Hermes, OpenCode, and OpenClaw.
- Recommended shell profile snippets for agent workflows.
- Optional terminal theme recommendations for screenshots and demos.

## Repository Growth

- Add GitHub topics for AI coding agents, browser terminal, remote development, Coolify, Docker, GitOps, self-hosted, and homelab discovery.
- Add issue templates for bug reports, deployment help, and documentation improvements.
- Add a short comparison table for Codespaces, Coder, code-server, ttyd, and AgentDesk.
- Add a lightweight website or GitHub Pages landing page when screenshots are ready.

## Non-Goals

- Do not turn AgentDesk into a full multi-tenant IDE platform.
- Do not hide the host shell behind unnecessary abstraction.
- Do not weaken the security model for convenience.
- Do not change the runtime architecture without a clear operational reason.
