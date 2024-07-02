#!/bin/bash

# incremental_backup.sh
# Script to perform an incremental database backup

# Load database configuration
source ../config/db_config.sh

# Directory where backups will be stored
BACKUP_DIR="/path/to/backup/directory"

# Construct the backup file name
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_incremental_$(date +'%Y%m%d%H%M').bak"

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

echo "Starting incremental backup for database $DB_NAME..."

# Perform the incremental backup using pg_dump with the --data-only option
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -a -v -f $BACKUP_FILE $DB_NAME

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Incremental backup completed successfully: $BACKUP_FILE"
    echo "$(date): Incremental backup completed successfully: $BACKUP_FILE" >> ../logs/backup.log
else
    echo "Incremental backup failed"
    echo "$(date): Incremental backup failed" >> ../logs/backup.log
fi
