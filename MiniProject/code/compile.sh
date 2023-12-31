#!/bin/bash
# Author: Tianle Shao tianle.shao20@imperial.ac.uk
# Script: CompileLaTeX.sh
# Desc: Automatically compiles LaTeX .tex files into .pdf format
# Arguments: 1 -> .tex file, with or without the file extension name
# Date: Nov 2023


# Test if the ".tex" suffix is present for the input
suffix=".tex"

if [[ "$1" == *"$suffix"* ]]
then
    filename=${1%"$suffix"}
else
    filename=$1
fi

# Complies the .pdf document
pdflatex -shell-escape $filename.tex
bibtex $filename
pdflatex -shell-escape $filename.tex
pdflatex -shell-escape $filename.tex
evince $filename.pdf &

# Cleanup
rm *.aux
rm *.log
rm *.bbl
rm *.blg
rm Rplots.pdf