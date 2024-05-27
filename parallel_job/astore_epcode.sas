options mprint mlogic symbolgen fullstimer;
%let PATH = C:\code\sascode\parallel_job;
libname xdata "&PATH.\data";

proc astore;
	describe 
		store="&PATH.\model\model.sasast"
/*		epcode="&PATH.\model\model.sas"*/
		showversion
	;
run;