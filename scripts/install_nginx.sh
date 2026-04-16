#!/bin/bash

# =====================================================
# Script Name: install_nginx.sh
# Description: Installs and configures Nginx on Amazon Linux
# Author: Anup Das
# =====================================================

set -e  # Exit immediately if a command fails

LOG_FILE="/var/log/install_nginx.log"

echo "========== NGINX INSTALLATION STARTED ==========" | tee -a $LOG_FILE

# Update system packages
echo "[INFO] Updating system packages..." | tee -a $LOG_FILE
sudo dnf update -y >> $LOG_FILE 2>&1

# Install Nginx
echo "[INFO] Installing Nginx..." | tee -a $LOG_FILE
sudo dnf install nginx -y >> $LOG_FILE 2>&1

# Start Nginx service
echo "[INFO] Starting Nginx service..." | tee -a $LOG_FILE
sudo systemctl start nginx

# Enable Nginx to start on boot
echo "[INFO] Enabling Nginx on boot..." | tee -a $LOG_FILE
sudo systemctl enable nginx

# Create a custom index page
echo "[INFO] Creating custom web page..." | tee -a $LOG_FILE
echo "<h1>Production Failure Lab 🚀</h1><p>Instance: $(hostname)</p>" | sudo tee /usr/share/nginx/html/index.html

# Verify Nginx status
echo "[INFO] Checking Nginx status..." | tee -a $LOG_FILE
sudo systemctl status nginx >> $LOG_FILE 2>&1

echo "========== NGINX INSTALLATION COMPLETED ==========" | tee -a $LOG_FILE
