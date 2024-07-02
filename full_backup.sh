#!/bin/bash

# full_backup.sh
# Script to perform a full database backup

# Load database configuration
source ../config/db_config.sh

# Directory where backups will be stored
BACKUP_DIR="/path/to/backup/directory"

# Construct the backup file name
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_full_$(date +'%Y%m%d').bak"

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

echo "Starting full backup for database $DB_NAME..."

# Perform the full backup using pg_dump
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -b -v -f $BACKUP_FILE $DB_NAME

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Full backup completed successfully: $BACKUP_FILE"
    echo "$(date): Full backup completed successfully: $BACKUP_FILE" >> ../logs/backup.log
else
    echo "Full backup failed"
    echo "$(date): Full backup failed" >> ../logs/backup.log
fi
