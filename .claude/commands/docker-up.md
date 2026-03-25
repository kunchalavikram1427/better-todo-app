Build and launch the Better Todo App using Docker Compose.

## Steps

1. **Pre-flight checks:**
   - Verify `docker` and `docker compose` are available on the system
   - Check if containers are already running with `docker compose ps`
   - If running, ask whether to rebuild or just show status

2. **Build and start:**
   - Run `docker compose up --build -d` to build images and start in detached mode
   - Stream the build output so the user can see progress

3. **Wait for health checks:**
   - Monitor `docker compose ps` until the `db` service shows as healthy
   - Show container status once everything is up

4. **Verify the app is reachable:**
   - Use `curl -s -o /dev/null -w "%{http_code}" http://localhost:5000` to check if the web service responds
   - Report the HTTP status code

5. **Report:**
   - Confirm the app is running at **http://localhost:5000**
   - Show the running containers and their ports
   - Remind the user they can stop with `docker compose down`
   - Mention `docker compose logs -f web` to tail app logs
