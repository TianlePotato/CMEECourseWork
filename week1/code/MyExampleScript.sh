#!/bin/sh
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: MyExampleScript.sh
# Desc: Tests the use of variables
# Arguments: none
# Date: Oct 2023

MSG1="Hello"
MSG2=$USER
echo "$MSG1 $MSG2"
echo "Hello $USER"
echo