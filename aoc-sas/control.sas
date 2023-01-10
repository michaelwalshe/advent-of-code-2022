* Location of project;
%let root = C:\Users\Michael.Walshe\source\personal\advent-of-code-2022\aoc-sas;

* Autocall macro library;
filename macros "&root/macros";

* SAS options;
options mautosource
		sasautos=(sasautos macros)
	    fmtsearch=(shared)
	    msglevel=i;

%create_day(2022, 6);