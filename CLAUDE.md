# CLAUDE.md — Project Guide for Better Todo App

This file is automatically loaded by Claude Code at the start of every session. It provides the context Claude needs to work effectively in this codebase.

## Project Overview

**Better Todo App** (Todo Spark) is a full-stack task management web application built with Flask. It supports CRUD operations on todo items with a polished, responsive UI. The project also serves as a **demo for Claude Code skills and commands**.

## Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Backend framework | Flask | 3.1.1 |
| ORM | Flask-SQLAlchemy | 3.1.1 |
| Database (local) | SQLite | bundled with Python |
| Database (Docker) | PostgreSQL | 17 |
| DB driver | psycopg (binary) | 3.2.10 |
| Templating | Jinja2 | bundled with Flask |
| Styling | Custom CSS (no framework) | — |
| Containerization | Docker + Docker Compose | — |
| Python | 3.12 | slim image |

## Architecture

```
┌─────────────────────────────────────────────────┐
│                    Browser                       │
│         GET / POST to http://localhost:5000      │
└────────────────────┬────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────┐
│                  Flask App                       │
│                                                  │
│  run.py ──► create_app() ──► register blueprint  │
│                                                  │
│  ┌─────────────┐    ┌──────────────────────┐    │
│  │  routes.py   │    │  templates/          │    │
│  │  (Blueprint) │───►│  base.html           │    │
│  │              │    │  index.html           │    │
│  │  GET  /      │    └──────────────────────┘    │
│  │  POST /todos │                                │
│  │  POST toggle │    ┌──────────────────────┐    │
│  │  POST delete │    │  static/styles.css   │    │
│  └──────┬───────┘    └──────────────────────┘    │
│         │                                        │
│  ┌──────▼───────┐                                │
│  │  models.py    │                                │
│  │  Todo model   │                                │
│  └──────┬───────┘                                │
│         │  SQLAlchemy ORM                        │
└─────────┼────────────────────────────────────────┘
          │
┌─────────▼────────────────────────────────────────┐
│              Database                             │
│  Local:  SQLite  (instance/todos.db)             │
│  Docker: PostgreSQL 17 (todo_db)                 │
└──────────────────────────────────────────────────┘
```

## Project Structure

```
better-todo-app/
├── app/
│   ├── __init__.py            # App factory (create_app), DB init with retry logic
│   ├── models.py              # Todo SQLAlchemy model
│   ├── routes.py              # Blueprint with 4 route handlers
│   ├── static/
│   │   └── styles.css         # Full design system (CSS variables, gradients, responsive)
│   └── templates/
│       ├── base.html          # Base layout (head, CSS link)
│       └── index.html         # Main page (hero, stats, form, todo list)
├── .claude/
│   ├── agents/                # Subagents (autonomous Claude instances)
│   │   └── change-summarizer.md  # Analyzes diffs, summarizes changes
│   ├── commands/              # Simple slash commands (single .md files)
│   │   ├── health.md          # /health — project health check
│   │   └── reset-db.md        # /reset-db — delete local SQLite DB
│   └── skills/                # Rich skills (directories with supporting files)
│       ├── add-feature/       # /add-feature — full-stack feature scaffolding
│       ├── dev/               # /dev — start dev server
│       ├── review/            # /review — code quality audit
│       ├── test-gen/          # /test-gen — generate pytest suite
│       └── docker-up/         # /docker-up — Docker Compose launcher
├── run.py                     # Entry point — creates app, starts Flask server
├── requirements.txt           # Flask, Flask-SQLAlchemy, psycopg
├── Dockerfile                 # Python 3.12-slim, installs deps, runs Flask
├── docker-compose.yml         # web + PostgreSQL 17 with health checks
├── .gitignore
├── .dockerignore
├── CLAUDE.md                  # This file
└── README.md                  # User-facing documentation
```

## Key Files and What They Do

### `app/__init__.py` — App Factory

- `create_app()` builds the Flask app using the factory pattern
- Reads `DATABASE_URL`, `SECRET_KEY` from environment (falls back to SQLite and dev defaults)
- `initialize_database()` uses retry logic (`DB_CONNECT_RETRIES` / `DB_CONNECT_DELAY`) to wait for PostgreSQL in Docker
- Calls `db.create_all()` only if tables don't exist yet

### `app/models.py` — Data Model

Single model: `Todo`

| Column | Type | Notes |
|--------|------|-------|
| `id` | Integer | Primary key, auto-increment |
| `title` | String(160) | Required |
| `description` | Text | Optional |
| `is_done` | Boolean | Default `False` |
| `created_at` | DateTime | Auto-set to `datetime.utcnow` |
| `completed_at` | DateTime | Set on toggle to done, cleared on toggle to open |

### `app/routes.py` — Route Handlers

All routes are on the `main_bp` Blueprint.

| Route | Method | What it does |
|-------|--------|-------------|
| `/` | GET | Query all todos (open first, then done), compute stats, render `index.html` |
| `/todos` | POST | Validate title, create Todo, flash success, redirect to `/` |
| `/todos/<id>/toggle` | POST | Flip `is_done`, set/clear `completed_at`, redirect to `/` |
| `/todos/<id>/delete` | POST | Delete the todo, redirect to `/` |

Pattern: every POST route ends with `db.session.commit()` → `flash()` → `redirect(url_for("main.index"))`.

### `app/templates/index.html` — Main Page

