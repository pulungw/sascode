cas;
caslib _all_ assign;

proc casutil;
	list files incaslib=snow;
	list tables incaslib=snow;
run;

data snow.class;
	set sashelp.class;
run;

proc casutil incaslib=snow;
	list files;
	list tables;
run;

proc casutil;
	save incaslib="snow" casdata="class" outcaslib="snow" casout="class";
run;

proc casutil incaslib=snow;
	list files;
	list tables;
run;

proc cas;
	table.caslibinfo /caslib="snow";
	table.tableinfo /caslib="snow";
	table.fileinfo /caslib="snow";
quit;