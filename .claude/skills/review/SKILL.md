---
name: review
description: Performs a comprehensive code review of the todo app covering security, Flask best practices, performance, and deployment. Use when the user wants a code quality audit or asks about potential issues.
argument-hint: "[file-or-area]"
allowed-tools: Read, Grep, Glob
disable-model-invocation: false
---

Perform a thorough code review of the Better Todo App codebase.

If the user specified a scope, focus on: **$ARGUMENTS** (otherwise review the entire codebase).

## Review Process

1. **Read all source files:**
   - `app/__init__.py` — App factory, DB config
   - `app/models.py` — Data models
   - `app/routes.py` — Route handlers
   - `app/templates/base.html` — Base template
   - `app/templates/index.html` — Main page template
   - `app/static/styles.css` — Stylesheets
   - `run.py` — Entry point
   - `Dockerfile` and `docker-compose.yml` — Container setup
   - `requirements.txt` — Dependencies

2. **Use the review checklist** — Read [templates/review-checklist.md](templates/review-checklist.md) and evaluate every item in it.

3. **Refer to the example report** — Read [examples/sample-report.md](examples/sample-report.md) to match the expected output format.

4. **Output a structured report** with:
   - A severity rating for each finding: `CRITICAL`, `WARNING`, or `INFO`
   - The specific file and line number
   - A clear description of the issue
   - A concrete fix or recommendation

5. **End with a summary** — Overall health score (out of 10) and top 3 priorities to address.
