# Automation of Routine DBA Tasks

## Overview

This project focuses on automating routine DBA (Database Administrator) tasks using shell scripts and Python. The automation covers essential tasks such as backups, monitoring, user management, and reporting, which help streamline database management and ensure efficient database operations.

## Technologies

- Bash
- Python

## Key Features

- Automated database backups
- Database monitoring scripts
- User management automation
- Automated reporting

## Project Structure

```
automation-dba-tasks/
├── backup/
│   ├── full_backup.sh
│   ├── incremental_backup.sh
├── monitoring/
│   ├── monitor_db.sh
│   ├── monitor_db.py
├── user_management/
│   ├── create_user.sh
│   ├── delete_user.sh
├── reporting/
│   ├── generate_report.py
├── config/
│   ├── db_config.sh
├── logs/
│   ├── backup.log
│   ├── monitoring.log
│   ├── user_management.log
│   ├── reporting.log
├── README.md
└── LICENSE
```

## Instructions

### 1. Clone the Repository

Start by cloning the repository to your local machine:

```bash
git clone https://github.com/your-username/automation-dba-tasks.git
cd automation-dba-tasks
```

### 2. Configure Database Settings

Modify the `db_config.sh` file to include your database connection details.

#### Configuration File: `db_config.sh`

```bash
#!/bin/bash

# db_config.sh
# Database configuration settings

# Database connection details
DB_HOST="your_database_host"
DB_PORT="your_database_port"
DB_USER="your_database_user"
DB_PASSWORD="your_database_password"
DB_NAME="your_database_name"
```

### 3. Backup Scripts

#### Full Backup Script: `full_backup.sh`

```bash
#!/bin/bash

# full_backup.sh
# Script to perform a full database backup

source ../config/db_config.sh

BACKUP_DIR="/path/to/backup/directory"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_full_$(date +'%Y%m%d').bak"

echo "Starting full backup for database $DB_NAME..."
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -b -v -f $BACKUP_FILE $DB_NAME
echo "Full backup completed: $BACKUP_FILE"
echo "$(date): Full backup completed: $BACKUP_FILE" >> ../logs/backup.log
```

#### Incremental Backup Script: `incremental_backup.sh`

```bash
#!/bin/bash

# incremental_backup.sh
# Script to perform an incremental database backup

source ../config/db_config.sh

BACKUP_DIR="/path/to/backup/directory"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_incremental_$(date +'%Y%m%d').bak"

echo "Starting incremental backup for database $DB_NAME..."
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -F c -a -v -f $BACKUP_FILE $DB_NAME
echo "Incremental backup completed: $BACKUP_FILE"
echo "$(date): Incremental backup completed: $BACKUP_FILE" >> ../logs/backup.log
```

### 4. Monitoring Scripts

#### Shell Script for Monitoring: `monitor_db.sh`

```bash
#!/bin/bash

# monitor_db.sh
# Script to monitor database status

source ../config/db_config.sh

echo "Checking database status..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT pg_is_in_recovery();" > ../logs/monitoring.log
echo "$(date): Database status checked" >> ../logs/monitoring.log
```

#### Python Script for Monitoring: `monitor_db.py`

```python
# monitor_db.py
# Python script to monitor database status

import psycopg2
from configparser import ConfigParser
import logging
import datetime

def config(filename='../config/db_config.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)

    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    return db

def check_db_status():
    conn = None
    try:
        params = config()
        conn = psycopg2.connect(**params)
        cur = conn.cursor()
        cur.execute('SELECT pg_is_in_recovery();')
        db_status = cur.fetchone()
        cur.close()
        return db_status[0]
    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(f"Error: {error}")
        return None
    finally:
        if conn is not None:
            conn.close()

if __name__ == '__main__':
    logging.basicConfig(filename='../logs/monitoring.log', level=logging.INFO)
    status = check_db_status()
    logging.info(f"{datetime.datetime.now()}: Database recovery status: {status}")
```

### 5. User Management Scripts

#### Create User Script: `create_user.sh`

```bash
#!/bin/bash

# create_user.sh
# Script to create a new database user

source ../config/db_config.sh

NEW_USER=$1
NEW_PASSWORD=$2

if [[ -z "$NEW_USER" || -z "$NEW_PASSWORD" ]]; then
  echo "Usage: $0 <username> <password>"
  exit 1
fi

echo "Creating new user $NEW_USER..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "CREATE USER $NEW_USER WITH PASSWORD '$NEW_PASSWORD';"
echo "User $NEW_USER created."
echo "$(date): User $NEW_USER created" >> ../logs/user_management.log
```

#### Delete User Script: `delete_user.sh`

```bash
#!/bin/bash

# delete_user.sh
# Script to delete a database user

source ../config/db_config.sh

USER_TO_DELETE=$1

if [[ -z "$USER_TO_DELETE" ]]; then
  echo "Usage: $0 <username>"
  exit 1
fi

echo "Deleting user $USER_TO_DELETE..."
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "DROP USER $USER_TO_DELETE;"
echo "User $USER_TO_DELETE deleted."
echo "$(date): User $USER_TO_DELETE deleted" >> ../logs/user_management.log
```

### 6. Reporting Script

#### Python Script for Reporting: `generate_report.py`

```python
# generate_report.py
# Python script to generate a database report

import psycopg2
from configparser import ConfigParser
import logging
import datetime

def config(filename='../config/db_config.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)

    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    return db

def generate_report():
    conn = None
    report_data = []
    try:
        params = config()
        conn = psycopg2.connect(**params)
        cur = conn.cursor()
        cur.execute('SELECT * FROM some_table;')  # Replace with your query
        report_data = cur.fetchall()
        cur.close()
    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(f"Error: {error}")
    finally:
        if conn is not None:
            conn.close()
    return report_data

if __name__ == '__main__':
    logging.basicConfig(filename='../logs/reporting.log', level=logging.INFO)
    report = generate_report()
    logging.info(f"{datetime.datetime.now()}: Report generated: {report}")
```

### 7. Log Files

Log files are created for each category of tasks:

- `backup.log`: Logs for backup operations
- `monitoring.log`: Logs for monitoring operations
- `user_management.log`: Logs for user management operations
- `reporting.log`: Logs for reporting operations

### Conclusion

By following these steps, you can automate routine DBA tasks using the provided shell scripts and Python scripts. The automation covers backups, monitoring, user management, and reporting, ensuring efficient and streamlined database management.

## Contributing

We welcome contributions to improve this project. If you would like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

For questions or issues, please open an issue in the repository or contact the project maintainers at [your-email@example.com].

---

Thank you for using the Automation of Routine DBA Tasks project! We hope this guide helps you streamline your database management tasks.
