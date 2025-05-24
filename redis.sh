#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="redis"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup

# redis setup
dnf module disable redis -y &>> "$LOG_FILE"
VALIDATE $? "Disabling existing redis module"

dnf module enable redis:7 -y &>> "$LOG_FILE"
VALIDATE $? "Enabling redis module"

dnf install redis -y &>> "$LOG_FILE"
VALIDATE $? "Installing redis 7"


sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Edited redis.conf to accept remote connections"

systemctl enable redis &>> "$LOG_FILE"
VALIDATE $? "Enabling redis service"

systemctl start redis &>> "$LOG_FILE"
VALIDATE $? "Starting redis service"