* Read file into input dataset;

filename inputtxt "&root./day03./input.txt";
data input;
    infile inputtxt dsd;
    length x $256;
    input x;
run;

* Test data;
data input_s;
    infile datalines dsd;
    length x $256;
    input x $;
    datalines;
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
;
run;


%macro compute(input);
data out;
    set &input. end=eof;
    length x1 x2 $256;
    retain total;
    x1=substr(x, 1, length(x)/2);
    x2=substr(x, length(x)/2 + 1);

    intersect='';
    do i=1 to length(x1);
        c=char(x1, i);
        if find(x2, c) then
            intersect = c;
    end;

    if upcase(intersect)=intersect then
        priority = rank(intersect)-38;
    else
        priority = rank(intersect)-96;

    total + priority;

    if eof then
        call symputx('result', total, 'g');
run;

/*%get(part1, res, result);*/
%mend compute;


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=157);

* Compute full result;
%compute(input);
%put &=result.;
