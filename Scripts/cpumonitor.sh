#!/bin/bash
cpu=$(top -b -n1 | awk '/Cpu/ {print $2}' | cut -d , -f1)
hostname=$(hostname)

if [[ ${cpu} -gt 75 ]]
then
    echo -e "Subject:CPU Usage!! \n\nThe cpu usage on ${hostname} machine is too high!! CPU usage is: ${cpu}%" | sendmail -t "YOUR EMAIL" 2> /dev/null
fi
