* Read file into input dataset;

filename inputtxt "&root./day04./input.txt";
data input;
    infile inputtxt dlm=",-";
    input a b c d;
run;

* Test data;
data input_s;
    infile datalines dlm=",-";
    input a b c d;x;
    datalines;
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
;
run;


%macro compute(input);
data out;
    set &input. end=eof;
    retain total;

    if (a <= d) and (b >= c) then
        total + 1;

    if eof then
        call symputx('result', total, 'g');
run;

/*%get(part1, res, result);*/
%mend compute;


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=4);

* Compute full result;
%compute(input);
%put &=result.;
