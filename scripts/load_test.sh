#!/bin/bash

# =====================================================
# Script Name: load_test.sh
# Description: Simulates CPU load for testing CloudWatch alarms
# Author: Anup Das
# =====================================================

DURATION=${1:-60}     # Default: 60 seconds
LOAD_CORES=${2:-1}   # Default: 1 CPU core
LOG_FILE="/home/ec2-user/load_test.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log() {
    echo "[$TIMESTAMP] $1" | tee -a $LOG_FILE
}

log "Starting CPU load test | Duration: ${DURATION}s | Cores: ${LOAD_CORES}"

# Function to generate CPU load
generate_load() {
    while true; do :; done
}

PIDS=()

# Start load processes
for ((i=0; i<LOAD_CORES; i++))
do
    generate_load &
    PIDS+=($!)
done

log "Load processes started: ${PIDS[*]}"

# Run for specified duration
sleep $DURATION

# Stop all load processes
log "Stopping load processes..."

for PID in "${PIDS[@]}"
do
    kill -9 $PID 2>/dev/null
done

log "CPU load test completed successfully."

exit 0
