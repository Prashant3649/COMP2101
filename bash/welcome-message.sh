#!/bin/bash
#
# This script produces a dynamic welcome message
# It should look like:
#   Welcome to planet hostname, title name!

###############
# Variables   #
###############
title=""
myname="$USER"
hostname="$(hostname)"

###############
# Main        #
###############

# Task 3: Get the current time and day of the week
current_time=$(date +"%I:%M %p")
current_day=$(date +"%A")

# Task 4: Set the title based on the day of the week
case $current_day in
  Monday)
    title="Enthusiast"
    ;;
  Tuesday)
    title="Dreamer"
    ;;
  Wednesday)
    title="Explorer"
    ;;
  Thursday)
    title="Innovator"
    ;;
  Friday)
    title="Adventurer"
    ;;
  *)
    title="Visitor"
    ;;
esac

cat <<EOF

Welcome to planet $hostname, "$title $myname!"
It is $current_day at $current_time.

EOF
