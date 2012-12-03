#!/bin/bash
echo "\begin{pmatrix}"
sed 's/,/ \& /g;s/$/ \\\\/g' < $1
echo "\end{pmatrix}"
