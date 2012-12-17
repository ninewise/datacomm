
gnuplot <<HERE
set terminal png
set output "vraag2_3.png"
set logscale xy
set xlabel "Kans op bitflip in het kanaal"
set ylabel "Relatieve frequentie decodeerfouten"
plot "vraag2_3.cvs" using 1:2 with linespoints title "theoretisch", \
     "vraag2_3.cvs" using 1:3 with linespoints title "praktisch"
HERE

