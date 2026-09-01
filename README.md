# Assignment 1 — Linux, Bash & Networking Diagnostic Toolkit

## Overview

This project is a Linux diagnostic toolkit written in Bash.

It provides scripts for collecting system information, checking disk usage, and performing basic network diagnostics.

## Repository Structure

```text
assignment-1/
├── README.md
├── system-info.sh
├── disk-check.sh
├── network-check.sh
├── grade.sh
└── logs/
    └── .gitkeep
```

## Requirements

The scripts are designed to run in a Linux environment.

The following common Linux utilities may be used:

* Bash
* hostname
* date
* uname
* uptime
* lscpu
* free
* df
* getent
* ping
* ip
* nc (optional for TCP port testing)

## Installation

Clone the repository:

```bash
git clone <repository-url>
cd assignment-1
```

Make the scripts executable:

```bash
chmod +x *.sh
```

## Usage

### System Information

Run:

```bash
./system-info.sh
```

The script displays:

* Hostname
* Current user
* Date and time
* Operating system
* Kernel version
* System uptime
* CPU information
* Memory information
* Current working directory

System values are obtained from the Linux system at runtime.

### Disk Check

Usage:

```bash
./disk-check.sh <threshold> [path]
```

Example:

```bash
./disk-check.sh 80
```

Check a specific path:

```bash
./disk-check.sh 80 /home
```

The threshold must be an integer from 1 to 100.

Exit codes:

* `0` — disk usage is below the threshold
* `1` — disk usage has reached or exceeded the threshold
* `2` — invalid input or invalid path

### Network Check

Usage:

```bash
./network-check.sh <hostname-or-ip> [port]
```

Example:

```bash
./network-check.sh google.com
```

With a TCP port:

```bash
./network-check.sh google.com 443
```

The script:

* Validates the host argument
* Resolves the hostname/IP
* Performs a basic connectivity check
* Displays network interface information
* Tests TCP connectivity when a port is supplied

Valid TCP ports are 1–65535.

Invalid input returns a non-zero exit status without crashing the script.

## Logging

Diagnostic operations are logged under:

```text
logs/diagnostic.log
```

Log entries contain a timestamp and a description of the operation.

The `logs/.gitkeep` file keeps the logs directory in the Git repository.

Generated diagnostic logs are not required to be committed.

## Testing

Run Bash syntax checks:

```bash
bash -n system-info.sh
bash -n disk-check.sh
bash -n network-check.sh
```

Run the provided grader:

```bash
chmod +x grade.sh
./grade.sh
```

Manual examples:

```bash
./system-info.sh

./disk-check.sh 90
./disk-check.sh 90 /tmp
./disk-check.sh 0
./disk-check.sh 101

./network-check.sh google.com
./network-check.sh google.com 443
./network-check.sh google.com 0
./network-check.sh google.com 70000
```

## Assumptions

* The scripts are intended for Linux systems using Bash.
* Standard Linux utilities are expected to be available.
* The scripts do not depend on hardcoded hostnames, usernames, paths, IP addresses, or machine-specific values.
* Network connectivity tests depend on the availability of the target host and network.
* TCP port testing uses available Linux networking utilities.
* No passwords, tokens, private keys, or other secrets are required.

## Author

Assignment 1 — Linux, Bash & Networking
