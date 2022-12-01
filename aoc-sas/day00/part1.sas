* Read file into input dataset;

filename inputtxt "&root./day00./input.txt";
data input;
    infile inputtxt dsd;
    input x;
run;

* Test data;
data input_s;
    infile datalines dsd;
    input x;
    datalines;
1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
;
run;