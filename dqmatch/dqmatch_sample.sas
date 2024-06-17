/* Create the input data set. */
options dqlocale=(enusa);
data cust_db;
   length customer $ 22;
   length address $ 31;
   input customer $char22. address $char31.;
datalines;
Bob Beckett             39 Main Street  
Robert E. Becket        392 Main St. 
Rob Becke               392 S. Main 
Paul Becker             390 N. Main St. 
Bobby Becket            392 Main Street
Mr. Robert J. Beckit    392 S. Main St.
Mr. Robert E Beckett    392 North Main Street
Mr. Raul Becker         392 North Main St.
;
run;

/* Run the DQMATCH procedure. */
proc dqmatch data=cust_db out=out_db1 matchcode=match_cd
   cluster=clustergrp locale='ENUSA';
   criteria matchdef='Name' var=customer;
   criteria matchdef='Address' var=address;
run;

/* Print the results. */
title 'Result of Name and Address match clustering
at the default sensitivity';
proc print data=out_db1;
run;