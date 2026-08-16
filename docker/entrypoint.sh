#!/bin/sh
set -eu

fail() {
  echo "AgentDesk configuration error: $*" >&2
  exit 1
}

: "${PORT:=8080}"
: "${SSH_PORT:=22}"
: "${SSH_STRICT_HOST_KEY_CHECKING:=yes}"
: "${SSH_SESSION_PERSISTENT:=false}"
: "${SSH_SESSION_NAME:=agentdesk}"

[ -n "${SSH_HOST:-}" ] || fail "SSH_HOST is required"
[ -n "${SSH_USER:-}" ] || fail "SSH_USER is required"
[ -n "${SSH_PRIVATE_KEY:-}" ] || fail "SSH_PRIVATE_KEY is required"

key_file=/run/agentdesk/id_ed25519
known_hosts_file=/run/agentdesk/known_hosts

umask 077
printf '%s\n' "$SSH_PRIVATE_KEY" > "$key_file"

if [ "$SSH_STRICT_HOST_KEY_CHECKING" = "yes" ]; then
  [ -n "${SSH_KNOWN_HOSTS:-}" ] || fail "SSH_KNOWN_HOSTS is required when SSH_STRICT_HOST_KEY_CHECKING=yes"
  printf '%s\n' "$SSH_KNOWN_HOSTS" > "$known_hosts_file"
else
  : > "$known_hosts_file"
fi

set -- ssh -tt \
  -p "$SSH_PORT" \
  -i "$key_file" \
  -o IdentitiesOnly=yes \
  -o UserKnownHostsFile="$known_hosts_file" \
  -o StrictHostKeyChecking="$SSH_STRICT_HOST_KEY_CHECKING" \
  "$SSH_USER@$SSH_HOST"

if [ -n "${SSH_REMOTE_COMMAND:-}" ]; then
  set -- "$@" "$SSH_REMOTE_COMMAND"
elif [ "$SSH_SESSION_PERSISTENT" = "true" ]; then
  set -- "$@" "tmux new-session -A -s $SSH_SESSION_NAME"
fi

if [ -n "${WEB_USERNAME:-}" ] || [ -n "${WEB_PASSWORD:-}" ]; then
  [ -n "${WEB_USERNAME:-}" ] && [ -n "${WEB_PASSWORD:-}" ] || fail "WEB_USERNAME and WEB_PASSWORD must be set together"
  echo "AgentDesk connecting to ${SSH_USER}@${SSH_HOST}:${SSH_PORT}"
  exec ttyd -W -p "$PORT" -c "$WEB_USERNAME:$WEB_PASSWORD" -- "$@"
fi

echo "AgentDesk connecting to ${SSH_USER}@${SSH_HOST}:${SSH_PORT}"
exec ttyd -W -p "$PORT" -- "$@"
