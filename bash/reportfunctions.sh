#!/bin/bash

# Function to display a title
function title {
  local title_text="$1"
  echo "=== $title_text ==="
}

# Function to format sizes in a human-friendly format
function format_size {
  local size_in_bytes=$1
  local units=("B" "KB" "MB" "GB" "TB")
  local unit_index=0

  while ((size_in_bytes > 1024)) && ((unit_index < ${#units[@]}-1)); do
    size_in_bytes=$((size_in_bytes / 1024))
    unit_index=$((unit_index + 1))
  done

  echo "$size_in_bytes ${units[unit_index]}"
}

# Function to format speeds in a human-friendly format
function format_speed {
  local speed_in_hertz=$1
  local units=("Hz" "kHz" "MHz" "GHz")
  local unit_index=0

  while ((speed_in_hertz > 1000)) && ((unit_index < ${#units[@]}-1)); do
    speed_in_hertz=$((speed_in_hertz / 1000))
    unit_index=$((unit_index + 1))
  done

  echo "$speed_in_hertz ${units[unit_index]}"
}

# Function to display CPU information
function cpureport {
  title "CPU Report"

  local cpu_manufacturer=$(lscpu | awk '/Vendor ID:/ { print $3 }')
  local cpu_model=$(lscpu | awk '/Model name:/ { $1=""; $2=""; print $0 }')
  local cpu_architecture=$(lscpu | awk '/Architecture:/ { print $2 }')
  local cpu_core_count=$(lscpu | awk '/^CPU\(s\):/ { print $2 }')
  local cpu_max_speed=$(lscpu | awk '/^CPU max MHz:/ { print $4 }')

  echo "CPU manufacturer and model: $cpu_manufacturer $cpu_model"
  echo "CPU architecture: $cpu_architecture"
  echo "CPU core count: $cpu_core_count"
  echo "CPU maximum speed: $(format_speed $cpu_max_speed)"

  local cache_info=$(lscpu | awk '/^L[1-3] cache:/ { sub(/^[[:space:]]+/, ""); print }')
  echo "Cache sizes:"
  echo "$cache_info"
}

# Function to display computer information
function computerreport {
  title "Computer Report"

  local manufacturer=$(dmidecode -s system-manufacturer)
  local model=$(dmidecode -s system-product-name)
  local serial_number=$(dmidecode -s system-serial-number)

  echo "Computer manufacturer: $manufacturer"
  echo "Computer model: $model"
  echo "Computer serial number: $serial_number"
}

# Function to display operating system information
function osreport {
  title "OS Report"

  local distro=$(lsb_release -d -s)
  local version=$(lsb_release -r -s)

  echo "Linux distro: $distro"
  echo "Distro version: $version"
}

# Function to display RAM information
function ramreport {
  title "RAM Report"

  echo "Installed memory components:"
  echo "Component manufacturer | Component model | Component size | Component speed | Component location"

  local total_ram_size=0

  while read -r line; do
    local component=$(echo "$line" | awk '{print $2}')
    local manufacturer=$(echo "$line" | awk '{print $3}')
    local model=$(echo "$line
