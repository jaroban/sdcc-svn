set output "stdcbench-mcs51-size.svg"
set terminal svg size 640,480
set style data lines
set xlabel "revision"
set ylabel "size [B]"
set arrow from 9618, 13050 to 9618, 12950
set label "3.6.0" at 9618, 13050
set arrow from 10233, 13805 to 10233, 13705
set label "3.7.0" at 10233, 13805
set arrow from 10582, 13480 to 10582, 13380
set label "3.8.0" at 10582, 13480
set arrow from 11214, 14064 to 11214, 13964
set label "3.9.0" at 10582, 14064
set arrow from 11533, 14080 to 11533, 13980
set label "4.0.0" at 11533, 14080
set arrow from 12085, 14089 to 12085, 13989
set label "4.1.0" at 12085, 14089
plot "stdcbench-mcs51-sizetable" using 1:4 title "default", "stdcbench-mcs51-sizetable" using 1:2 title "size", "stdcbench-mcs51-sizetable" using 1:3 title "speed"

