# Code Review Checklist

Evaluate every item below. Mark each as PASS, FAIL (with severity), or N/A.

## Security

- [ ] ORM is used for all queries (no raw SQL strings)
- [ ] Jinja2 auto-escaping is enabled (default in Flask)
- [ ] No `| safe` filter on user-supplied data
- [ ] CSRF protection on all POST forms
- [ ] `SECRET_KEY` is loaded from environment, not hardcoded
- [ ] Debug mode is not enabled in production config
- [ ] No sensitive data in version control (`.env`, credentials)
- [ ] Database credentials are not hardcoded in `docker-compose.yml`
- [ ] No `eval()`, `exec()`, or `__import__()` usage

## Flask Best Practices

- [ ] App factory pattern (`create_app()`) is used
- [ ] Routes are organized in Blueprints
- [ ] Custom error handlers exist for 404 and 500
- [ ] Input validation on all form fields
- [ ] `db.session.commit()` is wrapped or has error handling
- [ ] No logic in templates (kept in routes/models)
- [ ] `url_for()` used for all internal URLs (no hardcoded paths)
- [ ] Flash messages use categories (`success`, `error`)

## Code Quality

- [ ] Consistent naming (snake_case for Python, kebab-case for CSS)
- [ ] Type hints on function signatures
- [ ] Docstrings on modules and public functions
- [ ] No unused imports
- [ ] No commented-out code blocks
- [ ] Functions are under 30 lines
- [ ] DRY — no duplicated logic

## Performance

- [ ] Database queries use `.all()` only when needed (not in loops)
- [ ] No N+1 query patterns
- [ ] Pagination for list endpoints
- [ ] Static assets have cache headers or fingerprinting
- [ ] No blocking calls in request handlers

## Docker & Deployment

- [ ] Multi-stage build or slim base image
- [ ] `.dockerignore` excludes unnecessary files
- [ ] Health checks defined for all services
- [ ] Non-root user in container
- [ ] Production WSGI server (gunicorn) instead of Flask dev server
- [ ] Environment variables documented
- [ ] Volumes for persistent data
