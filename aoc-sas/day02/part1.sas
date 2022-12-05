* Read file into input dataset;
filename inputtxt "&root./day02./input.txt";
data input;
    infile inputtxt;
    input elf $ 1 me $ 3;
run;

* Test data;
data input_s;
    infile datalines dsd;
    input elf $ 1 me $ 3;
    datalines;
A Y
B X
C Z
;
run;

%let input=input;

%macro compute(input);
proc format;
    value $rps 'A'='R'
               'B'='P'
               'C'='S'
               'X'='R'
               'Y'='P'
               'Z'='S';
    value $win 'R'='P'
               'P'='S'
               'S'='R';
    invalue score 'R'=1
                  'P'=2
                  'S'=3;
run;

data games;
    set &input. end=eof;
    score = 0;
    retain total_score;
    elf = put(elf, rps.);
    me = put(me, rps.);
    if elf = me then
        score = score + 3;
    else if elf ^= put(me, win.) then
        score = score + 6;
    
    score = score + input(me, score.);

    total_score + score;

    if eof then
        call symputx('result', total_score, 'g');
run;


/*%get(part1, res, result);*/
%mend compute;
 

* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=15);

* Compute full result;
%compute(input);
%put &=result.;
