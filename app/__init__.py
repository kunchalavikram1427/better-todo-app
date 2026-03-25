import os
import time

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import inspect
from sqlalchemy.exc import OperationalError

db = SQLAlchemy()


def initialize_database(app: Flask, models_module) -> None:
    retries = int(os.getenv("DB_CONNECT_RETRIES", "10"))
    delay_seconds = float(os.getenv("DB_CONNECT_DELAY", "2"))

    for attempt in range(1, retries + 1):
        try:
            inspector = inspect(db.engine)
            if not inspector.has_table(models_module.Todo.__tablename__):
                db.create_all()
            return
        except OperationalError:
            if attempt == retries:
                raise
            app.logger.warning(
                "Database is not ready yet. Retrying in %s seconds (%s/%s).",
                delay_seconds,
                attempt,
                retries,
            )
            time.sleep(delay_seconds)


def create_app() -> Flask:
    app = Flask(__name__, instance_relative_config=True)
    os.makedirs(app.instance_path, exist_ok=True)

    app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "dev-secret-key")
    app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv(
        "DATABASE_URL",
        f"sqlite:///{os.path.join(app.instance_path, 'todos.db')}",
    )
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)

    from . import models
    from .routes import main_bp

    app.register_blueprint(main_bp)

    with app.app_context():
        initialize_database(app, models)

    return app