- Extends `base.html`
- Hero section with tagline and 3 stat tiles (Total, Open, Done)
- Two-column layout: form panel (left) + todo list panel (right)
- Todo cards with status badge, title, description, timestamps, and action buttons
- Flash message stack below the form
- Empty state when no todos exist

### `app/static/styles.css` — Design System

CSS custom properties on `:root`:

| Token | Value | Usage |
|-------|-------|-------|
| `--pink` | `#ff5c8a` | Primary accent, buttons |
| `--orange` | `#ff8a3d` | Secondary accent |
| `--green` | `#27c27a` | Success state |
| `--blue` | `#3578ff` | Info, links |
| `--cyan` | `#19b6d2` | Cool accent |
| `--ink` | `#1c2440` | Primary text |
| `--muted` | `#667085` | Secondary text |
| `--line` | `#e7eaf4` | Borders |

Component conventions:
- Buttons: `border-radius: 999px`, gradient backgrounds, `font-weight: 800`
- Cards: `border-radius: 28px`, `box-shadow: var(--shadow)`
- Badges: `border-radius: 999px`, light backgrounds
- Inputs: `border-radius: 16px`, `:focus` blue outline
- Responsive breakpoints: `920px` (single column), `640px` (tight padding)

## Coding Conventions

### Python
- App factory pattern with `create_app()`
- Routes on a Blueprint named `main_bp`
- Form data: `request.form.get("field", "").strip()`
- Validation: check required → `flash("message", "error")` → `redirect()`
- After writes: `db.session.commit()` → `flash("message", "success")` → `redirect(url_for(...))`
- Imports: stdlib first, then Flask/SQLAlchemy, then local (`. import`)

### Templates
- All pages extend `base.html`
- URLs via `url_for("main.route_name")` — never hardcoded
- Flash messages use `get_flashed_messages(with_categories=true)` with `flash-success` / `flash-error` CSS classes

### CSS
- Use CSS variables from `:root` — never hardcode color values
- Gradient backgrounds on buttons via `linear-gradient(135deg, ...)`
- Mobile-first responsive with `@media (max-width: ...)` breakpoints

## Database Notes

- **Local development:** SQLite at `instance/todos.db`. Auto-created on first run.
- **Docker:** PostgreSQL 17 at `postgresql+psycopg://todo:todo@db:5432/todo_db`.
- **Schema changes:** No migration tool is configured. Delete `instance/todos.db` (or the Docker volume) and restart to recreate tables.
- **Retry logic:** On startup, the app retries database connections up to `DB_CONNECT_RETRIES` times with `DB_CONNECT_DELAY` seconds between attempts. This handles the Docker Compose race where the web service starts before PostgreSQL is ready.

## Running the App

```bash
# Local with SQLite
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
python run.py                      # http://localhost:5000

# Docker with PostgreSQL
docker compose up --build          # http://localhost:5000

# With Claude Code skills
/dev                               # local setup + start
/docker-up                         # Docker setup + start
```

## Available Claude Code Slash Commands

| Command | Type | What it does |
|---------|------|-------------|
| `/health` | command | Quick health check — git, venv, deps, DB, Docker |
| `/reset-db` | command | Delete SQLite DB for clean schema reset |
| `/add-feature [desc]` | skill | Implement a feature across models, routes, templates, CSS |
| `/dev [port]` | skill | Set up venv, install deps, start dev server |
| `/review [area]` | skill | Code quality audit with severity-rated findings |
| `/test-gen [scope]` | skill | Generate a pytest test suite |
| `/docker-up [flag]` | skill | Build and launch Docker Compose stack |

## Claude Code Agents (Subagents)

Agents are autonomous Claude instances that run as subprocesses. Unlike commands/skills (which guide the main Claude session), agents are **separate Claude sessions** that work independently and return results.

| Agent | File | What it does | Has Memory? |
|-------|------|-------------|-------------|
| `change-summarizer` | `.claude/agents/change-summarizer.md` | Analyzes git diffs and summarizes changes since the last commit | Yes (project-scoped) |

### How Agents Differ from Commands & Skills

| | Commands / Skills | Agents |
|---|---|---|
| **Execution** | Run inline in the main Claude session | Spawn a separate Claude subprocess |
| **Location** | `.claude/commands/` or `.claude/skills/` | `.claude/agents/` |
| **Invocation** | Slash command (`/health`) or auto-trigger | Parent agent launches via Agent tool |
| **Blocking** | Always inline | Foreground (blocks) or background (async) |
| **Memory** | No persistent memory | Can have persistent file-based memory |
| **Context** | Shares main session context | Gets its own isolated context |

### Agent Execution Modes

- **Foreground** (default): Parent waits for the agent to finish before continuing
- **Background** (`run_in_background: true`): Parent continues immediately; gets notified on completion
- **Worktree** (`isolation: "worktree"`): Agent works in an isolated git worktree copy of the repo

## Common Development Tasks

| Task | How to do it |
|------|-------------|
| Add a new route | Add to `app/routes.py` on `main_bp`, update `index.html` template |
| Add a model column | Edit `app/models.py`, delete `instance/todos.db`, restart |
| Add a new page | Create `app/templates/page.html` extending `base.html`, add route |
| Add CSS styles | Edit `app/static/styles.css`, use existing CSS variables |
| Run tests | `python -m pytest tests/ -v` (after `/test-gen` generates them) |
| Check code quality | `/review` or `bash .claude/skills/review/scripts/lint.sh` |
