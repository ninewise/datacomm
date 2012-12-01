#!/bin/bash
../csv2tex.sh generatormatrix.csv > generatormatrix.tex
../csv2tex.sh checkmatrix.csv > checkmatrix.tex
../csv2tex.sh syst_generatormatrix.csv > syst_generatormatrix.tex
../csv2tex.sh syst_checkmatrix.csv > syst_checkmatrix.tex
