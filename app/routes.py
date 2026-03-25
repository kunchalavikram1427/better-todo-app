from datetime import datetime

from flask import Blueprint, current_app, flash, redirect, render_template, request, url_for

from . import db
from .models import Todo

main_bp = Blueprint("main", __name__)


@main_bp.route("/", methods=["GET"])
def index():
    todos = Todo.query.order_by(Todo.is_done.asc(), Todo.created_at.desc()).all()
    stats = {
        "total": len(todos),
        "done": sum(1 for todo in todos if todo.is_done),
    }
    stats["open"] = stats["total"] - stats["done"]

    db_uri = current_app.config["SQLALCHEMY_DATABASE_URI"]
    db_type = "PostgreSQL" if "postgresql" in db_uri else "SQLite"

    return render_template("index.html", todos=todos, stats=stats, db_type=db_type)


@main_bp.route("/todos", methods=["POST"])
def add_todo():
    title = request.form.get("title", "").strip()
    description = request.form.get("description", "").strip()

    if not title:
        flash("Todo title is required.", "error")
        return redirect(url_for("main.index"))

    todo = Todo(title=title, description=description or None)
    db.session.add(todo)
    db.session.commit()

    flash("Todo added.", "success")
    return redirect(url_for("main.index"))


@main_bp.route("/todos/<int:todo_id>/toggle", methods=["POST"])
def toggle_todo(todo_id: int):
    todo = Todo.query.get_or_404(todo_id)
    todo.is_done = not todo.is_done
    todo.completed_at = datetime.utcnow() if todo.is_done else None
    db.session.commit()

    flash("Todo updated.", "success")
    return redirect(url_for("main.index"))


@main_bp.route("/todos/<int:todo_id>/delete", methods=["POST"])
def delete_todo(todo_id: int):
    todo = Todo.query.get_or_404(todo_id)
    db.session.delete(todo)
    db.session.commit()

    flash("Todo deleted.", "success")
    return redirect(url_for("main.index"))
