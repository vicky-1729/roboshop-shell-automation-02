#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="catalogue"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup

# Application setup
app_setup

# Node.js setup
nodejs_setup

# Systemd Service setup
systemd_setup

# MongoDB client setup
cp $S_DIR/repo_config/mongo.repo /etc/yum.repos.d/mongodb.repo &>> "$LOG_FILE"
VALIDATE $? "Copying MongoDB repo file"

dnf install mongodb-mongosh -y &>> "$LOG_FILE"
VALIDATE $? "Installing MongoDB shell"

# Load data into MongoDB if not already present
STATUS=$(mongosh --host mongodb.tcloudguru.in --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ "$STATUS" -lt 0 ]; then
    mongosh --host mongodb.tcloudguru.in </app/db/master-data.js &>> "$LOG_FILE"
    VALIDATE $? "Loading data into MongoDB"
else
    echo -e "Data is already loaded ... ${y}SKIPPING${reset}" | tee -a "$LOG_FILE"
fi

