#!/bin/bash

# Function to log error message with a timestamp
function errormessage {
  local error_message="$1"
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  
  echo "[$timestamp] Error: $error_message" >> /var/log/systeminfo.log
  echo "Error: $error_message" >&2
}

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  errormessage "This script must be run as root."
  exit 1
fi

# Source the function library file
source ./bash/reportfunctions.sh

# Function to display script usage information
function display_help {
  echo "Usage: systeminfo.sh [OPTIONS]"
  echo "Options:"
  echo "  -h          Display this help message and exit"
  echo "  -v          Run the script verbosely, showing errors to the user"
  echo "  -system     Run only the computerreport, osreport, cpureport, ramreport, and videoreport"
  echo "  -disk       Run only the diskreport"
  echo "  -network    Run only the networkreport"
}

# Function to display full system report
function full_report {
  computerreport
  osreport
  cpureport
  ramreport
  videoreport
  diskreport
  networkreport
}

# Parse command line options
while getopts "hvsystemdisknetwork" opt; do
  case $opt in
    h)
      display_help
      exit 0
      ;;
    v)
      VERBOSE=true
      ;;
    system)
      computerreport
      osreport
      cpureport
      ramreport
      videoreport
      ;;
    disk)
      diskreport
      ;;
    network)
      networkreport
      ;;
    *)
      display_help
      exit 1
      ;;
  esac
done

# Run the script verbosely if the -v option is specified
if [[ $VERBOSE ]]; then
  full_report
else
  full_report >> /var/log/systeminfo.log 2>&1
fi
