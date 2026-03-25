---
name: docker-up
description: Builds and launches the full Docker Compose stack (Flask + PostgreSQL), monitors health checks, and reports status. Use when the user wants to run the app in containers.
argument-hint: "[--rebuild | --status | --down]"
allowed-tools: Bash, Read
disable-model-invocation: true
---

Build and launch the Better Todo App using Docker Compose.

Action flag: **$ARGUMENTS** (defaults to build-and-start if not specified).

## Steps

1. **Run the pre-flight check script** — Execute `bash ${CLAUDE_SKILL_DIR}/scripts/preflight.sh` to verify Docker is available and report current container state.

2. **Determine the action:**
   - `--rebuild` or no argument: build and start the stack
   - `--status`: only report current container status
   - `--down`: stop and remove the stack

3. **Build and start (default):**
   - Run `docker compose up --build -d` to build images and start in detached mode
   - Stream the build output so the user can see progress

4. **Wait for health checks:**
   - Monitor `docker compose ps` until the `db` service shows as healthy
   - Show container status once everything is up

5. **Verify the app is reachable:**
   - Use `curl -s -o /dev/null -w "%{http_code}" http://localhost:5000` to check the web service
   - Report the HTTP status code

6. **Report** — Use the format from [templates/status-report.md](templates/status-report.md):
   - Confirm the app is running at **http://localhost:5000**
   - Show running containers and their ports
   - Remind the user of useful commands (`docker compose down`, `docker compose logs -f web`)
