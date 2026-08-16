# Contributing

AgentDesk is intentionally small. Contributions should improve clarity,
security, deployment reliability, or browser-terminal usability without
making Coolify deployment harder to understand.

## Runtime changes

Open an issue before changing `docker-compose.yaml`, the Docker image,
authentication, SSH behavior, healthchecks, environment variables, or security
boundaries. Documentation-only changes can be proposed directly.

## Standards

- Keep `docker-compose.yaml` as the canonical deployment file.
- Keep examples compatible with a standard Coolify Docker Compose resource.
- Use generic names such as `developer`, `project-a`, and `example.com`.
- Never include private keys, passwords, or real infrastructure addresses.
- Document every new environment variable in `.env.example` and
  `docs/COOLIFY.md`.

## Local validation

```bash
docker compose config
sh -n docker/entrypoint.sh
git diff --check
```

## Security reports

Do not include exploitable security details in public issues. Use the
repository owner's private disclosure channel when available.
