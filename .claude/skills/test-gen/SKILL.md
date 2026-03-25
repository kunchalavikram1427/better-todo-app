---
name: test-gen
description: Generates a comprehensive pytest test suite for the todo app covering all routes, models, and edge cases. Use when the user wants to add tests or improve test coverage.
argument-hint: "[routes|models|all]"
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
disable-model-invocation: false
---

Generate a comprehensive pytest test suite for the Better Todo App.

Scope: **$ARGUMENTS** (defaults to `all` if not specified).

## Steps

1. **Read the source code** to understand all testable behavior:
   - `app/__init__.py` — App factory and database setup
   - `app/models.py` — Todo model and its fields
   - `app/routes.py` — All route handlers and their behavior

2. **Use the test templates** — Read the template files for the boilerplate structure:
   - [templates/conftest.py.md](templates/conftest.py.md) — Shared pytest fixture template
   - [templates/test-template.py.md](templates/test-template.py.md) — Test file template with naming conventions

3. **Refer to the example** — Read [examples/sample-tests.md](examples/sample-tests.md) to see what a completed test file looks like for this app's patterns.

4. **Create the test directory and files:**

   **`tests/conftest.py`** — Shared fixtures (use the template from step 2):
   - A `app` fixture with a temporary SQLite database
   - A `client` fixture with Flask's test client
   - A `sample_todo` fixture that creates a test todo item

   **`tests/test_routes.py`** — Route tests covering:
   - `GET /` — Returns 200, displays page content, shows stats
   - `POST /todos` — Creates a todo, rejects empty title
   - `POST /todos/<id>/toggle` — Toggles done/open, 404 on missing
   - `POST /todos/<id>/delete` — Deletes a todo, 404 on missing
   - Sort order: open todos before done todos

   **`tests/test_models.py`** — Model tests covering:
   - Todo creation, defaults, `__repr__`, optional fields

5. **Add `pytest` to `requirements.txt`** if not already present.

6. **Run the validation script** — Execute `bash ${CLAUDE_SKILL_DIR}/scripts/run-tests.sh` to run the suite and confirm all tests pass.

7. **Report results** — Show the test output summary.
