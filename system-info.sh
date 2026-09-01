#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/diagnostic.log"

mkdir -p "$LOG_DIR"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

echo "========================================"
echo "        SYSTEM INFORMATION"
echo "========================================"

echo "Hostname:              $(hostname)"
echo "Current User:          $(whoami)"
echo "Date/Time:             $(date)"
echo "Operating System:      $(grep '^PRETTY_NAME=' /etc/os-release 2>/dev/null | cut -d= -f2- | tr -d '"')"
echo "Kernel Version:        $(uname -r)"
echo "Uptime:                $(uptime -p)"
echo "CPU Information:       $(lscpu 2>/dev/null | grep 'Model name:' | sed 's/^[[:space:]]*//' | cut -d: -f2- | xargs)"
echo "Memory Information:    $(free -h | awk '/^Mem:/ {print $3 " used / " $2 " total"}')"
echo "Current Directory:     $(pwd)"
echo "Total Memory:          $(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || echo "Unknown")"
echo "Used Memory:           $(free -h 2>/dev/null | awk '/^Mem:/ {print $3}' || echo "Unknown")"
echo "Free Memory:           $(free -h 2>/dev/null | awk '/^Mem:/ {print $4}' || echo "Unknown")"
echo "Available Memory:      $(free -h 2>/dev/null | awk '/^Mem:/ {print $7}' || echo "Unknown")"
echo "Swap Total:            $(free -h 2>/dev/null | awk '/^Swap:/ {print $2}' || echo "Unknown")"
echo "Swap Used:             $(free -h 2>/dev/null | awk '/^Swap:/ {print $3}' || echo "Unknown")"
echo "========================================"

log_message "System information collected."

exit 0