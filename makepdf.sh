#!/bin/bash
# generate all required tex files
cd vraag2_1
./maketex.sh
cd ../

# make pdf
pdflatex verslag.tex
