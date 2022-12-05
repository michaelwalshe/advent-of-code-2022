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
/*For larger groups would likely use a varname variable
  plus proc transpose*/
data out;
    set &input.;
    length x1 x2 x3 $256;
    drop x n;
    retain x1 x2 x3 n;
    n + 1;
    if n=1 then
        x1=x;
    else if n=2 then
        x2=x;
    else do;
        x3=x;
        output;
        n = 0;
    end;
run;


data out;
    set out end=eof;
    length x1 x2 $256;
    retain total;

    intersect='';
    do i=1 to length(x1);
        c=char(x1, i);
        if find(x2, c) and find(x3, c) then
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
%assert(iftrue=&result.=70);

* Compute full result;
%compute(input);
%put &=result.;
