# Architecture

## Overview

AgentDesk uses a layered, browser-first access path:

```text
Internet -> Cloudflare Access -> Coolify/Traefik -> Caddy -> ttydbridge -> Host/Workspace
```

## Component roles

- Internet: user entry point from browser or mobile device
- Cloudflare Access: identity-aware perimeter and access policy
- Coolify/Traefik: external routing and service exposure
- Caddy: internal reverse proxy for the shell backend
- ttydbridge: remote terminal bridge
- Host/Workspace: the actual development or operations environment

## Why this structure

- keeps the raw shell backend off the public edge
- makes the deployment easier to reason about
- separates routing, authentication, and workspace execution
- works well with GitOps-style deployment

## Security implication

The important security boundary is not the browser page itself. It is the authenticated edge in front of the shell backend.
