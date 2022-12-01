%macro get(ds, var, outvar);
    %local return;
    proc sql noprint;
        select &var. into :return from &ds.;
    quit;

    data _null_;
        call symputx("&outvar.", "&return.","G");
    run;
%mend get;

