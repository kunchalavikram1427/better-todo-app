# Dev Server Status Report Template

Use this format when reporting the server status to the user:

---

## Dev Server Status

| Item              | Status        |
|-------------------|---------------|
| Python venv       | {CREATED / ALREADY EXISTS} |
| Dependencies      | {INSTALLED / UP TO DATE}   |
| Flask server      | {RUNNING / FAILED}         |
| Debug mode        | {ON / OFF}                 |
| Auto-reload       | {ENABLED / DISABLED}       |

**URL:** http://localhost:{PORT}

### Quick Commands
- Stop the server: `Ctrl+C`
- Check logs: scroll the terminal output
- Restart: run `/dev` again

### Troubleshooting
- **Port in use:** Try `/dev 5001` to use a different port
- **Import errors:** Check `requirements.txt` and re-run `/dev`
- **Database errors:** Delete `instance/todos.db` and restart

---
