#!/bin/bash

#Script for compressing and moving logs to the specific destination

# Destination of the folders
destination="PATH_WHERE_YOU_WILL_CREATE_FOLDERS_AND_STORE_LOGS"

# Get the hostname
hostname=$(hostname)

# Compress all log files to zst format
find "PATH_WHERE_LOGS_EXISTING" -not -path '*/.*' -type f -name '*.log' -print0 -mtime +3 | sudo xargs -0 zstd --rm

# Find files, create folders and move logs to the specific folder based on date in filename
find "PATH_WHERE_LOGS_EXISTING" -not -path '*/.*' -type f -name '*.log.zst' |
while IFS= read -r file; do
    target_directory="$destination/$hostname/$(echo "$file" | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}' | tr - /)"
    mkdir -p "$target_directory"
    mv "$file" "$target_directory/"
done
