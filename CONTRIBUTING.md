# Contributing

Thanks for helping improve AgentDesk.

AgentDesk is intentionally small. The best contributions improve clarity, security, deployment reliability, and developer experience without making the runtime architecture harder to understand.

## Before You Change Runtime Behavior

Open an issue first for changes that affect:

- `docker-compose.yaml`
- routing
- Caddy
- ttydBridge
- authentication
- healthchecks
- labels or domains
- environment variables
- security boundaries
- host privileges
- volumes

Documentation-only changes can usually be proposed directly as pull requests.

## Documentation Standards

Use generic examples:

- `developer`
- `alice`
- `bob`
- `myproject`
- `project-a`
- `project-b`
- `opensource`
- `clients`
- `lab`

Avoid organization-specific names, unrelated project names, and environment details that only apply to one deployment.

Always reference the compose file as `docker-compose.yaml`.

## Pull Request Checklist

Before opening a pull request:

- confirm the change is scoped
- update docs when behavior changes
- avoid unrelated formatting churn
- keep examples generic
- verify links to files and docs
- explain security implications when relevant

## Local Validation

Useful checks:

```bash
git diff --stat
```

```bash
grep -Ri "docker-compose.yml" README.md docs CONTRIBUTING.md
```

## Security Reports

Do not include exploitable security details in public issues. Open a minimal issue asking for a secure disclosure channel if no preferred contact path is listed.
