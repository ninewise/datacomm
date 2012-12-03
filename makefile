all: verslag.pdf
	
verslag.pdf: verslag.tex
	pdflatex $<

verslag.tex: vraag2_1/generatormatrix.tex vraag2_1/checkmatrix.tex vraag2_1/syst_generatormatrix.tex vraag2_1/syst_checkmatrix.tex

clean:
	rm -f vraag2_1/*.tex
	rm -f verslag.pdf

vraag2_1/%.tex: vraag2_1/%.csv
	echo '\\begin{pmatrix}' > $@
	cat $< | sed -e 's/,/ \& /g' -e 's/.*/& \\\\/' >> $@
	echo '\\end{pmatrix}' >> $@
