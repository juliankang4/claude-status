#!/bin/bash
set -e

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

"$PROJECT_DIR/Scripts/build.sh"

APP_DIR="$PROJECT_DIR/Build/Claude Status.app"
echo "=== Launching ==="
open "$APP_DIR"
