#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/diagnostic.log"

mkdir -p "$LOG_DIR"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Check threshold argument
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <threshold> [path]"
    log_message "Disk check failed: invalid number of arguments."
    exit 2
fi

threshold="$1"
path="${2:-/}"

# Threshold must be an integer from 1 to 100
if ! [[ "$threshold" =~ ^[0-9]+$ ]] || [ "$threshold" -lt 1 ] || [ "$threshold" -gt 100 ]; then
    echo "Error: threshold must be an integer from 1 to 100."
    log_message "Disk check failed: invalid threshold '$threshold'."
    exit 2
fi

# Check that path exists
if [ ! -e "$path" ]; then
    echo "Error: path does not exist: $path"
    log_message "Disk check failed: path does not exist '$path'."
    exit 2
fi

usage=$(df -P "$path" 2>/dev/null | awk 'NR==2 {gsub("%","",$5); print $5}')

if [ -z "$usage" ]; then
    echo "Error: unable to determine disk usage for $path"
    log_message "Disk check failed: unable to determine usage for '$path'."
    exit 2
fi

echo "Path: $path"
echo "Disk Usage: ${usage}%"
echo "Threshold: ${threshold}%"

log_message "Disk check performed on '$path': usage=${usage}%, threshold=${threshold}%."

if [ "$usage" -ge "$threshold" ]; then
    echo "WARNING: Disk usage has reached or exceeded the threshold."
    exit 1
else
    echo "OK: Disk usage is below the threshold."
    exit 0
fi