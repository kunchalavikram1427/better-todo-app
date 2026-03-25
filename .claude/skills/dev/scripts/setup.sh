#!/usr/bin/env bash
# setup.sh — Bootstrap the dev environment for Better Todo App
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/../../../.." && pwd)"
cd "$PROJECT_DIR"

PORT="${1:-5000}"

echo "=== Better Todo App — Dev Setup ==="
echo "Project: $PROJECT_DIR"
echo ""

# 1. Virtual environment
if [ ! -d ".venv" ]; then
  echo "--- Creating virtual environment ---"
  python3 -m venv .venv
  echo "  Created .venv/"
else
  echo "--- Virtual environment already exists ---"
fi
echo ""

# 2. Install dependencies
echo "--- Installing dependencies ---"
.venv/bin/pip install -q -r requirements.txt
echo "  Dependencies installed."
echo ""

# 3. Start the server
echo "--- Starting Flask dev server on port $PORT ---"
echo "  URL: http://localhost:$PORT"
echo "  Debug: ON | Auto-reload: ON"
echo "  Press Ctrl+C to stop."
echo ""

FLASK_DEBUG=1 .venv/bin/python run.py
