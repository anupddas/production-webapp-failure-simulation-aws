#!/bin/bash

# =====================================================
# Script Name: health_check.sh
# Description: Checks Nginx health and auto-recovers if down
# Author: Anup Das
# =====================================================

LOG_FILE="/home/ec2-user/health.log"
URL="http://localhost"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Function: Log messages
log() {
    echo "[$TIMESTAMP] $1" | tee -a $LOG_FILE
}

log "Starting health check..."

# Check HTTP response (with timeout)
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 $URL)

# Validate response
if [ "$HTTP_CODE" == "200" ]; then
    log "Nginx is healthy (HTTP 200)"
    exit 0
else
    log "Nginx unhealthy! HTTP status: $HTTP_CODE"

    # Attempt restart
    log "Attempting to restart Nginx..."
    sudo systemctl restart nginx

    sleep 3

    # Re-check after restart
    HTTP_CODE_RECHECK=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 $URL)

    if [ "$HTTP_CODE_RECHECK" == "200" ]; then
        log "Recovery successful. Nginx restarted."
        exit 0
    else
        log "Recovery failed! Manual intervention required."
        exit 1
    fi
fi
