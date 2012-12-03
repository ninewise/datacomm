all: clean vraag2_1_all verslag.pdf
	
vraag2_1_all: vraag2_1/generatormatrix.tex vraag2_1/checkmatrix.tex vraag2_1/syst_generatormatrix.tex vraag2_1/syst_checkmatrix.tex

verslag.pdf:
	pdflatex verslag.tex

clean:
	rm vraag2_1/*.tex
	rm verslag.pdf

vraag2_1/generatormatrix.tex:
	./csv2tex.sh vraag2_1/generatormatrix.csv > vraag2_1/generatormatrix.tex

vraag2_1/checkmatrix.tex:
	./csv2tex.sh vraag2_1/checkmatrix.csv > vraag2_1/checkmatrix.tex

vraag2_1/syst_generatormatrix.tex:
	./csv2tex.sh vraag2_1/syst_generatormatrix.csv > vraag2_1/syst_generatormatrix.tex

vraag2_1/syst_checkmatrix.tex:
	./csv2tex.sh vraag2_1/syst_checkmatrix.csv > vraag2_1/syst_checkmatrix.tex