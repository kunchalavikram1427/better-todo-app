#!/usr/bin/env bash
# run-tests.sh — Install pytest and run the test suite
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/../../../.." && pwd)"
cd "$PROJECT_DIR"

echo "=== Better Todo App — Test Runner ==="
echo ""

# Ensure venv exists
if [ ! -d ".venv" ]; then
  echo "--- Creating virtual environment ---"
  python3 -m venv .venv
fi

# Install dependencies + pytest
echo "--- Installing dependencies ---"
.venv/bin/pip install -q -r requirements.txt
.venv/bin/pip install -q pytest
echo ""

# Check tests exist
if [ ! -d "tests" ]; then
  echo "ERROR: tests/ directory not found. Generate tests first."
  exit 1
fi

# Run tests
echo "--- Running pytest ---"
echo ""
.venv/bin/python -m pytest tests/ -v --tb=short

echo ""
echo "=== Test Run Complete ==="
