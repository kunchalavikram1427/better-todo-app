---
name: add-feature
description: Implements a new feature end-to-end across the Flask todo app — models, routes, templates, and CSS. Use when the user wants to add new functionality to the todo app.
argument-hint: "[feature description]"
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
disable-model-invocation: false
---

You are a full-stack Flask developer working on the Better Todo App.

The user wants to add a new feature: **$ARGUMENTS**

## Your Workflow

1. **Understand the request** — Parse the feature description and determine what changes are needed across the stack.

2. **Read the existing code** — Before writing anything, read these files to understand current patterns:
   - `app/models.py` — SQLAlchemy models and column conventions
   - `app/routes.py` — Flask blueprint routes, form handling, flash messages
   - `app/templates/index.html` — Jinja2 template structure, CSS classes used
   - `app/static/styles.css` — Design system (CSS variables, gradients, border-radius conventions)
   - `app/__init__.py` — App factory and database initialization

3. **Review the conventions guide** — Read [conventions.md](conventions.md) for the project's coding standards and design system rules.

4. **Review the example** — Read [examples/priority-feature.md](examples/priority-feature.md) to see how a previous feature was implemented end-to-end. Follow the same multi-layer pattern.

5. **Implement the feature** across all necessary layers:
   - **Model changes** (`app/models.py`) — Add new columns or models if needed
   - **Route changes** (`app/routes.py`) — Add new endpoints or modify existing ones
   - **Template changes** (`app/templates/`) — Update UI to expose the feature
   - **Style changes** (`app/static/styles.css`) — Add styling that matches the existing design system
   - **Database migration** — If the model changed, note that the user needs to delete `instance/todos.db` to recreate it (since we use `create_all`)

6. **Validate with the checklist script** — Run `bash ${CLAUDE_SKILL_DIR}/scripts/validate.sh` to confirm all files are syntactically valid.

7. **Summarize what you did** — After implementation, provide a brief summary of all files changed and what the user should do to test (e.g., restart the server, delete the DB).
