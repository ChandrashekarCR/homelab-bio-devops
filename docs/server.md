# Task 1 — Infrastructure assessment

## Objective

Produce an Infrastructure Inventory.

### Hardware
 - CPU: 4
 - number of physical cores: 2 threads per core;2 cores per socket;1 socket
 - number of logical CPUs:
 - RAM: 3.6G approx 4G RAM
 - disks: sda
 - disk capacity: 465G
 - filesystem: ext4
 - architecture: x86_64


### Operating system
 - distribution: Ubuntu
 - version: 22.04 LTS
 - kernel version: 5.15.0-191-generic
 - hostname: nilayam
 - uptime: up 4 days, 17 hours, 27 minutes as of 24th September 2026

### Network
 - network interfaces: enp3s0 (Ethernet)
 - local IP address: XXX.XXX.0.8
 - default gateway: XXX.XXX.0.1
 - DNS configuration: XXX.XXX.0.1
 - whether the machine has a static or dynamic LAN address: It uses dynamic LAN address. But we need to change it to a static one. "proto dhcp" indicates that it was dynamic.
 - which ports are currently listening:
  * **Port 22:** SSH (Remote Access)
  * **Port 53:** Local DNS Resolver (`systemd-resolved`)
  * **Port 139 / 445:** Samba (SMB File Sharing)
  * **Port 8787:** Web Service / Bio-DevOps Application (e.g., RStudio Server)

### Services
 - which services start automatically
 - which services are currently running
 - which ports they use

### Storage
 - available space
 - filesystem usage
 - mounted filesystems
 - where application data could eventually live
