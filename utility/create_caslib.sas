cas;
caslib mycaslib path="/greenmonthly-export/ssemonthly/homes/Pulung.Waskito@sas.com/data";
caslib _all_ assign;

data mycaslib.hmeq;
	set sampsio.hmeq;
run;