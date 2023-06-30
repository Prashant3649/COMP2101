#!/bin/bash
#
# This script demonstrates doing arithmetic

# Task 1:
# Remove the assignments of numbers to the firstnum and secondnum variables.
# Use one or more read statements to take user input for the numbers.

# Task 2:
# Change the output to only show the sum and product of the 3 numbers with labels.

# Read user input for the numbers
read -p "Enter the first number: " firstnum
read -p "Enter the second number: " secondnum

# Calculate the sum and product of the numbers
sum=$((firstnum + secondnum))
product=$((firstnum * secondnum))

# Display the results
cat <<EOF
Sum of the numbers: $sum
Product of the numbers: $product
EOF
