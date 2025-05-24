#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="user"

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
