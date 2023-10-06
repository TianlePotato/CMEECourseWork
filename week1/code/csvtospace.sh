#!/bin/bash

# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: csvtospace.sh
# Desc: conversion of comma separated values to space separated values
# Arguments: 1 -> Comma delimited file
# Date: Oct 2023

echo "Creating a space delimited version of $1 ..."
cat $1 | tr -s "," " " >> $1.txt
echo "Done!"
exit