# conftest.py Template

Use this as the starting boilerplate for `tests/conftest.py`:

```python
import pytest

from app import create_app, db as _db
from app.models import Todo


@pytest.fixture()
def app(tmp_path):
    """Create a Flask application configured for testing."""
    test_db = tmp_path / "test.db"
    app = create_app()
    app.config.update(
        {
            "TESTING": True,
            "SQLALCHEMY_DATABASE_URI": f"sqlite:///{test_db}",
            "WTF_CSRF_ENABLED": False,
            "SECRET_KEY": "test-secret",
        }
    )

    with app.app_context():
        _db.create_all()
        yield app
        _db.drop_all()


@pytest.fixture()
def client(app):
    """Provide the Flask test client."""
    return app.test_client()


@pytest.fixture()
def db(app):
    """Provide the database session."""
    with app.app_context():
        yield _db


@pytest.fixture()
def sample_todo(app, db):
    """Create and return a sample todo for testing."""
    with app.app_context():
        todo = Todo(title="Test Todo", description="A test description")
        db.session.add(todo)
        db.session.commit()
        db.session.refresh(todo)
        yield todo
```

## Notes
- Uses `tmp_path` for an isolated database per test session
- Yields the app inside an app context for clean teardown
- `sample_todo` commits and refreshes so the todo has a valid `id`
