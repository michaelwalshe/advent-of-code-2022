* Read file into input dataset;

filename inputtxt "&root./day06/input.txt";
data input;
    infile inputtxt dsd;
    length x $4096;
    input x;
run;

data input_s;
    infile datalines dsd;
    length x $1024;
    input x;
    datalines;
mjqjpqmgbljsphdztnvjfqwrcgsmlb
;
run;



%macro compute(input);
data output;
    set &input.;
    do i=1 to length(x);
        chars = substr(x, i, 14);
        _t = chars;
        do n_distinct = 0 by 1 while (_t ne '');
            _t=compress(_t,first(_t));
        end;
        if n_distinct = 14 then do;
            res = i + 13;
            call symputx("result", i+13, "g")
            stop;
        end;
    end;
run;

%mend compute;


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=19);

* Compute full result;
%compute(input);
%put &=result.;
