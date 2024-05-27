cas;
caslib _all_ assign;

proc casutil;
	save 
		incaslib="public" casdata="cambridge_data" 
		outcaslib="casuser" casout="cambridge_data"
		replace
	;
run;

proc casutil;
	save 
		incaslib="public" casdata="cambridge_data" 
		outcaslib="casuser" casout="cambridge_data.csv"
		replace
	;
run;

proc casutil;
	save 
		incaslib="public" casdata="cambridge_data" 
		outcaslib="casuser" casout="cambridge_data.sas7bdat"
		replace
	;
run;

libname test "/greenmonthly-export/ssemonthly/homes/Pulung.Waskito@sas.com/data";

proc casutil;
	load incaslib="casuser" casdata="cambridge_data.sashdat"
		outcaslib="casuser" casout="cambridge_data" replace
	;
run;

proc export data=casuser.cambridge_data 
	outfile="/greenmonthly-export/ssemonthly/homes/Pulung.Waskito@sas.com/data/cambridge_data.csv" dbms=csv
	;
run;

data test.cambridge_data;
	set casuser.cambridge_data;
run;

