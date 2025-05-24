#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="shipping"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup

# Application setup
app_setup

#maven installation
maven_setup

#mysql client setup
dnf install mysql -y &>> "$LOG_FILE"
VALIDATE $? "installing mysql "

DB_EXISTS=$(mysql -h mysql.tcloudguru.in -u root -pRoboShop@1 -sse "SHOW DATABASES LIKE 'cities';")
if [ "$DB_EXISTS" != "cities" ]; then
    mysql -h mysql.tcloudguru.in -u root -pRoboShop@1 -e 'CREATE DATABASE cities;' &>> "$LOG_FILE"
    VALIDATE $? "Creating cities database"

    mysql -h mysql.tcloudguru.in -u root -pRoboShop@1 cities < /app/db/schema.sql &>> "$LOG_FILE"
    VALIDATE $? "Loading schema.sql"

    mysql -h mysql.tcloudguru.in -u root -pRoboShop@1 cities < /app/db/app-user.sql &>> "$LOG_FILE"
    VALIDATE $? "Loading app-user.sql"

    mysql -h mysql.tcloudguru.in -u root -pRoboShop@1 cities < /app/db/master-data.sql &>> "$LOG_FILE"
    VALIDATE $? "Loading master-data.sql"
else
    echo -e "Database data is ${y}already loaded${reset}, skipping..." | tee -a "$LOG_FILE"
fi


systemctl restart shipping
VALIDATE $? "restarting shipping service"
