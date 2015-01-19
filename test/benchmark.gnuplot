set term png
set output "benchmark.png"
set grid
set title 'Performance Comparison'
set xtics (1000000, 2000000, 3000000, 4000000, 5000000)
set ylabel 'Import Time (seconds)'
set xlabel 'Number of Rows'
set format x '%.0s%c'
plot 'benchmark.results' u 1:2 w lp t 'Direct', 'benchmark.results' u 1:3 w lp t 'Hasten'
