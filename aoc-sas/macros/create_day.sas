%macro create_day(year, day);
    %* Pad day for folder format;
    %let day_name=day%sysfunc(putn(&day., z2.));
    
    %* Copy sample directory for this day;
    %if not %sysfunc(fileexist(&root.\&day_name.)) %then %do;
        %sysExec xcopy "&root.\day00\*.*"  "&root.\&day_name.\*.*" /s;
    %end;
    %else %do;
        %put %str(E)RROR: Directory already exists;
        %abort;
    %end;

    %* Download the current day to local file;
    filename out "&root.\&day_name.\input.txt";
    proc http
        url="https://adventofcode.com/&year./day/&day./input"
        method="get"
        out=out
    ;
        headers "Cookie"="%_get_cookie()";
    run;
%mend create_day;

