# Assignment 1 — Linux, Bash & Networking Diagnostic Toolkit

## Overview

This project is a Linux-based diagnostic toolkit developed as part of Assignment 1.

The toolkit contains Bash scripts for collecting system information, monitoring disk usage, and performing basic network diagnostics. The scripts are designed to run on standard Linux environments without relying on hardcoded machine-specific values.

## Project Structure

```text
assignment-1/
├── README.md
├── system-info.sh
├── disk-check.sh
├── network-check.sh
├── grade.sh
├── .gitignore
└── logs/
    └── .gitkeep
```

## Requirements

The project requires:

* Linux or a Linux-compatible environment
* Bash
* Standard Linux utilities
* Git

The network diagnostic script may use the following utilities when available:

* `getent`
* `ping`
* `ip`
* `nc`
* `timeout`

The scripts are designed to handle unavailable optional utilities without crashing.

## Installation

Clone the repository:

```bash
git clone <your-repository-url>
cd assignment-1
```

Make the scripts executable:

```bash
chmod +x system-info.sh disk-check.sh network-check.sh grade.sh
```

## Usage

### 1. System Information

Run:

```bash
./system-info.sh
```

The script displays:

* Hostname
* Current user
* Current date and time
* Operating system
* Kernel version
* System uptime
* CPU information
* Number of CPU cores
* Memory usage
* Current working directory

Example:

```text
========================================
        SYSTEM INFORMATION
========================================
Hostname:              my-computer
Current User:          kayode
Date/Time:             Mon Sep 1 18:30:00 WAT 2026
Operating System:      Ubuntu 24.04.1 LTS
Kernel Version:        5.10.16.3-microsoft-standard-WSL2
Uptime:                up 2 hours, 15 minutes
CPU Information:       Intel(R) Core(TM) Processor
CPU Cores:             8
Memory Information:    2.1Gi used / 7.7Gi total
Current Directory:     /home/kayode/assignment-1
========================================
```

All displayed values are obtained at runtime.

---

### 2. Disk Usage Check

Run:

```bash
./disk-check.sh <threshold>
```

The default path is `/`.

Example:

```bash
./disk-check.sh 80
```

To check a specific path:

```bash
./disk-check.sh 80 /home
```

The script displays:

* Path being checked
* Current disk usage
* Configured threshold
* Whether the usage is below or at/above the threshold

Example:

```text
Path: /
Disk Usage: 65%
Threshold: 80%
OK: Disk usage is below the threshold.
```

If disk usage reaches or exceeds the threshold:

```text
Path: /
Disk Usage: 85%
Threshold: 80%
WARNING: Disk usage has reached or exceeded the threshold.
```

#### Exit Codes

| Exit Code | Meaning                                          |
| --------- | ------------------------------------------------ |
| `0`       | Disk usage is below the threshold                |
| `1`       | Disk usage has reached or exceeded the threshold |
| `2`       | Invalid input or unable to perform the check     |

The threshold must be an integer between `1` and `100`.

---

### 3. Network Check

Run:

```bash
./network-check.sh <hostname-or-ip>
```

Example:

```bash
./network-check.sh google.com
```

The script performs:

* Host validation
* Hostname/IP resolution
* Basic connectivity testing
* Network interface information display
* Diagnostic logging

Example:

```text
========================================
          NETWORK CHECK
========================================
Host: google.com
Resolved Address: 142.250.x.x

Connectivity Check:
Status: SUCCESS

Network Interfaces:
...
========================================
```

#### TCP Port Testing

An optional TCP port can be supplied:

```bash
./network-check.sh google.com 443
```

The script validates that the port is between `1` and `65535` and attempts a TCP connectivity test.

Example:

```text
TCP Port Check
Host: google.com
Port: 443
TCP Connectivity: SUCCESS
```

Invalid input is handled without causing the script to crash.

---

## Testing

Each script can be tested manually.

### Test System Information

```bash
./system-info.sh
```

### Test Disk Usage

```bash
./disk-check.sh 80
```

Test a specific path:

```bash
./disk-check.sh 80 /
```

Test invalid threshold:

```bash
./disk-check.sh 0
```

The script should reject the invalid threshold.

### Test Network Connectivity

```bash
./network-check.sh google.com
```

Test TCP connectivity:

```bash
./network-check.sh google.com 443
```

Test invalid port:

```bash
./network-check.sh google.com 70000
```

Test invalid hostname:

```bash
./network-check.sh "invalid host!"
```

### Run the Assignment Grader

Make the grader executable:

```bash
chmod +x grade.sh
```

Run:

```bash
./grade.sh
```

The grader checks the required project structure, Bash syntax, executable permissions, script behaviour, logging, and Git history.

---

## Logging

The diagnostic scripts create useful runtime logs under:

```text
logs/diagnostic.log
```

Log entries include a timestamp and a description of the operation performed.

Example:

```text
[2026-09-01 18:30:00] System information collected.
[2026-09-01 18:31:15] Disk check performed on '/': usage=65%, threshold=80%.
[2026-09-01 18:32:10] Starting network check for 'google.com'.
```

Generated `.log` files are excluded from Git using `.gitignore`.

The repository contains:

```text
logs/.gitkeep
```

so that the `logs` directory remains part of the project structure.

---

## Git Workflow

The project uses Git for version control.

Development includes a feature branch:

```text
feature/network-improvements
```

The feature branch is used for network diagnostic improvements before being merged into the main development branch.

The repository maintains meaningful commits documenting the development process.

View the commit history with:

```bash
git log --oneline --graph --all
```

View available branches with:

```bash
git branch -a
```

---

## Assumptions

* The scripts are intended to run in a Linux or Linux-compatible environment.
* Bash is available on the system.
* Standard Linux utilities such as `df`, `awk`, `grep`, `date`, `uname`, and `free` are available.
* Some networking utilities such as `ping`, `nc`, or `ip` may not be installed. The network script handles missing optional utilities where possible.
* Internet connectivity is required for meaningful external hostname and connectivity tests.
* No passwords, API keys, tokens, private keys, or other secrets are stored in the repository.
* No machine-specific paths or hardcoded IP addresses are required.

## Compatibility

The scripts are designed to avoid hardcoded hostnames, IP addresses, usernames, directories, or other machine-specific values.

Runtime information is collected dynamically from the operating system.

## Author

**Dada Oluwakayode Joseph**

Assignment 1 — Linux, Bash & Networking
