* Read file into input dataset;

filename inputtxt "&root./day05./input.txt";
data boxes moves;
    infile inputtxt dsd;
    length x $256;
    input x;
run;

* Test data;
data boxes_s moves_s;
    infile datalines missover length=reclen;
    input x $varying1024. reclen;
    if find(x, "move") >= 1 then do;
        file "&root./day05./moves.txt";
        put _infile_;
        output moves_s;
    end;

    else do;
        file "&root./day05./boxes.txt";
        put _infile_;
        output boxes_s;
        i = _N_;
        if find(x, "1") then call symputx("n_stacks", floor((length(x) + 1 )/ 4) + 1);
        call symputx("n_records", _N_-2);
    end;

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


%put &=n_records;

proc sort data=boxes_s(obs=&n_records);
    by descending i;
run;



%macro compute(boxes, moves);
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
