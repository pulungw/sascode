caslib cashome path="/greenmonthly-export/ssemonthly/homes/Pulung.Waskito@sas.com" datasource=(srctype="dnfs");
caslib _all_ assign;

proc casutil;
	load data=sashelp.class casout="class" outcaslib="cashome" replace;
	save casdata="class" casout="class.parquet" outcaslib="cashome";
/* 	droptable casdata="class"; */
quit;