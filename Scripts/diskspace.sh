#!/bin/bash

ALERT=85
ADMINISTRATOR="FILL_WITH_ADMIN_EMAIL"

df -H | grep -vE "^Filesystem|tmpfs" | awk '{ print $1 " " $5}' | while read -r output 
do
    diskspace=$(echo "$output" | awk '{ print $2 }' | cut -d'%' -f1)
    partition=$(echo "$output" | awk '{ print $1 }')

    if [[ $diskspace -ge $ALERT ]]; then
        echo "Running out of space \"$partition ($diskspace%)\" on $(hostname) as on $(date)" |
        echo -e "Subject:Disk Usage on $(hostname)!! \n\nThe disk usage on $(hostname) machine is high!! Disk usage is: $diskspace%" | sudo sendmail -t $ADMINISTRATOR 2> /dev/null
    fi

done
