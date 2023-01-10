
%macro compute(file_name);
/*Split input data in two*/
data boxes_s;
    infile "&file_name." missover length=reclen;
    input x $varying1024. reclen;
    /*Output moves to file*/
    if find(x, "move") >= 1 then do;
        file "&root./day05./moves.txt";
        put _infile_;
    end;

    else do;
        /* Output boxes to dataset */
        if find(x, "[") >= 1 then output boxes_s;
        /* Compute the number of stacks to use in later processing loop */
        if find(x, "1") then call symputx("n_stacks", floor((length(x) + 1 )/ 4) + 1);;
    end;
run;


data moves;
    /* Use delimiters to only read numbers (better method?)*/
    infile "&root./day05./moves.txt" dlm="movefromto ";
    input amount from to;
run;


data boxes;
    set boxes_s end=eof;
    array stacks{&n_stacks} $64 (&n_stacks*"");
    /* Iterate over row of characters, checking if we find
       a box at a certain stack position and if so insert
    */
    r = 2;
    do i=1 to &n_stacks;
        b = substr(x, r, 1);
        if b ^= "" then stacks[i] = cats(b, stacks[i]);
        r = r + 4;
    end;

    if eof then output;
    keep stacks:;
run;


data output;
    set boxes;
    array stacks {*} $ stacks:;
    
    do i=1 to nobs;
        * Get move;
        set moves nobs=nobs;
        output;
        * Get amount of boxes from from stack string;
        cargo = substr(stacks[from], length(stacks[from]) - amount + 1, amount);
        if amount < length(stacks[from]) then do;
            * Remove cargo from from stack;
            stacks[from] = substr(stacks[from], 1, length(stacks[from]) - amount);
        end;
        else do;
            * Handle edge case of moving entire stack;
            stacks[from] = "";
        end;
        * Add to end of new stack;
        stacks[to] = cats(stacks[to], cargo);
        output;
    end;

    * Output result;
    length result $64;
    retain result;
    do i=1 to dim(stacks);
        result = cats(result, substr(left(reverse(stacks[i])), 1, 1));
    end;
    call symputx("result", result, "g");
    output;
run;
%mend compute;




* Test on small input;
%compute(&root./day05/small_input.txt);
%assert(iftrue=&result. = MCD);

* Compute full result;
%compute(&root./day05/input.txt);
%put &=result.;
