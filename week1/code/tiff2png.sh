#!/bin/bash

# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: tiff2png.sh
# Desc: conversion of .tif files to .png files
# Arguments: 1 -> .tif file
# Date: Oct 2023

for f in *.tif;
    do
        echo "Converting $f";
        convert "$f" "$(basename "f" .tif).png";
    done
