%let root = C:\Users\Michael.Walshe\source\personal\advent-of-code-2022\aoc-sas;

* Read file into input dataset;

filename inputtxt "&root./day00/input.txt";
data input;
    infile inputtxt dsd;
    length x $256;
    input x;
run;

* Test data;
data input_s;
    infile datalines dsd;
    length x $256;
    input x;
    datalines;
....
;
run;


%macro compute(input);
data out;
    set &input. end=eof;
    retain total;

    if eof then
        call symputx('result', total, 'g');
run;

%get(part1, res, result);
%mend compute;


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=1);

* Compute full result;
%compute(input);
%put &=result.;
