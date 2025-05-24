#!/bin/bash

#importing the function varabiles and all other stuff
source ./common_script.sh

#assiging server for installation
service_name="payment"

# Color codes
color

# Root privilege check
check_root

# logfile folder setup
logfile_setup

# Application setup
app_setup

# python installation
python_setup

# Systemd Service setup
systemd_setup