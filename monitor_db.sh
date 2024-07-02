#!/bin/bash

# monitor_db.sh
# Script to monitor database status

# Load database configuration
source ../config/db_config.sh

# Log file for monitoring output
LOG_FILE="../logs/monitoring.log"

# Function to check database status
check_db_status() {
    echo "Checking database status..."
    STATUS=$(psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT pg_is_in_recovery();" -t -A)
    if [ $? -eq 0 ]; then
        if [ "$STATUS" == "f" ]; then
            echo "$(date): Database is in primary mode." >> $LOG_FILE
        elif [ "$STATUS" == "t" ]; then
            echo "$(date): Database is in recovery mode." >> $LOG_FILE
        else
            echo "$(date): Unable to determine database status." >> $LOG_FILE
        fi
    else
        echo "$(date): Failed to check database status." >> $LOG_FILE
    fi
}

# Function to check database connection
check_db_connection() {
    echo "Checking database connection..."
    psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$(date): Database connection successful." >> $LOG_FILE
    else
        echo "$(date): Database connection failed." >> $LOG_FILE
    fi
}

# Run checks
check_db_connection
check_db_status

echo "Database monitoring completed."
