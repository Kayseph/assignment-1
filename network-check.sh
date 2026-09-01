```bash
#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/diagnostic.log"

# Create log directory if it does not exist
mkdir -p "$LOG_DIR"

# Logging function
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Display usage information
usage() {
    echo "Usage: $0 <hostname-or-ip> [port]"
}

# Check argument count
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    echo "Error: Invalid number of arguments."
    usage
    log_message "Network check failed: invalid number of arguments."
    exit 2
fi

HOST="$1"
PORT="$2"

# Validate that the host is not empty
if [ -z "$HOST" ]; then
    echo "Error: Hostname or IP address cannot be empty."
    log_message "Network check failed: empty hostname/IP."
    exit 2
fi

# Validate hostname/IP characters
# Allows letters, numbers, dots, and hyphens.
if [[ ! "$HOST" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Error: Invalid hostname or IP address: $HOST"
    log_message "Network check failed: invalid host '$HOST'."
    exit 2
fi

# Validate port if supplied
if [ -n "$PORT" ]; then

    # Port must contain digits only
    if [[ ! "$PORT" =~ ^[0-9]+$ ]]; then
        echo "Error: Port must be an integer."
        log_message "Network check failed: non-numeric port '$PORT'."
        exit 2
    fi

    # Port must be between 1 and 65535
    if [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
        echo "Error: Port must be between 1 and 65535."
        log_message "Network check failed: port '$PORT' outside valid range."
        exit 2
    fi
fi

echo "========================================"
echo "          NETWORK CHECK"
echo "========================================"
echo "Host: $HOST"

log_message "Starting network check for '$HOST'."

# Resolve hostname/IP
RESOLVED_ADDRESS=$(getent ahosts "$HOST" 2>/dev/null | awk 'NR==1 {print $1}')

if [ -z "$RESOLVED_ADDRESS" ]; then
    echo "Error: Unable to resolve host '$HOST'."
    log_message "Network check failed: unable to resolve '$HOST'."
    exit 1
fi

echo "Resolved Address: $RESOLVED_ADDRESS"

log_message "Host '$HOST' resolved to '$RESOLVED_ADDRESS'."

# Basic connectivity check
echo
echo "Connectivity Check:"

if command -v ping >/dev/null 2>&1; then

    if ping -c 1 -W 2 "$HOST" >/dev/null 2>&1; then
        echo "Status: SUCCESS"
        log_message "Ping connectivity succeeded for '$HOST'."
    else
        echo "Status: FAILED"
        log_message "Ping connectivity failed for '$HOST'."
    fi

else
    echo "Ping command is not available."
    log_message "Ping command is not available."
fi

# Display network interface information
echo
echo "Network Interfaces:"

if command -v ip >/dev/null 2>&1; then
    ip -brief address
    log_message "Network interface information collected."
else
    echo "The 'ip' command is not available."
    log_message "Network interface information unavailable: ip command missing."
fi

# TCP port check
if [ -n "$PORT" ]; then

    echo
    echo "TCP Port Check"
    echo "Host: $HOST"
    echo "Port: $PORT"

    if command -v nc >/dev/null 2>&1; then

        if nc -z -w 3 "$HOST" "$PORT" >/dev/null 2>&1; then
            echo "TCP Connectivity: SUCCESS"
            log_message "TCP connection succeeded for '$HOST:$PORT'."
        else
            echo "TCP Connectivity: FAILED"
            log_message "TCP connection failed for '$HOST:$PORT'."
        fi

    elif command -v timeout >/dev/null 2>&1; then

        if timeout 3 bash -c "</dev/tcp/$HOST/$PORT" >/dev/null 2>&1; then
            echo "TCP Connectivity: SUCCESS"
            log_message "TCP connection succeeded for '$HOST:$PORT'."
        else
            echo "TCP Connectivity: FAILED"
            log_message "TCP connection failed for '$HOST:$PORT'."
        fi

    else
        echo "TCP Connectivity: Unable to perform check."
        echo "Reason: Neither nc nor timeout is available."
        log_message "TCP connectivity could not be tested for '$HOST:$PORT'."
    fi
fi

echo "========================================"

log_message "Network check completed for '$HOST'."

exit 0
```
