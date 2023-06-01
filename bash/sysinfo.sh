X#!/bin/bash

# Display the fully-qualified domain name (FQDN)
fqdn=$(hostname)
echo "Fully-Qualified Domain Name (FQDN): $fqdn"

# Display the operating system name and version
os_info=$(hostnamectl | grep "Operating System:")
echo "Operating System: $os_info"

# Display IP addresses (excluding those starting with 127)
ip_addresses=$(hostname -I | awk '{for(i=1;i<=NF;i++)if($i!~/^127\./)print $i}')
echo "IP Addresses: $ip_addresses"

# Display the available space in the root filesystem
root_space=$(df -h --output=avail / | awk 'NR==2')
echo "Root Filesystem Space Available: $root_space"

