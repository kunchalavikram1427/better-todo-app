#!/usr/bin/env bash
# preflight.sh — Verify Docker prerequisites before launching the stack
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/../../../.." && pwd)"
cd "$PROJECT_DIR"

echo "=== Pre-flight Checks ==="
echo ""

ERRORS=0

# 1. Docker CLI
echo -n "  Docker CLI:     "
if command -v docker &>/dev/null; then
  DOCKER_VERSION=$(docker --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  echo "v${DOCKER_VERSION} ✓"
else
  echo "NOT FOUND ✗"
  echo "  → Install Docker: https://docs.docker.com/get-docker/"
  ERRORS=$((ERRORS + 1))
fi

# 2. Docker Compose
echo -n "  Docker Compose: "
if docker compose version &>/dev/null; then
  COMPOSE_VERSION=$(docker compose version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)
  echo "v${COMPOSE_VERSION} ✓"
else
  echo "NOT FOUND ✗"
  echo "  → Docker Compose is included with Docker Desktop"
  ERRORS=$((ERRORS + 1))
fi

# 3. Docker daemon running
echo -n "  Docker daemon:  "
if docker info &>/dev/null; then
  echo "running ✓"
else
  echo "NOT RUNNING ✗"
  echo "  → Start Docker Desktop or run: sudo systemctl start docker"
  ERRORS=$((ERRORS + 1))
fi

# 4. docker-compose.yml exists
echo -n "  Compose file:   "
if [ -f "docker-compose.yml" ]; then
  echo "found ✓"
else
  echo "MISSING ✗"
  echo "  → Expected docker-compose.yml in project root"
  ERRORS=$((ERRORS + 1))
fi

# 5. Existing containers
echo -n "  Existing stack: "
RUNNING=$(docker compose ps --status running -q 2>/dev/null | wc -l | tr -d ' ')
if [ "$RUNNING" -gt 0 ]; then
  echo "${RUNNING} container(s) already running"
  docker compose ps 2>/dev/null
else
  echo "not running"
fi

echo ""

# 6. Port availability
echo -n "  Port 5000:      "
if lsof -i :5000 -sTCP:LISTEN &>/dev/null; then
  echo "IN USE ⚠ (another process is using port 5000)"
else
  echo "available ✓"
fi

echo -n "  Port 5432:      "
if lsof -i :5432 -sTCP:LISTEN &>/dev/null; then
  echo "IN USE ⚠ (another process is using port 5432)"
else
  echo "available ✓"
fi

echo ""

if [ "$ERRORS" -eq 0 ]; then
  echo "=== ALL PRE-FLIGHT CHECKS PASSED ==="
else
  echo "=== $ERRORS CHECK(S) FAILED — fix the issues above before proceeding ==="
  exit 1
fi
