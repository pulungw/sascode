data UNIX_to_SAS;
   input UNIX_datetime;
   SAS_datetime = dhms('01jan1970'd, 0,0, UNIX_datetime);  
   format SAS_datetime datetime20.;               
datalines;                                   
1285560000                                     
1313518500                                   
1328414200                                   
;                                             
proc print data=UNIX_to_SAS;                   
run;            