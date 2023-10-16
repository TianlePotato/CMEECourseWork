#!/bin/sh
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: tabtocsv.sh
# Description: substitute the tabs in the files with commas
#
# Saves the output into a .csv file
# Arguments: 1 -> tab delimited file
# Date: Oct 2019

if [ $# -ne 1 ]  # If number of inputs is equal to 1
then
    echo "Please enter one input"

else
    echo "Converting $1 to space separated format"

    echo "Creating a comma delimited version of $1 ..."
    cat $1 | tr -s "t" "," >> $1.csv
    echo "Done!"
    
fi

