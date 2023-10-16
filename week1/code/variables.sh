#!/bin/sh
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: variables.sh
# Desc: Illustrates the use of variables
# Date: Oct 2023

# Special variables

echo "This script was called with $# parameters"
echo "The script's name is $0"
echo "The arguments are $@"
echo "The first argument is $1"
echo "The second argument is $2"

# Assigned variables; Explicit declaration:
MY_VAR='some string'
echo 'the current value of the variable is:' $MY_VAR
echo
echo 'Please enter a new string'
read MY_VAR
echo
echo 'The current value of the variable is:' $MY_VAR
echo

# Assigned variables; Reading (multiple values) from user input:
echo 'Enter two numbers separated by space(s)'
read a b
echo
echo 'You entered' $a 'and' $b '; Their sum is:'

## Assigned variables; Command substitution:
MY_SUM=$(expr $a + $b)
echo $MY_SUM