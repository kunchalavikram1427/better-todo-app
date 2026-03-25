# Test File Template

Use this structure when creating new test files in `tests/`:

```python
"""Tests for <module_name>."""


class TestClassName:
    """Group: <what this class tests>."""

    def test_descriptive_name(self, client):
        """What this test verifies."""
        # Arrange
        # ... set up test data ...

        # Act
        response = client.get("/")

        # Assert
        assert response.status_code == 200

    def test_another_case(self, client, sample_todo):
        """What this test verifies."""
        # Arrange — sample_todo is already in DB via fixture

        # Act
        response = client.post(
            f"/todos/{sample_todo.id}/toggle",
            follow_redirects=True,
        )

        # Assert
        assert response.status_code == 200
        assert b"Todo updated." in response.data
```

## Naming Conventions

- **Files:** `test_<module>.py` — e.g., `test_routes.py`, `test_models.py`
- **Classes:** `Test<Feature>` — e.g., `TestIndex`, `TestAddTodo`, `TestToggleTodo`
- **Methods:** `test_<behavior>` — e.g., `test_returns_200`, `test_rejects_empty_title`

## Patterns

- Use `follow_redirects=True` when testing POST routes that redirect
- Check `response.data` (bytes) for flash messages and page content
- Use `client.post(url, data={...})` for form submissions
- Access the database within `app.app_context()` when asserting DB state
