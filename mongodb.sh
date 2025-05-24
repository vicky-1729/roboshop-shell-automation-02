#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="mongodb"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup

# MongoDB setup
cp $S_DIR/repo_config/mongo.repo /etc/yum.repos.d/mongodb.repo &>> $LOG_FILE
VALIDATE $? "Copying MongoDB repo file"

dnf install mongodb-org -y &>> $LOG_FILE
VALIDATE $? "Installing MongoDB server"

systemctl enable mongod &>> $LOG_FILE
systemctl start mongod &>> $LOG_FILE
VALIDATE $? "Starting MongoDB server"

systemctl status mongod | grep Active &>> $LOG_FILE
VALIDATE $? "Checking MongoDB server status"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf &>> $LOG_FILE
VALIDATE $? "Updating bind IP in mongod.conf"

systemctl restart mongod &>> $LOG_FILE
VALIDATE $? "Restarting MongoDB server"
