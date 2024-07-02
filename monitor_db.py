# monitor_db.py
# Python script to monitor database status

import psycopg2
from configparser import ConfigParser
import logging
import datetime

# Function to read database configuration
def config(filename='../config/db_config.ini', section='postgresql'):
    parser = ConfigParser()
    parser.read(filename)

    db = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception(f'Section {section} not found in the {filename} file')
    return db

# Function to check database connection
def check_db_connection():
    try:
        params = config()
        conn = psycopg2.connect(**params)
        conn.close()
        logging.info(f"{datetime.datetime.now()}: Database connection successful.")
    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(f"{datetime.datetime.now()}: Database connection failed. Error: {error}")

# Function to check database status
def check_db_status():
    try:
        params = config()
        conn = psycopg2.connect(**params)
        cur = conn.cursor()
        cur.execute('SELECT pg_is_in_recovery();')
        status = cur.fetchone()[0]
        if status is False:
            logging.info(f"{datetime.datetime.now()}: Database is in primary mode.")
        elif status is True:
            logging.info(f"{datetime.datetime.now()}: Database is in recovery mode.")
        else:
            logging.warning(f"{datetime.datetime.now()}: Unable to determine database status.")
        cur.close()
        conn.close()
    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(f"{datetime.datetime.now()}: Failed to check database status. Error: {error}")

if __name__ == '__main__':
    # Configure logging
    logging.basicConfig(filename='../logs/monitoring.log', level=logging.INFO,
                        format='%(asctime)s %(levelname)s:%(message)s')
    
    # Run checks
    check_db_connection()
    check_db_status()

    logging.info("Database monitoring completed.")
