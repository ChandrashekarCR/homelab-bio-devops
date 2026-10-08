#!/usr/bin/env bash
set -euo pipefail

JELLYFIN_DIR="/etc/jellyfin"
CACHE_DIR="/var/cache/jellyfin"
MOVIES_DIR="/media/movies"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${COMPOSE_FILE:-$SCRIPT_DIR/docker-compose.yaml}"

if [[ $EUID -ne 0 ]]; then
    echo "Run as root (sudo $0)" >&2
    exit 1
fi

if [[ ! -f "$COMPOSE_FILE" ]]; then
    echo "ERROR: Compose file not found at $COMPOSE_FILE" >&2
    echo "Set COMPOSE_FILE=/path/to/docker-compose.yaml or place it next to this script." >&2
    exit 1
fi

echo "Step 1: Creating host paths"
mkdir -p "$JELLYFIN_DIR" "$CACHE_DIR"

if [[ ! -d "$MOVIES_DIR" ]]; then
    echo "Creating movie directory at $MOVIES_DIR..."
    mkdir -p "$MOVIES_DIR"
    chmod 0755 "$MOVIES_DIR"
fi

echo "Step 2: Deploying the container (compose file: $COMPOSE_FILE)"
docker compose -f "$COMPOSE_FILE" up -d

echo "Step 3: Verifying container is running"
if ! docker compose -f "$COMPOSE_FILE" ps --status running --services | grep -qx jellyfin; then
    echo "ERROR: Jellyfin container is not running. Logs:" >&2
    docker compose -f "$COMPOSE_FILE" logs --tail=50 jellyfin >&2 || true
    exit 1
fi

echo "=================================================="
echo "SUCCESS: Jellyfin is running."
echo "Media Directory:   $MOVIES_DIR"
echo "Access Setup Wizard on the host: http://localhost:8096"
echo "From another machine: http://<host-ip>:8096"
echo "=================================================="

# Run this as sudo ./setup_jellyfin.sh from the /scripts/jellyfin directory