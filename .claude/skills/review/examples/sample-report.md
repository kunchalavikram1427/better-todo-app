# Example Review Report

This is a sample output showing the expected format for a code review.

---

## Code Review Report — Better Todo App

### Security

| # | Severity | File | Line | Finding | Recommendation |
|---|----------|------|------|---------|----------------|
| 1 | CRITICAL | `app/routes.py` | all POST routes | No CSRF protection — forms submit without tokens | Add `Flask-WTF` or implement CSRF middleware |
| 2 | WARNING | `app/__init__.py` | 38 | Default `SECRET_KEY` is `"dev-secret-key"` — predictable | Require `SECRET_KEY` env var in production, raise error if missing |
| 3 | INFO | `docker-compose.yml` | 11 | DB password `todo` is weak and visible in compose file | Use Docker secrets or `.env` file for credentials |

### Flask Best Practices

| # | Severity | File | Line | Finding | Recommendation |
|---|----------|------|------|---------|----------------|
| 4 | WARNING | `app/routes.py` | — | No custom error handlers for 404/500 | Add `@app.errorhandler(404)` and `@app.errorhandler(500)` with styled templates |
| 5 | INFO | `app/routes.py` | 42 | `get_or_404` is good, but no error logging | Add `app.logger.error()` for unexpected conditions |

### Code Quality

| # | Severity | File | Line | Finding | Recommendation |
|---|----------|------|------|---------|----------------|
| 6 | INFO | `app/models.py` | all | No docstrings on the model class | Add a brief docstring explaining the Todo model |
| 7 | INFO | `app/routes.py` | all | No type hints on route functions | Add return type hints (`-> str`) to route handlers |

### Performance

| # | Severity | File | Line | Finding | Recommendation |
|---|----------|------|------|---------|----------------|
| 8 | WARNING | `app/routes.py` | 13 | `Todo.query...all()` loads everything into memory | Add pagination for large datasets |

### Docker & Deployment

| # | Severity | File | Line | Finding | Recommendation |
|---|----------|------|------|---------|----------------|
| 9 | WARNING | `Dockerfile` | 18 | Uses Flask dev server in production (`CMD flask run`) | Use `gunicorn` for production: `CMD ["gunicorn", "-b", "0.0.0.0:5000", "run:app"]` |
| 10 | INFO | `Dockerfile` | 1 | Good: uses `python:3.12-slim` base image | No action needed |

---

## Summary

**Health Score: 6.5 / 10**

### Top 3 Priorities
1. **Add CSRF protection** — All POST forms are unprotected (CRITICAL)
2. **Production WSGI server** — Replace Flask dev server with gunicorn in Docker (WARNING)
3. **Add pagination** — The todo list loads all items into memory (WARNING)
