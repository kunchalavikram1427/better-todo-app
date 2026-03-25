# Example: Successful Docker Compose Launch

This shows the expected output when everything goes well.

---

```
=== Pre-flight Checks ===
  Docker CLI:     v27.4.0 ✓
  Docker Compose: v2.32.0 ✓
  Existing stack: not running

=== Building & Starting ===
  $ docker compose up --build -d
  [+] Building 12.3s (10/10) FINISHED
  [+] Running 2/2
   ✔ Container better-todo-app-db-1   Healthy
   ✔ Container better-todo-app-web-1  Started

=== Health Checks ===
  db:  healthy (PostgreSQL 17 ready)
  web: running

=== Verification ===
  HTTP GET http://localhost:5000 → 200 OK
```

## Docker Stack Status

| Service | Status  | Port        |
|---------|---------|-------------|
| web     | Running | 5000 → 5000 |
| db      | Healthy | 5432 → 5432 |

**App URL:** http://localhost:5000

### Useful Commands

| Action | Command |
|--------|---------|
| Stop the stack | `docker compose down` |
| Tail app logs | `docker compose logs -f web` |
| Rebuild & restart | `docker compose up --build -d` |
