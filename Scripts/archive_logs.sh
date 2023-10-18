#!/bin/bash

#If we have more destinations where we store logs, we wiil use function because we can call a function numerous time
#$path="where logs existing"
#$pattern="cover all logs in $path"
#$exp="cover logs older than a certain date"

set -e

hostdir="/home/carpel/Documents"
hostname=$(hostname)

function archive_logs() {
    path="$1"
    pattern="$2"
    exp="$3"

    if [[ $(find "$path" -not -path '*/.*' -type f -name "$pattern" -mtime +"${exp}" -print | wc -l) -gt 0 ]]; then
        find "$path" -not -path '*/.*' -type f -name "$pattern" -mtime +${exp} -print | sudo xargs zstd --rm
    fi

    for file in "$path"/*.zst; do
        echo "sudo mkdir -p "$hostdir/$hostname/$(echo "$file" | cut -d _ -f3 | tr - /)/$(basename ${path})""
        echo "sudo mv "$file" "$hostdir/$hostname/$(echo "$file" | cut -d _ -f3 | tr - /)/$(basename ${path})""
    done
}

archive_logs /var/log/test '*.log' 3


