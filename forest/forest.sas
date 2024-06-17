options mprint mlogic symbolgen fullstimer;
cas;
caslib _all_ assign;

%let vars_interval = LOAN MORTDUE VALUE YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC;
%Let vars_nominal = REASON JOB;
%let target = BAD;

data casuser.train;
	set sampsio.hmeq;
run;

/*** Training code ***/
/* proc hpforest data=work.train maxtrees=50 maxdepth=50 seed=10 importance=yes;
	target &TARGET. / level=binary;
	input &VARS_INTERVAL. / level=interval;
	input &VARS_NOMINAL. / level=nominal;
	savestate file="C:\temp\model.sasast";
	save file="C:\temp\model.bin"
		Rules=work.rf_rules
		Topology=work.rf_topology
		StatsByNode=work.rf_statsbynode
	;
	ods output FitStatistics=work.RF_FITSTAT VariableImportance=work.RF_VARIMP;
	performance details;
run; */

proc forest data=casuser.train ntrees=50 maxdepth=50 seed=10;
	target &TARGET. / level=nominal;
	input &VARS_INTERVAL. / level=interval;
	input &VARS_NOMINAL. / level=nominal;
	savestate rstore=casuser.model;
	ods output FitStatistics=work.RF_FITSTAT VariableImportance=work.RF_VARIMP;
run;

proc astore;
   download rstore=casuser.model
            store="/tmp/model.sasast";
quit;
