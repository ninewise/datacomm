
gnuplot <<HERE
set terminal png

set output "vraag1_4.png"
set xlabel "Lengte macroblok"
set ylabel "Gemiddeld aantal codebits per bronsymbool"
set title "Gemiddeld aantal codebits voor macrobloklengte 1..10"
plot "vraag1_4/avgcodebit.csv" using 1:2 with linespoints title "Ondergrens", \
     "vraag1_4/avgcodebit.csv" using 1:3 with linespoints title "Gemiddelde", \
     "vraag1_4/avgcodebit.csv" using 1:4 with linespoints title "Bovengrens"

unset title
set logscale xy
set format y "1e%T"

set output "vraag2_3.png"
set xlabel "Kans op bitflip in het kanaal"
set ylabel "Relatieve frequentie decodeerfouten"
plot "vraag2_3.cvs" using 1:2 with linespoints title "theoretisch", \
     "vraag2_3.cvs" using 1:3 with linespoints title "praktisch"

set output "vraag2_6.png"
set xlabel "Kans op bitflip in het kanaal"
set ylabel "Relatieve frequentie decodeerfouten"
plot "vraag2_6/prod_simulaties.csv" using 1:2 with linespoints title "theoretisch", \
     "vraag2_6/prod_simulaties.csv" using 1:3 with linespoints title "praktisch"

unset logscale

set output "vraag1_5.png"
set xlabel "Grootte alfabet"
set xrange [1:25]
plot x + 3 title "N + 3", \
     2 * log(x) title "K = 1", \
     4 * log(x) title "K = 2", \
     6 * log(x) title "K = 3", \
     8 * log(x) title "K = 4"
HERE

