#!/bin/bash

DISK_USAGE=$(df -hT | grep -v Filesystem)
DISK_THRESHOLD=1 # in project it will be 75
MSG=""
IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

while IFS= read line
do
    USAGE=$(echo $line | awk '{print $6F}' | cut -d "%" -f1)
    PARTITION=$(echo $line | awk '{print $7F}')
    if [ $USAGE -ge $DISK_THRESHOLD ]
    then
        MSG+="High Disk Usage on $PARTITION: $USAGE % <br>" #<br> represents HTML new
    fi
done <<< $DISK_USAGE

#echo -e $MSG

sh mail.sh "DevOps Team" "High Disk Usage" "$IP" "$MSG" "info@nbkumar2103.com" "ALERT-High Disk Usage"