proc setinit;run;

/* specify DSN from odbc.ini in libname statement */
libname azsql sqlsvr datasrc="z01-dev" schema=SalesLT user=azureuser password=************;
 
/* test read */
proc sql inobs=100;
	select * from azsql.product;
quit;
 
/* test write */
proc sql;
	create table azsql.cars as
	select * from sashelp.cars;
quit;

proc contents data=azsql.cars order=varnum;
run;

proc contents data=sashelp.cars order=varnum;
run;

proc sql;
	select count(*) from azsql.cars;
quit;