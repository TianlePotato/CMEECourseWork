#!/bin/bash
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: csvtospace.sh
# Desc: conversion of comma separated values to space separated values
# Arguments: 1 -> Comma delimited file (.csv)
# Date: Oct 2023

if [ $# -ne 1 ]  # If number of inputs is equal to 1
then
    echo "Please enter one input"

else
    if [[ $1 == *".csv"* ]]  # If input is a .csv file
    then
        echo "Converting $1 to space separated format"

        suffix=".csv"
        filename=${1%"$suffix"} # Removes the .csv suffix of the file

        cat $1 | tr -s "," " " >> $filename.txt # Converts to .txt file
        echo "Saved as $filename.txt"

    else
        echo "Not a .csv file"
    fi
fi

