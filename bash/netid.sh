#!/bin/bash
#
# This script displays host identification information for a Linux machine
#
# Sample output:
#   Hostname      : zubu
#   LAN Address   : 192.168.2.2
#   LAN Name      : net2-linux
#   External IP   : 1.2.3.4
#   External Name : some.name.from.our.isp

# the LAN info in this script uses a hardcoded interface name of "eno1"
#    - change eno1 to whatever interface you have and want to gather info about in order to test the script

################
# Data Gathering
################
# the first part is run once to get information about the host
# grep is used to filter ip command output so we don't have extra junk in our output
# stream editing with sed and awk are used to extract only the data we want displayed

###############
# Functions   #
###############

# Function to display system identification summary
display_system_summary() {
  cat <<EOF

System Identification Summary
=============================
Hostname      : $my_hostname
Default Router: $default_router_address
Router Name   : $default_router_name
External IP   : $external_address
External Name : $external_name

EOF
}

# Function to display per-interface report
display_interface_report() {
  local interface=$1
  echo
  echo "Interface $interface:"
  echo "==============="
  echo "Address         : $ipv4_address"
  echo "Name            : $ipv4_hostname"
  echo "Network Address : $network_address"
  echo "Network Name    : $network_name"
  echo
}

###############
# Main        #
###############

# TASK 1: Accept options on the command line for verbose mode and an interface name
verbose="no"
interface=""

# Check command line options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v)
      verbose="yes"
      shift
      ;;
    *)
      interface="$1"
      shift
      ;;
  esac
done

# Check if the user specified an interface name
if [[ -n $interface ]]; then
  # Display information for the specified interface
  if [[ $interface != "lo" ]]; then
    # Gather information for the specified interface
    ipv4_address=$(ip a s $interface | awk -F '[/ ]+' '/inet /{print $3}')
    ipv4_hostname=$(getent hosts $ipv4_address | awk '{print $2}')
    network_address=$(ip route list dev $interface scope link | cut -d ' ' -f 1)
    network_number=$(cut -d / -f 1 <<<"$network_address")
    network_name=$(getent networks $network_number | awk '{print $1}')

