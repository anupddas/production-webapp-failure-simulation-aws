#!/bin/bash

# ==========================================
# AWS Production Failure Lab
# Launch Template User Data Script
# Purpose: Automatically configure EC2 instance
# ==========================================

# Update system packages
echo "Updating system packages..."
dnf update -y

# Install Nginx web server
echo "Installing Nginx..."
dnf install nginx -y

# Start Nginx service
echo "Starting Nginx..."
systemctl start nginx

# Enable Nginx to start on boot
echo "Enabling Nginx on boot..."
systemctl enable nginx

# Create a simple dynamic webpage
echo "Configuring web page..."
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Anup Welcomes You</title>
</head>
<body style="text-align:center; font-family:Arial;">
    <h1>Production Failure Lab</h1>
    <p>Server is running successfully!</p>
    <p>To contact Anup, write a quick mail to <a href="mailto:anupddas8@gmail.com">anupddas8@gmail.com</a></p>
    <i>Thank you for your time!</i>
</body>
</html>
EOF

# Set proper permissions
chmod 644 /usr/share/nginx/html/index.html

# Restart Nginx to apply changes
echo "Restarting Nginx..."
systemctl restart nginx

# Log completion
echo "User data script execution completed successfully." > /var/log/user-data.log
