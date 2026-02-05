#!/usr/bin/env bash
set -x
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# cd .
# pwd
# ROOT_DIR=/workspaces/openclaw-openclaw

COMPOSE_FILE="$ROOT_DIR/docker-compose.yml"
# COMPOSE_FILE=/workspaces/openclaw-openclaw/docker-compose.yml

EXTRA_COMPOSE_FILE="$ROOT_DIR/docker-compose.extra.yml"
# EXTRA_COMPOSE_FILE=/workspaces/openclaw-openclaw/docker-compose.extra.yml

IMAGE_NAME="${OPENCLAW_IMAGE:-openclaw:local}"
# IMAGE_NAME=openclaw:local

EXTRA_MOUNTS="${OPENCLAW_EXTRA_MOUNTS:-}"
# EXTRA_MOUNTS=

HOME_VOLUME_NAME="${OPENCLAW_HOME_VOLUME:-}"
# HOME_VOLUME_NAME=

require_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        echo "Missing dependency: $1" >&2
        exit 1
    fi
}

require_cmd docker
if ! docker compose version >/dev/null 2>&1; then
    echo "Docker Compose not available (try: docker compose version)" >&2
    exit 1
fi

OPENCLAW_CONFIG_DIR="${OPENCLAW_CONFIG_DIR:-$HOME/.openclaw}"
# OPENCLAW_CONFIG_DIR=/home/codespace/.openclaw

OPENCLAW_WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-$HOME/.openclaw/workspace}"
# OPENCLAW_WORKSPACE_DIR=/home/codespace/.openclaw/workspace

mkdir -p "$OPENCLAW_CONFIG_DIR"
# mkdir -p /home/codespace/.openclaw

mkdir -p "$OPENCLAW_WORKSPACE_DIR"
# mkdir -p /home/codespace/.openclaw/workspace

export OPENCLAW_CONFIG_DIR
# export OPENCLAW_CONFIG_DIR

export OPENCLAW_WORKSPACE_DIR
# export OPENCLAW_WORKSPACE_DIR

export OPENCLAW_GATEWAY_PORT="${OPENCLAW_GATEWAY_PORT:-18789}"
# export OPENCLAW_GATEWAY_PORT=18789

export OPENCLAW_BRIDGE_PORT="${OPENCLAW_BRIDGE_PORT:-18790}"
# export OPENCLAW_BRIDGE_PORT=18790

export OPENCLAW_GATEWAY_BIND="${OPENCLAW_GATEWAY_BIND:-lan}"
# export OPENCLAW_GATEWAY_BIND=lan

export OPENCLAW_IMAGE="$IMAGE_NAME"
# export OPENCLAW_IMAGE=openclaw:local

export OPENCLAW_DOCKER_APT_PACKAGES="${OPENCLAW_DOCKER_APT_PACKAGES:-}"
# export OPENCLAW_DOCKER_APT_PACKAGES=

export OPENCLAW_EXTRA_MOUNTS="$EXTRA_MOUNTS"
# export OPENCLAW_EXTRA_MOUNTS=

export OPENCLAW_HOME_VOLUME="$HOME_VOLUME_NAME"
# export OPENCLAW_HOME_VOLUME=

if [[ -z "${OPENCLAW_GATEWAY_TOKEN:-}" ]]; then
    if command -v openssl >/dev/null 2>&1; then
        OPENCLAW_GATEWAY_TOKEN="$(openssl rand -hex 32)"
        # openssl rand -hex 32
        # OPENCLAW_GATEWAY_TOKEN=bd74e769ab9ac08389cd2dae92a52161eb2052d64c0fba8e9ee5098ccc0a58f9

    else
        OPENCLAW_GATEWAY_TOKEN="$(
            python3 - <<'PY'
import secrets
print(secrets.token_hex(32))
PY
        )"
    fi
fi
export OPENCLAW_GATEWAY_TOKEN
# export OPENCLAW_GATEWAY_TOKEN

COMPOSE_FILES=("$COMPOSE_FILE")
# COMPOSE_FILES=("$COMPOSE_FILE")

COMPOSE_ARGS=()

write_extra_compose() {
    local home_volume="$1"
    shift
    local -a mounts=("$@")
    local mount

    cat >"$EXTRA_COMPOSE_FILE" <<'YAML'
services:
  openclaw-gateway:
    volumes:
YAML

    if [[ -n "$home_volume" ]]; then
        printf '      - %s:/home/node\n' "$home_volume" >>"$EXTRA_COMPOSE_FILE"
        printf '      - %s:/home/node/.openclaw\n' "$OPENCLAW_CONFIG_DIR" >>"$EXTRA_COMPOSE_FILE"
        printf '      - %s:/home/node/.openclaw/workspace\n' "$OPENCLAW_WORKSPACE_DIR" >>"$EXTRA_COMPOSE_FILE"
    fi

    for mount in "${mounts[@]}"; do
        printf '      - %s\n' "$mount" >>"$EXTRA_COMPOSE_FILE"
    done

    cat >>"$EXTRA_COMPOSE_FILE" <<'YAML'
  openclaw-cli:
    volumes:
YAML

    if [[ -n "$home_volume" ]]; then
        printf '      - %s:/home/node\n' "$home_volume" >>"$EXTRA_COMPOSE_FILE"
        printf '      - %s:/home/node/.openclaw\n' "$OPENCLAW_CONFIG_DIR" >>"$EXTRA_COMPOSE_FILE"
        printf '      - %s:/home/node/.openclaw/workspace\n' "$OPENCLAW_WORKSPACE_DIR" >>"$EXTRA_COMPOSE_FILE"
    fi

    for mount in "${mounts[@]}"; do
        printf '      - %s\n' "$mount" >>"$EXTRA_COMPOSE_FILE"
    done

    if [[ -n "$home_volume" && "$home_volume" != *"/"* ]]; then
        cat >>"$EXTRA_COMPOSE_FILE" <<YAML
volumes:
  ${home_volume}:
YAML
    fi
}

