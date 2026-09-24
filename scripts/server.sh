*# Server Configurations
# Author: Chandrashekar CR

# Basic Hardware details
echo "=== ARCHITECTURE ===" && uname -m
echo -e "\n=== CPU CORES ===" && lscpu | grep -E "CPU\(s\):|Core\(s\) per socket|Socket\(s\)"
echo -e "\n=== RAM TOTAL ===" && free -h | grep "Mem:" | awk '{print $2}'
echo -e "\n=== DISKS & CAPACITY ===" && lsblk -d -o NAME,SIZE,MODEL
echo -e "\n=== FILESYSTEM TYPES ===" && df -Th | grep -E "^/dev"

# Operating System details
echo -e "\n=== OPERATING SYSTEM & DISTRO ===" && grep -E "^NAME=|^VERSION=" /etc/os-release
echo -e "\n=== KERNEL VERSION ===" && uname -r
echo -e "\n=== HOSTNAME ===" && hostname
echo -e "\n=== UPTIME ===" && uptime -p

# Network
echo -e "\n=== NETWORK ===" && ip -br a | grep "UP" | tr -s ' ' | cut -d ' ' -f1
echo -e "\n=== IP ROUTE ===" && ip -br a | grep "UP" | grep -Po '(?<=\s)\d{1,3}(\.\d{1,3}){3}'

echo -e "\n == PORTS ===" && ss -tuln | grep "LISTEN"

# Services
echo -e "\n=== SERVICES ENABLED ===" && systemctl list-unit-files --type=service --state=enabled
echo -e "\n=== SERVICES RUNNING ===" && systemctl list-units --type=service --state=running

# Storage
echo -e "\n=== STORAGE ===" && df -Th
