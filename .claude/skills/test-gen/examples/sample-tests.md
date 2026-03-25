# Example: Completed Test Suite

This shows what the finished test files should look like.

## tests/test_routes.py

```python
"""Tests for Flask route handlers."""

from app.models import Todo


class TestIndex:
    """Tests for GET /."""

    def test_returns_200(self, client):
        """Homepage loads successfully."""
        response = client.get("/")
        assert response.status_code == 200

    def test_shows_app_title(self, client):
        """Page contains the app heading."""
        response = client.get("/")
        assert b"Task Tracker" in response.data

    def test_shows_stats(self, client):
        """Stats section is rendered."""
        response = client.get("/")
        assert b"Total" in response.data
        assert b"Open" in response.data
        assert b"Done" in response.data

    def test_empty_state(self, client):
        """Shows empty state message when no todos exist."""
        response = client.get("/")
        assert b"No todos yet" in response.data

    def test_displays_todo(self, client, sample_todo):
        """Shows existing todos on the page."""
        response = client.get("/")
        assert sample_todo.title.encode() in response.data


class TestAddTodo:
    """Tests for POST /todos."""

    def test_creates_todo(self, app, client):
        """Valid form creates a new todo."""
        response = client.post(
            "/todos",
            data={"title": "New Task", "description": "Details"},
            follow_redirects=True,
        )
        assert response.status_code == 200
        assert b"Todo added." in response.data

        with app.app_context():
            assert Todo.query.count() == 1

    def test_rejects_empty_title(self, client):
        """Empty title shows error flash."""
        response = client.post(
            "/todos",
            data={"title": "", "description": ""},
            follow_redirects=True,
        )
        assert b"Todo title is required." in response.data

    def test_rejects_whitespace_title(self, client):
        """Whitespace-only title shows error flash."""
        response = client.post(
            "/todos",
            data={"title": "   ", "description": ""},
            follow_redirects=True,
        )
        assert b"Todo title is required." in response.data


class TestToggleTodo:
    """Tests for POST /todos/<id>/toggle."""

    def test_marks_done(self, app, client, sample_todo):
        """Toggle marks an open todo as done."""
        response = client.post(
            f"/todos/{sample_todo.id}/toggle",
            follow_redirects=True,
        )
        assert response.status_code == 200

        with app.app_context():
            todo = Todo.query.get(sample_todo.id)
            assert todo.is_done is True
            assert todo.completed_at is not None

    def test_marks_open(self, app, client, sample_todo):
        """Double toggle reopens a done todo."""
        client.post(f"/todos/{sample_todo.id}/toggle")
        client.post(
            f"/todos/{sample_todo.id}/toggle",
            follow_redirects=True,
        )

        with app.app_context():
            todo = Todo.query.get(sample_todo.id)
            assert todo.is_done is False
            assert todo.completed_at is None

    def test_404_for_missing(self, client):
        """Toggling a nonexistent todo returns 404."""
        response = client.post("/todos/99999/toggle")
        assert response.status_code == 404


class TestDeleteTodo:
    """Tests for POST /todos/<id>/delete."""

    def test_deletes_todo(self, app, client, sample_todo):
        """Delete removes the todo from the database."""
        response = client.post(
            f"/todos/{sample_todo.id}/delete",
            follow_redirects=True,
        )
        assert response.status_code == 200
        assert b"Todo deleted." in response.data

        with app.app_context():
            assert Todo.query.count() == 0

    def test_404_for_missing(self, client):
        """Deleting a nonexistent todo returns 404."""
        response = client.post("/todos/99999/delete")
        assert response.status_code == 404
```

## tests/test_models.py

```python
"""Tests for SQLAlchemy models."""

from app.models import Todo


class TestTodoModel:
    """Tests for the Todo model."""

    def test_create_with_required_fields(self, app, db):
        """Todo can be created with just a title."""
        with app.app_context():
            todo = Todo(title="Minimal Todo")
            db.session.add(todo)
            db.session.commit()

            assert todo.id is not None
            assert todo.title == "Minimal Todo"

    def test_default_values(self, app, db):
        """New todo has correct defaults."""
        with app.app_context():
            todo = Todo(title="Defaults")
            db.session.add(todo)
            db.session.commit()

            assert todo.is_done is False
            assert todo.created_at is not None
            assert todo.completed_at is None
            assert todo.description is None

    def test_repr(self, sample_todo):
        """String representation is readable."""
        r = repr(sample_todo)
        assert "Todo" in r
        assert "Test Todo" in r

    def test_optional_description(self, app, db):
        """Description can be set."""
        with app.app_context():
            todo = Todo(title="With desc", description="Some details")
            db.session.add(todo)
            db.session.commit()

            assert todo.description == "Some details"
```
