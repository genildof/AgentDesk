# AgentDesk

> A simple, self-hosted browser terminal for connecting to a remote developer VPS and running Codex, Claude Code, or any other terminal tool.

AgentDesk runs as a normal Docker Compose application. The web container opens
an SSH session to a remote machine, so the remote machine remains the place
where source code, credentials, Docker, and AI coding agents live.

## Why AgentDesk

- Works with Coolify as a standard Docker Compose application.
- Uses SSH instead of privileged host access.
- Supports Tailscale IPs and private networks.
- Keeps all deployment settings in environment variables.
- Works from a browser, tablet, Chromebook, or locked-down workstation.

## Architecture

```text
Browser -> Coolify/Traefik -> AgentDesk container -> SSH/Tailscale -> Codex VPS
```

AgentDesk is a browser terminal, not an IDE and not an OpenAI API proxy. Run
`codex` in the remote shell after connecting.

## Coolify deployment

1. Create a Docker Compose resource from this repository.
2. Use branch `main` and compose file `docker-compose.yaml`.
3. Configure the domain on service `agentdesk`, port `8080`.
4. Add the variables from `.env.example` as Coolify environment variables.
5. Deploy and open the configured HTTPS domain.

The complete variable reference and troubleshooting guide are in
[`docs/COOLIFY.md`](docs/COOLIFY.md).

## Environment variables

Required:

- `SSH_HOST`: Tailscale IP or DNS name of the remote VPS.
- `SSH_PORT`: SSH port, normally `22`.
- `SSH_USER`: Linux user on the remote VPS.
- `SSH_PRIVATE_KEY`: private key that corresponds to a public key in the remote user's `~/.ssh/authorized_keys`.
- `SSH_KNOWN_HOSTS`: output of `ssh-keyscan -H SSH_HOST`.

Optional:

- `WEB_USERNAME` and `WEB_PASSWORD`: second HTTP Basic Auth layer.
- `SSH_SESSION_PERSISTENT=true`: reconnect to a remote `tmux` session named by `SSH_SESSION_NAME`.
- `SSH_REMOTE_COMMAND`: custom command to run instead of the normal remote shell.
- `SSH_STRICT_HOST_KEY_CHECKING`: defaults to `yes` and should remain enabled.

Never commit real private keys or passwords. Store them as secrets in Coolify.

## Remote VPS preparation

On the VPS where Codex will run:

```bash
sudo apt update
sudo apt install -y openssh-server git tmux
sudo adduser codex
sudo install -d -m 700 -o codex -g codex /home/codex/.ssh
```

Add the public key used by `SSH_PRIVATE_KEY` to:

```text
/home/codex/.ssh/authorized_keys
```

Install and authenticate Codex on that VPS, then verify directly:

```bash
ssh codex@100.64.0.12
codex
```

## Local validation

```bash
cp .env.example .env
docker compose config
docker compose up --build
```

## Security

AgentDesk exposes a shell with the permissions of `SSH_USER`. Use a dedicated
Linux user, a dedicated SSH key, HTTPS, Tailscale or another authenticated
edge, and host-key verification. Read [`docs/SECURITY.md`](docs/SECURITY.md).

## Support

If AgentDesk saves you time, starring the repository helps other developers
find it. Issues and pull requests are welcome when they improve clarity,
security, and deployment reliability.

<a href="https://www.buymeacoffee.com/genildof"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

<a href="https://buymeacoffee.com/genildof"><img src="assets/bmc_qr.png" alt="Buy Me A Coffee QR code" width="180"></a>

## License

See [`LICENSE`](LICENSE).
