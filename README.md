# Todo Spark

```
Create a simple TODO application in Python Flask that takes todo items add, delete, done etc and uses postgres
or similar db. Dockerize and run it locally ability as well. Make the UI good with white background
and colorful buttons and fonts.
```

A simple Flask todo application with:

- Add todo items
- Mark todos done or open
- Delete todos
- Persistent storage with SQLite for quick local runs
- Postgres via Docker Compose
- Clean white UI with colorful buttons and stat cards

## Local Python Run

1. Create and activate a virtual environment:

   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   ```

2. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```

3. Start the app:

   ```bash
   python run.py
   ```

4. Open `http://localhost:5000`

By default, this uses a SQLite database stored at `instance/todos.db`.

## Docker Compose Run

1. Start the app and Postgres:

   ```bash
   docker compose up --build
   ```

2. Open `http://localhost:5000`

In Docker, the app uses Postgres with the connection string defined in `docker-compose.yml`.

## Environment Variables

- `DATABASE_URL`: SQLAlchemy database URL
- `SECRET_KEY`: Flask secret key

Example Postgres URL:

```bash
postgresql+psycopg://todo:todo@localhost:5432/todo_db
```
