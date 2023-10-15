#!/bin/bash
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: CountLines.sh
# Desc: Counts number of lines in a file
# Arguments: 1 -> a file with lines to count
# Date: Oct 2023

if [ $# -ne 1 ]  # If number of inputs is equal to 1
then
    echo "Please enter one input"
else
    NumLines=`wc -l < $1`
    echo "The file $1 has $NumLines lines"

fi

