# Docker Status Report Template

Use this format when reporting Docker Compose status to the user:

---

## Docker Stack Status

| Service | Status | Port |
|---------|--------|------|
| web     | {RUNNING / STOPPED / ERROR} | {HOST_PORT} → {CONTAINER_PORT} |
| db      | {HEALTHY / UNHEALTHY / STOPPED} | {HOST_PORT} → {CONTAINER_PORT} |

**App URL:** http://localhost:{PORT}
**HTTP Check:** {STATUS_CODE}

### Useful Commands

| Action | Command |
|--------|---------|
| Stop the stack | `docker compose down` |
| Tail app logs | `docker compose logs -f web` |
| Tail DB logs | `docker compose logs -f db` |
| Rebuild & restart | `docker compose up --build -d` |
| View all containers | `docker compose ps` |
| Open a shell in web | `docker compose exec web bash` |
| Connect to DB | `docker compose exec db psql -U todo todo_db` |

---
