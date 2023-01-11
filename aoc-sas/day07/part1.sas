%let root = C:\Users\Michael.Walshe\source\personal\advent-of-code-2022\aoc-sas;
* Read file into input dataset;

filename inputtxt "&root./day07/input.txt";
data input;
    infile inputtxt dsd;
    length x $256;
    input x;
run;

data input_s;
    infile datalines dsd;
    length x $256;
    input x $;
    datalines;
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
;
run;


%macro compute(input);
* Create map of filesystem, cur_dir indicates pwd;
data filesystem(drop=_:);
    set &input.;
    length cur_dir $256;
    retain cur_dir "/";
    
    * Skip "cd /" as this is hardcoded;
    if _N_ eq 1 then return;
    
    * For OS commands;
    if first(x) eq "$" then do;
        _instr = scan(x, 2, " ");
        if _instr ne "ls" then do;
            _level = scan(x, 3, " ");
            if _level ne ".." then do;
                cur_dir = cats(cur_dir, _level, "/");
            end;
            else do;
                _last_slash = length(cur_dir) - length(scan(cur_dir, -2, '/')) - 1;
                cur_dir = substr(cur_dir, 1, _last_slash);
            end;
        end;
    end;
    * Parse output of ls;
    else if x ^=: "dir" then do;
        * Skip directories, not needed;
        * Get size and filename, then output along with current value
          of cur_dir;
        size = input(scan(x, 1, " "), 8.);
        fname = scan(x, 2, " ");
        output;
    end;
run;

data full_contents;
    set filesystem;
       
    * Flag for original vs copies of files;
    real = 1;
    output;
    * Consume cur_dir, creating new output record for each subdir that
      the current file exists in, to allow for SQL sum;
    do while (cur_dir ne "/");
        real = 0;
        _last_slash = length(cur_dir) - length(scan(cur_dir, -2, '/')) - 1;
        cur_dir = substr(cur_dir, 1, _last_slash);
        output;
    end;
run;

%global result;
proc sql;
    create table folder_sizes as
    select
        cur_dir,
        sum(size) as size
    from full_contents
    group by cur_dir
    ;

    select sum(size) into :result
    from folder_sizes
    where size <= 100000; 
quit;

%mend compute;


* Test on small input;
%compute(input_s);
%assert(iftrue=&result.=95437);

* Compute full result;
%compute(input);
%put &=result.;
