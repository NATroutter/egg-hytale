#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Building and pushing dev image..."
docker buildx build --platform linux/amd64,linux/arm64 -t ghcr.io/natroutter/egg-hytale:dev --push "$PROJECT_DIR"