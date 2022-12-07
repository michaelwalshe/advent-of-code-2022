* Read file into input dataset;

filename inputtxt "&root./day00./input.txt";
data input;
    infile inputtxt dsd;
    length x $256;
    input x;
run;

* Test data;
data input_s;
    infile datalines dsd;
    input x;
    datalines;
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
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
