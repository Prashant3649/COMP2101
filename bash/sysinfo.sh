#!/bin/bash

echo "Report for pc 200513649"


# Display the fully-qualified domain name (FQDN)
fqdn=$(hostname -f)
echo "Fully-Qualified Domain Name (FQDN): $fqdn"

# Display the operating system name and version
os_info=$(hostnamectl | awk -F: '/Operating System:/ {print $2}')
echo "Operating System: $os_info"

# Display IP addresses (excluding those starting with 127)
ip_addresses=$(hostname -I | awk '$1 !~ /^127/ {print $1}')
echo "IP Addresses: $ip_addresses"

# Display the available space in the root filesystem
root_space=$(df -h --output=avail / | awk 'NR==2')
echo "Root Filesystem Space Available: $root_space"

# Generate the report
report=$(printf "$output_template" \
    "System Information" \
    "------------------" \
    "Hostname:" "$hostname" \
    "Fully Qualified Domain Name:" "$fqdn" \
    "Operating System:" "$os_name $os_version" \
    "IP Address:" "$ip_address" \
    "Root Filesystem Space:" "$disk_space")

# Display the report
echo "$report"
