---
name: dev
description: Sets up the Python virtual environment, installs dependencies, and starts the Flask development server with hot-reload. Use when the user wants to run the app locally.
argument-hint: "[port]"
allowed-tools: Bash, Read
disable-model-invocation: true
---

Set up and start the Flask development server for the Better Todo App.

If a port is provided via arguments, use it: **$ARGUMENTS** (default: 5000).

## Steps

Follow the setup script for reference: [scripts/setup.sh](scripts/setup.sh). Execute each step:

1. **Check for a Python virtual environment:**
   - If `.venv/` does not exist, create one with `python3 -m venv .venv`
   - Use `.venv/bin/pip` and `.venv/bin/python` for all subsequent commands

2. **Install dependencies:**
   - Run `.venv/bin/pip install -r requirements.txt` to ensure all packages are up to date
   - Only show output if there are errors

3. **Start the development server:**
   - Run `FLASK_DEBUG=1 .venv/bin/python run.py` to start Flask with debug mode and auto-reload enabled
   - If the user passed a port via `$ARGUMENTS`, modify the command accordingly
   - Tell the user the app will be available at **http://localhost:{port}**

4. **Report status** — refer to [templates/status-report.md](templates/status-report.md) for the output format:
   - Confirm the server is running
   - Mention that hot-reload is enabled so code changes will auto-apply
   - If anything fails, diagnose the error and suggest a fix
