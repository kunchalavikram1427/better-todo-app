Perform a thorough code review of the Better Todo App codebase.

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

2. **Evaluate these categories** and provide findings for each:

### Security
- SQL injection risks (is the ORM used properly?)
- XSS vulnerabilities in templates (auto-escaping enabled?)
- CSRF protection (are forms protected?)
- Secret key management (hardcoded vs environment?)
- Debug mode exposure in production

### Flask Best Practices
- App factory pattern usage
- Blueprint organization
- Error handling (404, 500 pages)
- Input validation completeness
- Database session management

### Code Quality
- Code organization and separation of concerns
- Naming conventions and consistency
- DRY principle adherence
- Type hints usage
- Docstrings and comments

### Performance
- Database query efficiency (N+1 problems?)
- Static asset optimization
- Pagination for large datasets

### Docker & Deployment
- Dockerfile best practices (layer caching, image size)
- Docker Compose health checks
- Environment variable handling
- Production readiness

3. **Output a structured report** with:
   - A severity rating for each finding: `CRITICAL`, `WARNING`, or `INFO`
   - The specific file and line number
   - A clear description of the issue
   - A concrete fix or recommendation

4. **End with a summary** — Overall health score (out of 10) and top 3 priorities to address.
