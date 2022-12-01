%macro direxist(dir) ; 
   %local rc fileref return; 
   %let rc = %sysfunc(filename(fileref,&dir)) ; 
   %if %sysfunc(fexist(&fileref))  %then %let return=1;    
   %else %let return=0;
   &return
%mend direxist;