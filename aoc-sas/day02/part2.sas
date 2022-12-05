* Read file into input dataset;
filename inputtxt "&root./day02./input.txt";
data input;
    infile inputtxt;
    input elf $ 1 strategy $ 3;
run;

* Test data;
data input_s;
    infile datalines dsd;
    input elf $ 1 strategy $ 3;
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
               'C'='S';
    value $win 'R'='P'
               'P'='S'
               'S'='R';
    value $lose 'R'='S'
                'P'='R'
                'S'='P';
    invalue score 'R'=1
                  'P'=2
                  'S'=3;
run;

data games;
    set &input. end=eof;
    score = 0;
    retain total_score;
    elf = put(elf, rps.);
    if strategy='Z' then do;
        me = put(elf, win.);
        score = score + 6;
    end;
    else if strategy='Y' then do;
        me = elf;
        score = score + 3;
    end;
    else me=put(elf, lose.);
        
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
