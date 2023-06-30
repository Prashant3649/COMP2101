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


# System Information Report

# Check if the user has root privilege
if [[ $EUID -ne 0 ]]; then
  echo "This script requires root privilege. Please run it as root or with sudo."
  exit 1
fi

###############
# Functions   #
###############

# Function to get system description
get_system_description() {
  manufacturer=$(dmidecode -s system-manufacturer)
  model=$(dmidecode -s system-product-name)
  serial=$(dmidecode -s system-serial-number)

  echo "System Description:"
  echo "  Manufacturer: $manufacturer"
  echo "  Model: $model"
  echo "  Serial Number: $serial"
  echo
}

# Function to get CPU information
get_cpu_info() {
  cpu=$(lshw -class processor | awk '/product/ {print $2}')
  architecture=$(lshw -class processor | awk '/width/ {print $2}')
  cores=$(lscpu | awk '/^CPU\(s\):/ {print $2}')
  max_speed=$(lscpu | awk '/^CPU MHz:/ {printf "%.2f GHz\n", $3/1000}')
  caches=$(lscpu | awk '/^L[1-3] cache:/ {printf "%.2f MB\n", $3/1024}')

  echo "CPU Information:"
  echo "  CPU: $cpu"
  echo "  Architecture: $architecture"
  echo "  Core Count: $cores"
  echo "  Maximum Speed: $max_speed"
  echo "  Cache Sizes:"
  echo "    L1: $(lscpu | awk '/^L1d cache:/ {printf "%.2f MB\n", $3/1024}')"
  echo "    L2: $(lscpu | awk '/^L2 cache:/ {printf "%.2f MB\n", $3/1024}')"
  echo "    L3: $caches"
  echo
}

# Function to get operating system information
get_os_info() {
  distro=$(lsb_release -ds)
  version=$(lsb_release -rs)

  echo "Operating System Information:"
  echo "  Linux Distribution: $distro"
  echo "  Distro Version: $version"
  echo
}

###############
# Main        #
###############

# Execute functions and generate the system report

# Section: System Description
get_system_description

# Section: CPU Information
get_cpu_info

# Section: Operating System Information
get_os_info
