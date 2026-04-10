#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shellscript-logs"
SCRIPT_NAME=$(basename "$0" .sh)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
SOURCE_DIR="/home/ec2-user/app-logs"

mkdir -p "$LOGS_FOLDER"

if [ "$USERID" -ne 0 ]; then
    echo -e "$R ERROR:: Please run this script with root access $N" | tee -a "$LOG_FILE"
    exit 1
else
    echo "You are running with root access" | tee -a "$LOG_FILE"
fi

VALIDATE() {
    if [ $1 -eq 0 ]; then
        echo -e "$2 ... $G SUCCESS $N" | tee -a "$LOG_FILE"
    else
        echo -e "$2 ... $R FAILURE $N" | tee -a "$LOG_FILE"
        exit 1
    fi
}

echo "Script started executing at $(date)" | tee -a "$LOG_FILE"

# ✅ Check if directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "$R ERROR:: Source directory $SOURCE_DIR does not exist $N" | tee -a "$LOG_FILE"
    exit 1
fi

# ✅ Find and delete safely
find "$SOURCE_DIR" -type f -name "*.log" -mtime +14 | while read -r filepath
do
    echo "Deleting file: $filepath" | tee -a "$LOG_FILE"
    rm -f "$filepath"
    VALIDATE $? "Deleting $filepath"
done

echo -e "$G Script executed successfully $N" | tee -a "$LOG_FILE"