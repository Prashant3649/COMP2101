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


# This script displays system information for a Linux machine

################
# Check Privilege
################

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with root privilege." >&2
  exit 1
fi

################
# System Description
################

system_title="System Description"

# Computer Manufacturer
manufacturer=$(dmidecode -s system-manufacturer)
[[ -n $manufacturer ]] && system_description="Computer Manufacturer: $manufacturer"

# Computer Model
model=$(dmidecode -s system-product-name)
[[ -n $model ]] && system_description+="\nComputer Model: $model"

# Computer Serial Number
serial_number=$(dmidecode -s system-serial-number)
[[ -n $serial_number ]] && system_description+="\nComputer Serial Number: $serial_number"

[[ -n $system_description ]] || system_description="Data for this section is unavailable."

################
# CPU Information
################

cpu_title="CPU Information"

# Get CPU information from lshw command
cpu_info=$(lshw -class processor 2>/dev/null)

# Check if CPU information is available
if [[ -n $cpu_info ]]; then
  # Extract CPU details for each CPU
  cpu_count=$(grep -c "product" <<< "$cpu_info")
  cpu_details=""
  
  for ((i=1; i<=cpu_count; i++)); do
    cpu=$(grep -A 11 "product:$i" <<< "$cpu_info")
    
    # CPU Manufacturer and Model
    manufacturer=$(grep "vendor" <<< "$cpu" | awk -F': ' '{print $2}')
    model=$(grep "product" <<< "$cpu" | awk -F': ' '{print $2}')
    
    # CPU Architecture
    architecture=$(grep "width" <<< "$cpu" | awk -F': ' '{print $2}')
    
    # CPU Core Count
    core_count=$(grep "cores" <<< "$cpu" | awk -F': ' '{print $2}')
    
    # CPU Maximum Speed
    max_speed=$(grep "capacity" <<< "$cpu" | awk -F': ' '{print $2}')
    
    # CPU Caches
    caches=$(grep "size" <<< "$cpu" | awk -F': ' '{print $2}' | paste -sd '/')
    
    cpu_details+="CPU $i:\n"
    [[ -n $manufacturer ]] && cpu_details+="Manufacturer: $manufacturer\n"
    [[ -n $model ]] && cpu_details+="Model: $model\n"
    [[ -n $architecture ]] && cpu_details+="Architecture: $architecture\n"
    [[ -n $core_count ]] && cpu_details+="Core Count: $core_count\n"
    [[ -n $max_speed ]] && cpu_details+="Maximum Speed: $max_speed\n"
    [[ -n $caches ]] && cpu_details+="Caches: $caches\n"
    
    cpu_details+="\n"
  done
else
  cpu_details="Data for this section is unavailable."
fi

################
# Operating System Information
################

os_title="Operating System Information"

# Linux Distro
linux_distro=$(lsb_release -is)
[[ -n $linux_distro ]] && os_info="Linux distro: $linux_distro"

# Distro Version
distro_version=$(lsb_release -rs)
[[
