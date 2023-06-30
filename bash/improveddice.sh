#!/bin/bash
#
# This script rolls a pair of six-sided dice and displays both the rolls
#

# Task 1:
# Define variables for the range and bias
range=6
bias=1

# Roll the dice using the variables for the range and bias
die1=$(( RANDOM % range + bias))
die2=$(( RANDOM % range + bias))

# Task 2:
# Calculate the sum and average of the dice
sum=$(( die1 + die2 ))
average=$(( sum / 2 ))

# Display the results
echo "Rolling..."
echo "Rolled $die1, $die2"
echo "Sum: $sum"
echo "Average: $average"
