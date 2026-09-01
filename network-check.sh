#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/diagnostic.log"

mkdir -p "$LOG_DIR"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Validate number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Usage: $0 <hostname-or-ip> [port]"
    log_message "Network check failed: invalid number of arguments."
    exit 2
fi

host="$1"
port="$2"

# Validate host
if [ -z "$host" ]; then
    echo "Error: hostname or IP address cannot be empty."
    log_message "Network check failed: empty host."
    exit 2
fi

# Validate port if supplied
if [ -n "$port" ]; then
    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
        echo "Error: port must be an integer from 1 to 65535."
        log_message "Network check failed: invalid port '$port'."
        exit 2
    fi
fi

echo "========================================"
echo "          NETWORK CHECK"
echo "========================================"
echo "Host: $host"

# Resolve host
resolved_address=$(getent ahosts "$host" 2>/dev/null | awk 'NR==1 {print $1}')

if [ -z "$resolved_address" ]; then
    echo "Error: unable to resolve host '$host'."
    log_message "Network check failed: unable to resolve '$host'."
    exit 1
fi

echo "Resolved Address: $resolved_address"

# Basic connectivity check
if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
    echo "Connectivity: SUCCESS"
    log_message "Connectivity check succeeded for '$host'."
else
    echo "Connectivity: FAILED"
    log_message "Connectivity check failed for '$host'."
fi

# Network interfaces
echo
echo "Network Interfaces:"
if command -v ip >/dev/null 2>&1; then
    ip -brief address
else
    echo "ip command is not available."
fi

# TCP port check
if [ -n "$port" ]; then
    echo
    echo "TCP Port: $port"

    if command -v nc >/dev/null 2>&1; then
        if nc -z -w 3 "$host" "$port" >/dev/null 2>&1; then
            echo "TCP Connectivity: SUCCESS"
            log_message "TCP connectivity succeeded for '$host:$port'."
        else
            echo "TCP Connectivity: FAILED"
            log_message "TCP connectivity failed for '$host:$port'."
        fi
    elif command -v timeout >/dev/null 2>&1 && command -v bash >/dev/null 2>&1; then
        if timeout 3 bash -c "</dev/tcp/$host/$port" >/dev/null 2>&1; then
            echo "TCP Connectivity: SUCCESS"
            log_message "TCP connectivity succeeded for '$host:$port'."
        else
            echo "TCP Connectivity: FAILED"
            log_message "TCP connectivity failed for '$host:$port'."
        fi
    else
        echo "TCP Connectivity: Unable to perform check (nc/timeout unavailable)."
        log_message "TCP connectivity could not be tested for '$host:$port'."
    fi
fi

echo "========================================"

log_message "Network check completed for '$host'."

exit 0