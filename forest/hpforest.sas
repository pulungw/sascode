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

	ods output FitStatistics=work.RF_FITSTAT VariableImportance=work.RF_VARIMP;
	performance details;
run;

proc sgplot data=work.RF_FITSTAT;
	series x=NTrees y=PredAll;
	series x=NTrees y=PredOOB;
	yaxis label="Average Square Error (ASE)";
run;