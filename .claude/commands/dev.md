Set up and start the Flask development server for the Better Todo App.

Follow these steps in order:

1. **Check for a Python virtual environment:**
   - If `.venv/` does not exist, create one with `python3 -m venv .venv`
   - Activate it for subsequent commands using the path `.venv/bin/pip` and `.venv/bin/python`

2. **Install dependencies:**
   - Run `.venv/bin/pip install -r requirements.txt` to ensure all packages are up to date
   - Only show output if there are errors

3. **Start the development server:**
   - Run `FLASK_DEBUG=1 .venv/bin/python run.py` to start Flask with debug mode and auto-reload enabled
   - Tell the user the app will be available at **http://localhost:5000**

4. **Report status:**
   - Confirm the server is running
   - Mention that hot-reload is enabled so code changes will auto-apply
   - If anything fails, diagnose the error and suggest a fix
