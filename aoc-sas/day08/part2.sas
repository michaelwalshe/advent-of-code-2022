

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
    
    /* Function to iterate over vector of trees, counting visible trees
       Probably could have found matrix method for this (loc, minus offset, loc of >1 increase??)
    */
    start getSeen(trees, t);
        if isempty(trees) then return 0;
        
        seen = 0;
        do k=1 to max(dimension(trees));
            seen = seen + 1;
            if trees[k] >= t then return seen;
        end;

        return seen;
    finish;
    
    /* Reverse an arbitrary matrix */
    start reverse(x);
        n = nrow(x); m = ncol(x);
        return shape(x[n*m:1], n, m);
    finish;
    

    c = ncol(m);
    r = nrow(m);
    greatest = 0;
    do j=1 to c;
        do i=1 to r;
            t = m[i, j];
            if j=1 then left = {};
            else left = reverse(m[i, 1:(j-1)]);

            if j=c then right={};
            else right = m[i, (j+1):c];
            
            if i=r then down = {};
            else down = m[(i+1):r, j];

            if i=1 then up = {};
            else up = reverse(m[1:(i-1), j]);

            view = (
                getSeen(left, t) #
                getSeen(right, t) #
                getSeen(up, t) #
                getSeen(down, t)
            );
               
            greatest = max(view, greatest);
        end;
    end;

    call symputx("result", greatest, "g");
quit;

%mend compute;


filename input "&root./day08/input.txt";
filename input_s "&root./day08/input_s.txt";


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=8);

* Compute full result;
%compute(input);
%put &=result.;
