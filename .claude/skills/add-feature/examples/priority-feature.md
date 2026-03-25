# Example: Adding a Priority Feature

This example shows how a "priority" feature was implemented end-to-end.

## 1. Model Change (`app/models.py`)

Added a `priority` column with a default of `"medium"`:

```python
class Todo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(160), nullable=False)
    description = db.Column(db.Text, nullable=True)
    priority = db.Column(db.String(10), nullable=False, default="medium")  # NEW
    is_done = db.Column(db.Boolean, nullable=False, default=False)
    created_at = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    completed_at = db.Column(db.DateTime, nullable=True)
```

## 2. Route Change (`app/routes.py`)

Read the priority from the form in `add_todo`:

```python
@main_bp.route("/todos", methods=["POST"])
def add_todo():
    title = request.form.get("title", "").strip()
    description = request.form.get("description", "").strip()
    priority = request.form.get("priority", "medium")  # NEW

    if not title:
        flash("Todo title is required.", "error")
        return redirect(url_for("main.index"))

    todo = Todo(title=title, description=description or None, priority=priority)  # UPDATED
    db.session.add(todo)
    db.session.commit()

    flash("Todo added.", "success")
    return redirect(url_for("main.index"))
```

## 3. Template Change (`app/templates/index.html`)

Added a select dropdown to the form:

```html
<label for="priority">Priority</label>
<select id="priority" name="priority">
  <option value="low">Low</option>
  <option value="medium" selected>Medium</option>
  <option value="high">High</option>
</select>
```

Added a badge in the todo card:

```html
<span class="priority-badge priority-{{ todo.priority }}">{{ todo.priority|capitalize }}</span>
```

## 4. Style Change (`app/static/styles.css`)

```css
.priority-badge {
  display: inline-flex;
  align-items: center;
  padding: 5px 10px;
  border-radius: 999px;
  font-size: 0.78rem;
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.priority-high {
  color: #7a271a;
  background: #ffebe7;
}

.priority-medium {
  color: #78350f;
  background: #fef3c7;
}

.priority-low {
  color: #166534;
  background: #dcfce7;
}

select {
  width: 100%;
  border: 1px solid var(--line);
  border-radius: 16px;
  padding: 14px 16px;
  font: inherit;
  color: var(--ink);
  background: #fff;
  appearance: none;
}
```

## 5. Post-Implementation Notes

- User must delete `instance/todos.db` and restart to pick up the new column
- No new dependencies needed
- Files changed: `models.py`, `routes.py`, `index.html`, `styles.css`