VALID_MOUNTS=()
if [[ -n "$EXTRA_MOUNTS" ]]; then
    IFS=',' read -r -a mounts <<<"$EXTRA_MOUNTS"
    for mount in "${mounts[@]}"; do
        mount="${mount#"${mount%%[![:space:]]*}"}"
        mount="${mount%"${mount##*[![:space:]]}"}"
        if [[ -n "$mount" ]]; then
            VALID_MOUNTS+=("$mount")
        fi
    done
fi

if [[ -n "$HOME_VOLUME_NAME" || ${#VALID_MOUNTS[@]} -gt 0 ]]; then
    write_extra_compose "$HOME_VOLUME_NAME" "${VALID_MOUNTS[@]}"
    COMPOSE_FILES+=("$EXTRA_COMPOSE_FILE")
fi
for compose_file in "${COMPOSE_FILES[@]}"; do
    COMPOSE_ARGS+=("-f" "$compose_file")
done
# COMPOSE_ARGS+=("-f" "$compose_file")

COMPOSE_HINT="docker compose"
# COMPOSE_HINT='docker compose'

for compose_file in "${COMPOSE_FILES[@]}"; do
    COMPOSE_HINT+=" -f ${compose_file}"
done
# COMPOSE_HINT+=' -f /workspaces/openclaw-openclaw/docker-compose.yml'

ENV_FILE="$ROOT_DIR/.env"
# ENV_FILE=/workspaces/openclaw-openclaw/.env

upsert_env() {
    local file="$1"
    # local file=/workspaces/openclaw-openclaw/.env

    shift

    local -a keys=("$@")
    # keys=('OPENCLAW_CONFIG_DIR' 'OPENCLAW_WORKSPACE_DIR' 'OPENCLAW_GATEWAY_PORT' 'OPENCLAW_BRIDGE_PORT' 'OPENCLAW_GATEWAY_BIND' 'OPENCLAW_GATEWAY_TOKEN' 'OPENCLAW_IMAGE' 'OPENCLAW_EXTRA_MOUNTS' 'OPENCLAW_HOME_VOLUME' 'OPENCLAW_DOCKER_APT_PACKAGES')

    local tmp
    tmp="$(mktemp)"
    # mktemp
    # tmp=/tmp/tmp.7BslX5BzcP

    declare -A seen=()

    if [[ -f "$file" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            local key="${line%%=*}"
            local replaced=false
            for k in "${keys[@]}"; do
                if [[ "$key" == "$k" ]]; then
                    printf '%s=%s\n' "$k" "${!k-}" >>"$tmp"
                    seen["$k"]=1
                    replaced=true
                    break
                fi
            done
            if [[ "$replaced" == false ]]; then
                printf '%s\n' "$line" >>"$tmp"
            fi
        done <"$file"
    fi

    for k in "${keys[@]}"; do
        if [[ -z "${seen[$k]:-}" ]]; then
            printf '%s=%s\n' "$k" "${!k-}" >>"$tmp"
            # printf '%s=%s\n' OPENCLAW_CONFIG_DIR /home/codespace/.openclaw
            # printf '%s=%s\n' OPENCLAW_WORKSPACE_DIR /home/codespace/.openclaw/workspace
            # printf '%s=%s\n' OPENCLAW_BRIDGE_PORT 18790
            # printf '%s=%s\n' OPENCLAW_GATEWAY_BIND lan
            # printf '%s=%s\n' OPENCLAW_GATEWAY_TOKEN bd74e769ab9ac08389cd2dae92a52161eb2052d64c0fba8e9ee5098ccc0a58f9
            # printf '%s=%s\n' OPENCLAW_IMAGE openclaw:local
            # printf '%s=%s\n' OPENCLAW_EXTRA_MOUNTS ''
            # printf '%s=%s\n' OPENCLAW_HOME_VOLUME ''
            # printf '%s=%s\n' OPENCLAW_DOCKER_APT_PACKAGES ''
        fi
    done

    mv "$tmp" "$file"
    # mv /tmp/tmp.7BslX5BzcP /workspaces/openclaw-openclaw/.env
}

upsert_env "$ENV_FILE" \
    OPENCLAW_CONFIG_DIR \
    OPENCLAW_WORKSPACE_DIR \
    OPENCLAW_GATEWAY_PORT \
    OPENCLAW_BRIDGE_PORT \
    OPENCLAW_GATEWAY_BIND \
    OPENCLAW_GATEWAY_TOKEN \
    OPENCLAW_IMAGE \
    OPENCLAW_EXTRA_MOUNTS \
    OPENCLAW_HOME_VOLUME \
    OPENCLAW_DOCKER_APT_PACKAGES
# upsert_env /workspaces/openclaw-openclaw/.env OPENCLAW_CONFIG_DIR OPENCLAW_WORKSPACE_DIR OPENCLAW_GATEWAY_PORT OPENCLAW_BRIDGE_PORT OPENCLAW_GATEWAY_BIND OPENCLAW_GATEWAY_TOKEN OPENCLAW_IMAGE OPENCLAW_EXTRA_MOUNTS OPENCLAW_HOME_VOLUME OPENCLAW_DOCKER_APT_PACKAGES

echo "==> Building Docker image: $IMAGE_NAME"
docker build \
    --build-arg "OPENCLAW_DOCKER_APT_PACKAGES=${OPENCLAW_DOCKER_APT_PACKAGES}" \
    -t "$IMAGE_NAME" \
    -f "$ROOT_DIR/Dockerfile" \
    "$ROOT_DIR"
# docker build --build-arg OPENCLAW_DOCKER_APT_PACKAGES= -t openclaw:local -f /workspaces/openclaw-openclaw/Dockerfile /workspaces/openclaw-openclaw

echo ""
echo "==> Onboarding (interactive)"
echo "When prompted:"
echo "  - Gateway bind: lan"
echo "  - Gateway auth: token"
echo "  - Gateway token: $OPENCLAW_GATEWAY_TOKEN"
echo "  - Tailscale exposure: Off"
echo "  - Install Gateway daemon: No"
echo ""
# ==> Onboarding (interactive)
# When prompted:
#   - Gateway bind: lan
#   - Gateway auth: token
#   - Gateway token: bd74e769ab9ac08389cd2dae92a52161eb2052d64c0fba8e9ee5098ccc0a58f9
#   - Tailscale exposure: Off
#   - Install Gateway daemon: No

docker compose "${COMPOSE_ARGS[@]}" run --rm openclaw-cli onboard --no-install-daemon
# docker compose -f /workspaces/openclaw-openclaw/docker-compose.yml run --rm openclaw-cli onboard --no-install-daemon

echo ""
echo "==> Provider setup (optional)"
echo "WhatsApp (QR):"
echo "  ${COMPOSE_HINT} run --rm openclaw-cli channels login"
echo "Telegram (bot token):"
echo "  ${COMPOSE_HINT} run --rm openclaw-cli channels add --channel telegram --token <token>"
echo "Discord (bot token):"
echo "  ${COMPOSE_HINT} run --rm openclaw-cli channels add --channel discord --token <token>"
echo "Docs: https://docs.openclaw.ai/channels"
# ==> Provider setup (optional)
# WhatsApp (QR):
#   docker compose -f /workspaces/openclaw-openclaw/docker-compose.yml run --rm openclaw-cli channels login
# Telegram (bot token):
#   docker compose -f /workspaces/openclaw-openclaw/docker-compose.yml run --rm openclaw-cli channels add --channel telegram --token <token>
# Discord (bot token):
#   docker compose -f /workspaces/openclaw-openclaw/docker-compose.yml run --rm openclaw-cli channels add --channel discord --token <token>
# Docs: https://docs.openclaw.ai/channels

echo ""
echo "==> Starting gateway"
docker compose "${COMPOSE_ARGS[@]}" up -d openclaw-gateway
# docker compose -f /workspaces/openclaw-openclaw/docker-compose.yml up -d openclaw-gateway

echo ""
echo "Gateway running with host port mapping."
echo "Access from tailnet devices via the host's tailnet IP."
echo "Config: $OPENCLAW_CONFIG_DIR"
echo "Workspace: $OPENCLAW_WORKSPACE_DIR"
echo "Token: $OPENCLAW_GATEWAY_TOKEN"
echo ""
echo "Commands:"
echo "  ${COMPOSE_HINT} logs -f openclaw-gateway"
echo "  ${COMPOSE_HINT} exec openclaw-gateway node dist/index.js health --token \"$OPENCLAW_GATEWAY_TOKEN\""
# Gateway running with host port mapping.
# Access from tailnet devices via the host's tailnet IP.
# Config: /home/codespace/.openclaw
# Workspace: /home/codespace/.openclaw/workspace
# Token: bd74e769ab9ac08389cd2dae92a52161eb2052d64c0fba8e9ee5098ccc0a58f9

# Commands:
#   docker compose -f /workspaces/openclaw-openclaw/docker-compose.yml logs -f openclaw-gateway
#   docker compose -f /workspaces/openclaw-openclaw/docker-compose.yml exec openclaw-gateway node dist/index.js health --token "bd74e769ab9ac08389cd2dae92a52161eb2052d64c0fba8e9ee5098ccc0a58f9"
