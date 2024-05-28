options mprint mlogic symbolgen fullstimer;

%let vars_interval = LOAN MORTDUE VALUE YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC;
%Let vars_nominal = REASON JOB;
%let target = BAD;

data work.train;
	set sampsio.hmeq;
run;

/*** Training code ***/
proc hpforest data=work.train maxtrees=50 maxdepth=50 seed=10 importance=yes;
	target &TARGET. / level=binary;
	input &VARS_INTERVAL. / level=interval;
	input &VARS_NOMINAL. / level=nominal;
	savestate file="C:\temp\model.sasast";
	save file="C:\temp\model.bin"

		/*** undocumented, unsupported ***/
		Rules=work.rf_rules
		Topology=work.rf_topology
		StatsByNode=work.rf_statsbynode
	;
	ods output FitStatistics=work.RF_FITSTAT VariableImportance=work.RF_VARIMP;
	performance details;
run;
