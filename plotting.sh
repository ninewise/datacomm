
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
HERE

