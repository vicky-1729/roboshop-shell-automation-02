#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="mysql"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup

# mysqld setup
dnf install mysql-server -y &>> "$LOG_FILE"
VALIDATE $? "Installing mysqld "

systemctl enable mysqld &>> "$LOG_FILE"
VALIDATE $? "Enabling mysqld service"

systemctl start mysqld &>> "$LOG_FILE"
VALIDATE $? "Starting mysqld service"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "mysqld password status creating "