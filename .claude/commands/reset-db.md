---
name: reset-db
description: Deletes the local SQLite database and restarts the app so tables are recreated fresh. Use when schema changes require a clean database.
argument-hint: ""
---

Reset the local SQLite database for the Better Todo App.

## Steps

1. Check if `instance/todos.db` exists
2. If it exists, delete it: `rm instance/todos.db`
3. Confirm deletion
4. Tell the user to restart the server (`/dev`) so the tables are recreated via `db.create_all()`
5. If the file doesn't exist, tell the user there's nothing to reset
