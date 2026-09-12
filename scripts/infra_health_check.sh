#!/bin/bash

LOG_FILE="/var/log/infra_health.log"
APP_CONTAINER="backend"
DISK_THRESHOLD=85

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "========================================"
echo "Infrastructure Health Check"
echo "Time: $TIMESTAMP"
echo "========================================"

# CPU Usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')

echo "CPU Usage: ${CPU_USAGE}%"

# RAM Usage
RAM_USAGE=$(free | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}')

echo "RAM Usage: ${RAM_USAGE}%"

# Root Disk Usage
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

echo "Root Disk Usage: ${DISK_USAGE}%"

# Docker Status
if systemctl is-active --quiet docker; then
    echo "Docker: RUNNING"
else
    echo "[WARNING] Docker is NOT running"
    echo "[$TIMESTAMP] [WARNING] Docker is NOT running" | sudo tee -a "$LOG_FILE" > /dev/null
fi

# Application Container Status
if docker ps --format '{{.Names}}' | grep -q "^${APP_CONTAINER}$"; then
    echo "Application Container ($APP_CONTAINER): RUNNING"
else
    echo "[WARNING] Application container ($APP_CONTAINER) is STOPPED"
    echo "[$TIMESTAMP] [WARNING] Application container ($APP_CONTAINER) is STOPPED" | sudo tee -a "$LOG_FILE" > /dev/null
fi

# Disk Usage Alert
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "[WARNING] Root disk usage is ${DISK_USAGE}%"
    echo "[$TIMESTAMP] [WARNING] Root disk usage is ${DISK_USAGE}%" | sudo tee -a "$LOG_FILE" > /dev/null
fi

echo "========================================"
