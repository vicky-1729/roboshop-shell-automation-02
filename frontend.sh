#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="frontend"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup


# nginx setup
dnf module disable nginx -y &>> "$LOG_FILE"
VALIDATE $? "Disabling existing nginx module"

dnf module enable nginx:1.24 -y &>> "$LOG_FILE"
VALIDATE $? "Enabling nginx:1.24 module"

dnf install nginx -y &>> "$LOG_FILE"
VALIDATE $? "Installing nginx:1.24"

systemctl enable nginx  &>> "$LOG_FILE"
VALIDATE $? "Enabling nginx service"

systemctl start nginx &>> "$LOG_FILE"
VALIDATE $? "Starting nginx service"


rm -rf /usr/share/nginx/html/* &>> "$LOG_FILE"
VALIDATE $? "removed default content"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> "$LOG_FILE"
VALIDATE $? "downloading the frontend zip file"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>> "$LOG_FILE"
VALIDATE $? "unzipping the frontend file"

cp $S_DIR/repo_config/nginx.conf /etc/nginx/nginx.conf &>> "$LOG_FILE"
VALIDATE $? "nginx configuration "

systemctl restart nginx &>> "$LOG_FILE"
VALIDATE $? "restarting nginx service"

