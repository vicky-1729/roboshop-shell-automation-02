#!/bin/bash

#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="rabbitMQ"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup


cp repo_config/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> "LOG_FILE"
VALIDATE $? "rabbitMQ repo adding"


dnf install rabbitmq-server -y &>> "LOG_FILE"
VALIDATE $? "Installing rabbitMQ-server"

systemctl enable rabbitmq-server &>> "LOG_FILE"
VALIDATE $? "enabling rabbitMQ"

systemctl start rabbitmq-server &>> "LOG_FILE"
VALIDATE $? "starting rabbitMQ"


rabbitmqctl add_user roboshop roboshop123 &>> "LOG_FILE"
VALIDATE $? "adding of roboshop user and group "

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> "LOG_FILE"
VALIDATE $? "added permission "