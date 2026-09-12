# Task 2: Containerization & Web Services

## Docker Setup

Docker Compose is used to run three services:

- Nginx
- Flask backend
- PostgreSQL database

The basic flow is:

Browser
   ↓
Nginx :80
   ↓
Flask :5000
   ↓
PostgreSQL :5432

## Services

### Nginx
Nginx runs on port 80 and works as the reverse proxy.

### Flask Backend
The Flask application runs inside the backend container on port `5000`.

### PostgreSQL
PostgreSQL is used as the database and runs on port `5432`.

A persistent Docker volume is used for the PostgreSQL data.

## Running the Services

Start all services:

sudo docker-compose up -d

Check the services:

sudo docker-compose ps

Stop the services:

sudo docker-compose down

## Testing

The application was tested through Nginx using:

curl http://localhost/

The response showed:

Hello from Flask!
Backend is working.
Database connection successful

This confirmed that Nginx was able to forward the request to the Flask backend and the backend was able to connect to PostgreSQL.

## Screenshots

### Docker Containers
Screenshot of:

sudo docker-compose ps

showing the `backend`, `nginx`, and `postgres` containers running.

### Reverse Proxy
Screenshot of the application opened through:

http://localhost/

## Task 3: Automation & Shell Scripting

A Bash script was created at:

`/opt/scripts/infra_health_check.sh`

The script checks:

- CPU usage
- RAM usage
- Root disk usage
- Docker status
- Backend container status

Warnings are printed when the disk usage is above 85% or the backend container is stopped.

Warnings are also logged in:

`/var/log/infra_health.log`

The script is scheduled to run every 15 minutes using cron.

Cron entry:

`*/15 * * * * /opt/scripts/infra_health_check.sh`

The script was manually tested and showed CPU, RAM, disk, Docker, and backend container status successfully.
