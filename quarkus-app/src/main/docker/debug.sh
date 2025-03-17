#!/bin/bash
# Comprehensive system information script for Docker containers
echo "======================================"
echo "Docker Container System Information"
echo "======================================"
echo "Date: $(date)"
echo

# Container info
echo "--- Container Information ---"
echo "Hostname: $(hostname)"
if [ -f "/.dockerenv" ]; then
    echo "Running inside Docker: Yes"
else
    echo "Running inside Docker: No (Warning: This script is designed for Docker containers)"
fi

# Check if we can get container ID
if [ -f "/proc/self/cgroup" ]; then
    CONTAINER_ID=$(grep -o -E '[0-9a-f]{64}' /proc/self/cgroup | head -n 1)
    if [ -n "$CONTAINER_ID" ]; then
        echo "Container ID: ${CONTAINER_ID:0:12}"
    else
        echo "Container ID: Not found"
    fi
else
    echo "Container ID: Information not available"
fi
echo

# OS Information
echo "--- OS Information ---"
if [ -f "/etc/os-release" ]; then
    echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')"
else
    echo "OS: Unknown"
fi
echo "All: $(uname -a)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo

# Resource Allocation and Usage
echo "--- CPU Information ---"
echo "CPU cores allocated: $(grep -c processor /proc/cpuinfo)"
echo "CPU model: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2 | sed 's/^[ \t]*//')"
echo "CPU usage:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
echo

echo "--- Memory Information ---"
echo "Total memory: $(free -h | grep Mem | awk '{print $2}')"
echo "Used memory: $(free -h | grep Mem | awk '{print $3}')"
echo "Free memory: $(free -h | grep Mem | awk '{print $4}')"
echo "Memory usage summary:"
free -h
echo

echo "--- Disk Information ---"
echo "Filesystem usage:"
df -h
echo

# Network information
echo "--- Network Information ---"
echo "IP Addresses:"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' || echo "ip command not available"
echo "Network interfaces:"
ip link show | grep -E '^[0-9]+:' | awk -F': ' '{print $2}' || echo "ip command not available"
echo "Open ports:"
netstat -tulpn 2>/dev/null || ss -tulpn 2>/dev/null || echo "Neither netstat nor ss command available"
echo "Network connectivity test:"
ping -c 1 -W 1 8.8.8.8 >/dev/null 2>&1 && echo "Internet: Connected" || echo "Internet: Disconnected"
echo

# Process information
echo "--- Process Information ---"
echo "Top 5 processes by CPU usage:"
ps aux --sort=-%cpu | head -6
echo
echo "Top 5 processes by memory usage:"
ps aux --sort=-%mem | head -6
echo
echo "Total running processes: $(ps aux | wc -l)"
echo

# Installed packages
echo "--- Installed Packages ---"
if command -v dpkg >/dev/null 2>&1; then
    echo "Debian-based system detected"
    echo "Total packages installed: $(dpkg -l | grep -c '^ii')"
    echo "Top 10 largest packages:"
    dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -10
elif command -v rpm >/dev/null 2>&1; then
    echo "RPM-based system detected"
    echo "Total packages installed: $(rpm -qa | wc -l)"
    echo "Top 10 largest packages:"
    rpm -qa --queryformat '%{size} %{name}-%{version}\n' | sort -n | tail -10
elif command -v apk >/dev/null 2>&1; then
    echo "Alpine Linux detected"
    echo "Total packages installed: $(apk info | wc -l)"
    echo "Package list:"
    apk info
else
    echo "Unknown package manager"
fi
echo

# Environment variables
echo "--- Environment Variables ---"
echo "Total environment variables: $(env | wc -l)"
echo "Selected environment variables (sensitive info redacted):"
env | grep -v -E 'KEY|SECRET|PASS|TOKEN|PWD' | sort
echo

# Docker-specific information (if available)
echo "--- Docker-specific Information ---"
if command -v mount >/dev/null 2>&1; then
    echo "Mounted volumes:"
    mount | grep -E 'overlay|/var/lib/docker'
fi

if [ -f /proc/self/cgroup ]; then
    echo "Control groups:"
    cat /proc/self/cgroup
fi
echo

# Java Version
echo "--- Java Version ---"
echo "java -version: $(java -version)"
echo

# Binary information
echo "--- Binary Version ---"
echo "ls /work: $(ls -l /work)"
echo "file /work/application: $(file /work/application)"
echo

# GLIBC version
echo "--- GLIBC Version ---"
echo "ldd --version: $(ldd --version)"
echo

echo "======================================"
echo "End of System Information Report"
echo "======================================"
