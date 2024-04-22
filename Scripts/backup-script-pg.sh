#!/bin/bash

# Logging function
log() {
    local log_file=/var/lib/postgresql/backup_script.log
    echo "$(date "+%Y-%m-%d %H:%M:%S") $1" >> "$log_file"
}

# Log script start
log "Script Started"

# Location to place backups
backup_dir="/var/backups/databases"
log "Location to place backups: $backup_dir"

# String to append to the name of the backup files
backup_date=$(date +%Y%m%d_%H%M%S)
log "String to append to the name of the backup files: $backup_date"

# Numbers of days you want to keep copies of your databases
number_of_days=15
log "Numbers of days you want to keep copies of your databases: $number_of_days"

# Create folders where  we will store our backups
mkdir -p "$backup_dir"

# Get list of databases
databases=$(psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d' | grep -v 'template*')
log "Backup of databases: $databases"

# Backup each database
for db in $databases; do
    pg_dump "$db" > "$backup_dir/$db-full-backup-$backup_date.sql"
    if [ $? -eq 0 ]; then
        log "Backup of $db successful."
        gzip "$backup_dir/$db-full-backup-$backup_date.sql"
    else
        log "Backup of $db failed."
    fi
done

# Rotate backups
rotate_backups() {
    # Weekly backup rotation on Sundays
    if [ "$(date +%u)" -eq 20 ]; then
        find "$backup_dir"/* -type f -prune -mtime +20 -exec rm -f {} \;
    fi

    log "Backup rotation completed"
}

rotate_backups

# Log script end
log "Script Finished"
