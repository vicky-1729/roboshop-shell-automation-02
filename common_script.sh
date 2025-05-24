#!/bin/bash

# writing function for color
color(){
# Color codes
r="\033[31m"   # Red
g="\033[32m"   # Green
y="\033[33m"   # Yellow
b="\033[34m"   # Blue
m="\033[35m"   # Magenta
reset="\033[0m" # Reset

}

# Root privilege checking function 
check_root(){
USERID=$(id -u)
if [ "$USERID" -ne 0 ]; then
    echo -e "${r}ERROR:: Please run this script with root access${reset}" | tee -a "$LOG_FILE"
    exit 1
fi
}


# logfile checking function
logfile_setup(){
LOGS_FOLDER="/var/log/roboshop-logs"
mkdir -p "$LOGS_FOLDER"  # Create log directory
SCRIPT_NAME=$(echo "$0" | cut -d '.' -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
S_DIR=$PWD
}

# Validation function setup
VALIDATE() {
    if [ "$1" -eq 0 ]; then
        echo -e "$2 ... ${g}SUCCESS${reset}" | tee -a "$LOG_FILE"
    else
        echo -e "$2 ... ${r}FAILURE${reset}" | tee -a "$LOG_FILE"
        exit 1
    fi
}


# Application setup funtion
app_setup()
{
if id roboshop &>/dev/null; then
    echo -e "roboshop $service_name is ${g}already created${y} ... skipping${reset}" | tee -a "$LOG_FILE"
else
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system $service_name" roboshop &>> "$LOG_FILE"
    VALIDATE $? "Creating roboshop system $service_name"
fi

mkdir -p /app &>> "$LOG_FILE"
VALIDATE $? "Creating /app directory"

rm -rf /app/* &>> "$LOG_FILE"

curl -L -o /tmp/$service_name.zip https://roboshop-artifacts.s3.amazonaws.com/$service_name-v3.zip &>> "$LOG_FILE"
VALIDATE $? "Downloading $service_name.zip"

cd /app
unzip /tmp/$service_name.zip &>> "$LOG_FILE"
VALIDATE $? "Unzipping $service_name.zip"

}
# systemd service function
systemd_setup(){
cp $S_DIR/service/$service_name.service /etc/systemd/system/$service_name.service &>> "$LOG_FILE"
VALIDATE $? "Copying $service_name service file"

systemctl daemon-reload &>> "$LOG_FILE"
VALIDATE $? "Reloading system"

systemctl enable $service_name &>> "$LOG_FILE"
VALIDATE $? "Enabling $service_name service"

systemctl start $service_name &>> "$LOG_FILE"
VALIDATE $? "Starting $service_name service"

}

# nodejs installation function 
nodejs_setup(){
dnf module disable nodejs -y &>> "$LOG_FILE"
VALIDATE $? "Disabling existing Node.js module"

dnf module enable nodejs:20 -y &>> "$LOG_FILE"
VALIDATE $? "Enabling Node.js 20 module"

dnf install nodejs -y &>> "$LOG_FILE"
VALIDATE $? "Installing Node.js 20"

npm install &>> "$LOG_FILE"
VALIDATE $? "Installing Node.js dependencies"

}

# maven installation function 
maven_setup(){
    dnf install maven -y &>> "$LOG_FILE"
    VALIDATE $? "installation of maven"

    mvn clean package &>> "$LOG_FILE"
    VALIDATE $? "mvn package cleaning"

    mv target/shipping-1.0.jar shipping.jar  &>> "$LOG_FILE"
    VALIDATE $? "moving of shipping of jar"

}

# python installation setup
python_setup(){

dnf install python3 gcc python3-devel -y &>> "$LOG_FILE"
VALIDATE $? "installing python "

pip3 install -r requirements.txt &>> "$LOG_FILE" 
VALIDATE $? "installing python requriement"

}