#!/bin/bash

BACKUP_DIR="/var/backups/db"
DB_NAME="appdb"
DB_USER="appuser"
DB_CONTAINER="postgres"

TIMESTAMP=$(date '+%Y%m%d')

BACKUP_FILE="${BACKUP_DIR}/db_backup_${TIMESTAMP}.sql.gz"

echo "Starting PostgreSQL backup..."

sudo docker exec "$DB_CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup successful:"
    echo "$BACKUP_FILE"
else
    echo "[WARNING] Database backup failed!"
    rm -f "$BACKUP_FILE"
    exit 1
fi
