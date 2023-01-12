%let root = C:\Users\Michael.Walshe\source\personal\advent-of-code-2022\aoc-sas;


%macro compute(input);
/* Get number of trees to process input */
data _NULL_;
    infile &input.;
    length x $1024;
    input x $;
    if _N_ = 1 then do;
        call symputx("ntrees", length(x));
        stop;
    end;
run;

/* Read ntrees variables in */
data input;
    infile &input.;
    input
        %do i=1 %to &ntrees.;
            t&i. &i.
        %end;
    ;
run;

proc iml;
    /* Import dataset into matrix */
    use input;
    read all into m;
    
    c = ncol(m);
    r = nrow(m);
    tot = 0;

    /* For each tree on the interior */
    do j=2 to c - 1;
        do i=2 to r - 1;
            /* Check if vector of trees to the l/r/u/d is all less than it
               if so, this tree is visible so add 1 */
            t = m[i, j];
            left = all(m[i, 1:(j-1)] < t);
            right = all(m[i, (j+1):c] < t);
            up = all(m[(i+1):r, j] < t);
            down = all(m[1:(i-1), j] < t);
            if any(left || right || up || down) then do;
                tot = tot + 1;
            end;
        end;
    end;
    
    /* Add exterior trees and return*/
    tot = tot + 2 * c + 2 * (r - 2);
    call symputx("result", tot, "g");
quit;

%mend compute;


filename input "&root./day08/input.txt";
filename input_s "&root./day08/input_s.txt";


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=21);

* Compute full result;
%compute(input);
%put &=result.;
