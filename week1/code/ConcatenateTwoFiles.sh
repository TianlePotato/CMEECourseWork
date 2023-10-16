#!/bin/bash
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: ConcatenateTwoFiles.sh
# Desc: Merges two files together
# Arguments: 1,2 -> two files; 3 -> new file name
# Date: Oct 2023

if [ $# -ne 3 ]  # If number of inputs is equal to 3
then
    echo "Please enter three inputs: where the first two are two files to be merged, and the third is the new file name"
else
    cat $1 > $3
    cat $2 >> $3
    echo "merged file is"
    cat $3
fi

