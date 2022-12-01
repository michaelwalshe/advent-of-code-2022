* Read file into input dataset;

filename inputtxt "&root./day01./input.txt";
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

%macro compute(input);
* Get cumulative sum of calories per elf;
data out;
    set &input. end=eof;
    if not (x=.) then do;
        elf + x;
    end;
    else do;
        output;
        elf = 0;
    end;
    if eof then output;
    keep elf;
run;

* Find max (or max 3) elfs;
proc sort data=out;
    by descending elf;
run;

data part1;
    set out(obs=1);
run;

%get(part1, elf, result);
%mend compute;


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=24000);

* Compute full result;
%compute(input);
%put &=result.;
