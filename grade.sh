# !/bin/bash

# Assignment 1 Grader
# Linux, Bash & Networking Diagnostic Toolkit

PASS=0
FAIL=0
TOTAL=0

pass() {
    echo "PASS: $1"
    PASS=$((PASS + 1))
    TOTAL=$((TOTAL + 1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
    TOTAL=$((TOTAL + 1))
}

echo "=============================================="
echo " Assignment 1 - Automated Grader"
echo "=============================================="
echo

# Required files
echo "Checking required files..."

for file in README.md .gitignore system-info.sh disk-check.sh network-check.sh grade.sh
 do
    if [ -f "$file" ]; then
        pass "$file exists"
    else
        fail "$file is missing"
    fi
done

if [ -d "logs" ]; then
    pass "logs directory exists"
else
    fail "logs directory is missing"
fi

if [ -f "logs/.gitkeep" ]; then
    pass "logs/.gitkeep exists"
else
    fail "logs/.gitkeep is missing"
fi

if [ -f ".gitignore" ]; then
    if grep -Eiq '(^|/)(logs(/|$)|.*diagnostic\.log.*)' .gitignore; then
        pass ".gitignore excludes log files"
    else
        fail ".gitignore does not exclude log files"
    fi
else
    fail ".gitignore is missing"
fi

echo

# Git repository checks
echo "Checking Git repository state..."

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    pass "Git repository is initialized"
else
    fail "Git repository is missing"
fi

if git log --oneline --all 2>/dev/null | grep -q .; then
    pass "Git history exists"
else
    fail "Git history is missing"
fi

if git branch --all 2>/dev/null | grep -Eq 'feature/network-improvements|main|master'; then
    pass "Git branch information is present"
else
    fail "Git branch information is missing"
fi

echo

# Executable permissions
echo "Checking executable permissions..."

for file in system-info.sh disk-check.sh network-check.sh grade.sh
do
    if [ -f "$file" ]; then
        if [ -x "$file" ]; then
            pass "$file is executable"
        else
            fail "$file is not executable"
        fi
    fi
done

echo

# Bash syntax
echo "Checking Bash syntax..."

for file in system-info.sh disk-check.sh network-check.sh
do
    if [ -f "$file" ]; then
        if bash -n "$file" 2>/dev/null; then
            pass "$file has valid Bash syntax"
        else
            fail "$file has Bash syntax errors"
        fi
    fi
done

echo

# system-info.sh
echo "Testing system-info.sh..."

if [ -x "./system-info.sh" ]; then
    output=$(./system-info.sh 2>&1)
    rc=$?

    if [ "$rc" -eq 0 ]; then
        pass "system-info.sh executes successfully"
    else
        fail "system-info.sh returned exit code $rc"
    fi

    if echo "$output" | grep -qi "hostname"; then
        pass "system-info.sh displays hostname"
    else
        fail "system-info.sh does not display hostname"
    fi

    if echo "$output" | grep -qi "current user\|user"; then
        pass "system-info.sh displays user information"
    else
        fail "system-info.sh does not display user information"
    fi

    if echo "$output" | grep -Eqi "date|time"; then
        pass "system-info.sh displays date/time information"
    else
        fail "system-info.sh does not display date/time information"
    fi

    if echo "$output" | grep -Eqi "kernel|operating system"; then
        pass "system-info.sh displays kernel information"
    else
        fail "system-info.sh does not display kernel information"
    fi

    if echo "$output" | grep -qi "uptime"; then
        pass "system-info.sh displays uptime"
    else
        fail "system-info.sh does not display uptime"
    fi

    if echo "$output" | grep -Eqi "cpu|cores"; then
        pass "system-info.sh displays CPU information"
    else
        fail "system-info.sh does not display CPU information"
    fi

    if echo "$output" | grep -Eqi "memory|free memory|used memory"; then
        pass "system-info.sh displays memory information"
    else
        fail "system-info.sh does not display memory information"
    fi
else
    fail "system-info.sh is not executable"
fi

echo

# disk-check.sh
echo "Testing disk-check.sh..."

if [ -x "./disk-check.sh" ]; then
    ./disk-check.sh 90 /tmp >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 0 ] || [ "$rc" -eq 1 ]; then
        pass "disk-check.sh accepts valid threshold"
    else
        fail "disk-check.sh rejected valid threshold"
    fi

    ./disk-check.sh 0 >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 2 ]; then
        pass "disk-check.sh rejects threshold 0"
    else
        fail "disk-check.sh should return 2 for threshold 0"
    fi

    ./disk-check.sh 101 >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 2 ]; then
        pass "disk-check.sh rejects threshold 101"
    else
        fail "disk-check.sh should return 2 for threshold 101"
    fi

    ./disk-check.sh abc >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 2 ]; then
        pass "disk-check.sh rejects non-numeric threshold"
    else
        fail "disk-check.sh should return 2 for non-numeric threshold"
    fi

    ./disk-check.sh 90 /path/does/not/exist >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 2 ]; then
        pass "disk-check.sh rejects invalid path"
    else
        fail "disk-check.sh should return 2 for invalid path"
    fi
else
    fail "disk-check.sh is not executable"
fi

echo

# network-check.sh
echo "Testing network-check.sh..."

if [ -x "./network-check.sh" ]; then
    ./network-check.sh localhost >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 0 ] || [ "$rc" -eq 1 ]; then
        pass "network-check.sh accepts hostname"
    else
        fail "network-check.sh failed hostname test"
    fi

    ./network-check.sh localhost 80 >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 0 ] || [ "$rc" -eq 1 ]; then
        pass "network-check.sh accepts valid port"
    else
        fail "network-check.sh rejected valid port"
    fi

    ./network-check.sh localhost 0 >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 2 ]; then
        pass "network-check.sh rejects port 0"
    else
        fail "network-check.sh should return 2 for port 0"
    fi

    ./network-check.sh localhost 70000 >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 2 ]; then
        pass "network-check.sh rejects port 70000"
    else
        fail "network-check.sh should return 2 for port 70000"
    fi

    ./network-check.sh localhost abc >/dev/null 2>&1
    rc=$?

    if [ "$rc" -eq 2 ]; then
        pass "network-check.sh rejects non-numeric port"
    else
        fail "network-check.sh should return 2 for non-numeric port"
    fi
else
    fail "network-check.sh is not executable"
fi

echo

# Logging
echo "Checking logging..."

if [ -d "logs" ]; then
    ./disk-check.sh 90 /tmp >/dev/null 2>&1

    if [ -f "logs/diagnostic.log" ]; then
        pass "diagnostic.log is created"
    else
        fail "diagnostic.log was not created"
    fi
else
    fail "logs directory is missing"
fi

echo

# Summary
echo "=============================================="
echo " GRADING SUMMARY"
echo "=============================================="
echo "Tests passed : $PASS"
echo "Tests failed : $FAIL"
echo "Total tests  : $TOTAL"
echo

if [ "$FAIL" -eq 0 ]; then
    echo "RESULT: PASS"
    exit 0
else
    echo "RESULT: FAIL"
    exit 1
fi
