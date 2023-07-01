#!/bin/bash

# This script displays system information

################
# Functions
################

# This function sends an error message to stderr
# Usage:
#   error-message ["some text to print to stderr"]
function error-message {
  echo "$1" >&2
}

# This function sends a message to stderr and exits with a failure status
# Usage:
#   error-exit ["some text to print to stderr" [exit-status]]
function error-exit {
  local message="${1:-Unknown error}"
  local exit_status="${2:-1}"
  error-message "$message"
  exit "$exit_status"
}

# This function displays help information if the user asks for it on the command line or gives unsupported options
function displayhelp {
  echo "Usage: $0 [options]"
  echo "Options:"
  echo "  --host       Display hostname"
  echo "  --domain     Display domain name"
  echo "  --ipconfig   Display IP configuration"
  echo "  --os         Display operating system information"
  echo "  --cpu        Display CPU information"
  echo "  --memory     Display RAM information"
  echo "  --disk       Display disk storage information"
  echo "  --printer    Display printer information"
}

# This function removes all the temporary files created by the script
function cleanup {
  rm -f /tmp/sysinfo.* /tmp/sysreport.*
}

# Trap command to attach the cleanup function to the EXIT signal
trap cleanup EXIT

################
# Command Line Options
################

# Process command line options
partialreport=
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      displayhelp
      error-exit
      ;;
    --host)
      hostnamewanted=true
      partialreport=true
      ;;
    --domain)
      domainnamewanted=true
      partialreport=true
      ;;
    --ipconfig)
      ipinfowanted=true
      partialreport=true
      ;;
    --os)
      osinfowanted=true
      partialreport=true
      ;;
    --cpu)
      cpuinfowanted=true
      partialreport=true
      ;;
    --memory)
      memoryinfowanted=true
      partialreport=true
      ;;
    --disk)
      diskinfowanted=true
      partialreport=true
      ;;
    --printer)
      printerinfowanted=true
      partialreport=true
      ;;
    *)
      error-exit "$1 is invalid"
      ;;
  esac
  shift
done

################
# System Information
################

# Gather data into temporary files to reduce time spent running lshw
sudo lshw -class system >/tmp/sysinfo.$$ 2>/dev/null
sudo lshw -class memory >/tmp/memoryinfo.$$ 2>/dev/null
sudo lshw -class bus >/tmp/businfo.$$ 2>/dev/null
sudo lshw -class cpu >/tmp/cpuinfo.$$ 2>/dev/null

# Extract the specific data items into variables
systemproduct=$(sed -n '/product:/s/ *product: //p' /tmp/sysinfo.$$)
systemwidth=$(sed -n '/width:/s/ *width: //p' /tmp/sysinfo.$$)
systemmotherboard=$(sed -n '/product:/s/ *product: //p' /tmp/businfo.$$ | head -1)
systembiosvendor=$(sed -n '/vendor:/s/ *vendor: //p' /tmp/memoryinfo.$$ | head -1)
systembiosversion=$(sed -n '/version:/s/ *version: //p' /
