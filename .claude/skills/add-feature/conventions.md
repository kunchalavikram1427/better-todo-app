# Better Todo App — Coding Conventions

## Python / Flask

- **App factory pattern** — All initialization lives in `app/__init__.py` via `create_app()`
- **Blueprints** — Routes are registered on `main_bp = Blueprint("main", __name__)`
- **Form handling** — Use `request.form.get("field", "").strip()` for POST data
- **Validation** — Check required fields, `flash()` errors, then `redirect()` back
- **Success flow** — After a write operation: `db.session.commit()`, `flash()`, `redirect(url_for(...))`
- **Query ordering** — `Todo.query.order_by(Todo.is_done.asc(), Todo.created_at.desc())`
- **Timestamps** — Use `datetime.utcnow` for `created_at` defaults and `completed_at` on toggle

## SQLAlchemy Models

- Primary key: `db.Column(db.Integer, primary_key=True)`
- String fields: `db.Column(db.String(160), nullable=False)`
- Optional text: `db.Column(db.Text, nullable=True)`
- Booleans: `db.Column(db.Boolean, nullable=False, default=False)`
- Timestamps: `db.Column(db.DateTime, nullable=False, default=datetime.utcnow)`
- Always add `__repr__` returning `f"<ModelName {self.id} {self.title!r}>"`

## Templates (Jinja2)

- All pages extend `base.html`
- Use `{{ url_for('main.route_name') }}` for URLs
- Use `{{ url_for('static', filename='styles.css') }}` for assets
- Flash messages: `get_flashed_messages(with_categories=true)` with `flash-success` / `flash-error` classes
- Cards use class `todo-card` inside a `todo-list` grid
- Status badges: `badge-open` (orange) and `badge-done` (green)

## CSS Design System

### Variables (`:root`)
| Token       | Value     | Usage                  |
|-------------|-----------|------------------------|
| `--pink`    | `#ff5c8a` | Primary accent         |
| `--orange`  | `#ff8a3d` | Secondary accent       |
| `--yellow`  | `#ffc944` | Warm highlight         |
| `--green`   | `#27c27a` | Success state          |
| `--blue`    | `#3578ff` | Info / link color      |
| `--cyan`    | `#19b6d2` | Cool accent            |
| `--ink`     | `#1c2440` | Primary text           |
| `--muted`   | `#667085` | Secondary text         |
| `--line`    | `#e7eaf4` | Borders                |

### Component Patterns
- **Buttons** — `border-radius: 999px`, gradient backgrounds, `font-weight: 800`
  - `.btn-primary` — pink → orange gradient
  - `.btn-success` — green → cyan gradient
  - `.btn-secondary` — gray gradient
  - `.btn-danger` — red gradient
- **Cards** — `border-radius: 28px`, `box-shadow: var(--shadow)`, white background
- **Stat tiles** — `border-radius: 22px`, full-bleed gradient backgrounds, white text
- **Badges** — `border-radius: 999px`, light colored backgrounds, dark text
- **Inputs** — `border-radius: 16px`, `1px solid var(--line)`, `:focus` with blue outline

### Responsive Breakpoints
- `920px` — Stack to single column
- `640px` — Tighter padding, single-column stats
