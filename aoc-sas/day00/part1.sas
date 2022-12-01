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
....
;
run;


%macro compute(input);
data out;
    set &input.;
run;

%get(part1, res, result);
%mend compute;


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=24000);

* Compute full result;
%compute(input);
%put &=result.;
