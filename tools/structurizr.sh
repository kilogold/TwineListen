#!/usr/bin/env bash

# macOS-only, non-interactive helper for Structurizr Lite
set -euo pipefail

ARG="${1:-}"

if [[ "$ARG" == "-s" || "$ARG" == "-sa" ]]; then
  # Stop Structurizr container
  docker rm -f structurizr-lite >/dev/null 2>&1 || true
  # Optionally stop Docker Desktop
  if [[ "$ARG" == "-sa" ]]; then
    # Force quit Docker Desktop
    # TODO: Ask Docker Desktop (Docker.app) to quit gracefully
    killall "Docker Desktop"

    # Wait until the UI process exits
    while /usr/bin/osascript -e 'tell application "System Events" to (exists process "Docker")' 2>/dev/null | grep -qi true; do
      sleep 1
    done
    # Wait until the backend (com.docker.backend) is gone and engine is down
    while docker info >/dev/null 2>&1 || pgrep -f com.docker.backend >/dev/null 2>&1; do
      sleep 1
    done
  fi
  exit 0
fi

# Start Structurizr Lite (detached)
if ! docker info >/dev/null 2>&1; then
  open --background -a Docker
  until docker info >/dev/null 2>&1; do sleep 1; done
fi

docker pull structurizr/lite >/dev/null 2>&1 || true
docker rm -f structurizr-lite >/dev/null 2>&1 || true
docker run -d --rm \
  --name structurizr-lite \
  -p 8080:8080 \
  -v "$(pwd)/docs:/usr/local/structurizr" \
  -e STRUCTURIZR_WORKSPACE_FILENAME=Plot-Graph \
  structurizr/lite >/dev/null

echo "http://localhost:8080"