all: verslag.pdf
	
verslag.pdf: verslag.tex
	pdflatex $<

verslag.tex: vraag2_1/generatormatrix.tex vraag2_1/checkmatrix.tex vraag2_1/syst_generatormatrix.tex vraag2_1/syst_checkmatrix.tex vraag2_3.png

clean:
	rm -f vraag2_1/*.tex
	rm -f verslag.pdf
	rm -f *.aux *.log

vraag2_1/%.tex: vraag2_1/%.csv
	./csv2tex.sh $< > $@

vraag2_3.png: plotting.sh vraag2_3.cvs
	bash $<
