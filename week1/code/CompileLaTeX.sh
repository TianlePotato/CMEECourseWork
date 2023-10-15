#!/bin/bash
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: CompileLaTeX.sh
# Desc: Automatically compiles LaTeX .tex files into .pdf format
# Arguments: 1 -> .tex file, with or without the file extension name
# Date: Oct 2023


# Test if the ".tex" suffix is present for the input
suffix=".tex"

if [[ "$1" == *"$suffix"* ]]
then
    filename=${1%"$suffix"}
else
    filename=$1
fi

# Complies the .pdf document
pdflatex $filename.tex
bibtex $filename
pdflatex $filename.tex
pdflatex $filename.tex
evince $filename.pdf &

# Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg