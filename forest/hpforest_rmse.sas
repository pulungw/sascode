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

data work.rmse;
	set work.RF_FITSTAT;
	rmseAll = sqrt(PredAll);
	rmseOob = sqrt(PredOob);
	label rmseAll = "RMSE (Full Data)";
	label rmseOob = "RMSE (OOB)";
run;

proc sgplot data=work.rmse;
	title "OOB vs Training";
	series x=NTrees y=rmseAll;
	series x=NTrees y=rmseOob / lineattrs=(pattern=shortdash thickness=2);
	yaxis label='RMSE';
run;
title;
