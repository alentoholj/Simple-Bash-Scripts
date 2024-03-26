#!/bin/bash

# PostgreSQL credentials
PG_USER="postgres"
PG_PASSWORD="test"

# Backup directory
BACKUP_DIR="/var/backups/databases"

# Date format for backup file
DATE_FORMAT=$(date +"%Y-%m-%d_%H-%M-%S")

# Filename for backup
BACKUP_FILENAME="pg_backup_all_${DATE_FORMAT}.sql"

#Create a foler for the backup
mkdir -p $BACKUP_DIR/
# Command to perform backup
pg_dumpall --username="$PG_USER" --password="$PG_PASSWORD" --file="$BACKUP_DIR/$BACKUP_FILENAME"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful. Backup file: $BACKUP_FILENAME"
else
    echo "Backup failed."
fi