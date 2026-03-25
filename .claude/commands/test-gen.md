Generate a comprehensive pytest test suite for the Better Todo App.

## Steps

1. **Read the source code** to understand all testable behavior:
   - `app/__init__.py` — App factory and database setup
   - `app/models.py` — Todo model and its fields
   - `app/routes.py` — All route handlers and their behavior

2. **Create the test directory and files:**

   **`tests/conftest.py`** — Shared fixtures:
   - A `app` fixture that creates a Flask app with a temporary SQLite database (use `tmp_path`)
   - A `client` fixture that provides Flask's test client
   - A `sample_todo` fixture that creates and returns a test todo item
   - Use `app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{tmp_path / 'test.db'}"`

   **`tests/test_routes.py`** — Route tests covering:
   - `GET /` — Returns 200, displays page content
   - `GET /` — Shows stats (total, open, done counts)
   - `POST /todos` — Creates a new todo, redirects, shows flash message
   - `POST /todos` — Rejects empty title with error flash
   - `POST /todos` — Handles title with whitespace-only input
   - `POST /todos/<id>/toggle` — Toggles todo between done/open, sets `completed_at`
   - `POST /todos/<id>/toggle` — Returns 404 for nonexistent todo
   - `POST /todos/<id>/delete` — Deletes a todo, redirects
   - `POST /todos/<id>/delete` — Returns 404 for nonexistent todo
   - Verify sort order: open todos before done todos

   **`tests/test_models.py`** — Model tests covering:
   - Todo creation with required fields
   - Default values (`is_done=False`, `created_at` auto-set)
   - String representation (`__repr__`)
   - Optional fields (`description`, `completed_at`)

3. **Add `pytest` to `requirements.txt`** if not already present.

4. **Run the tests** with `cd` to project root and execute:
   ```
   .venv/bin/python -m pytest tests/ -v
   ```
   Fix any failures before finishing.

5. **Report results** — Show the test output and confirm all tests pass.
