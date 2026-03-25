---
name: status
description: Quick project health check — shows git status, dependency state, and whether the app can start. A lightweight alternative to the full /review skill.
argument-hint: ""
---

Give a quick status overview of the Better Todo App project.

## Steps

1. Run `git status` to show the working tree state
2. Check if `.venv/` exists and if `requirements.txt` deps are installed
3. Check if `instance/todos.db` exists (local SQLite database)
4. Check if Docker containers are running with `docker compose ps 2>/dev/null`
5. Summarize everything in a short table:

| Item | Status |
|------|--------|
| Git branch | ... |
| Uncommitted changes | yes/no |
| Python venv | exists/missing |
| Dependencies | installed/missing |
| SQLite DB | exists/missing |
| Docker stack | running/stopped/not installed |
