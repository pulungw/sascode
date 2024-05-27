proc options;
run;

data work.class;
	set sashelp.class;
	val = age * height * weight;
run;

proc hpforest data=work.class;
	target Weight;
	input Age Height / level=interval;
	ods output FitStatistics=work.fitstats;
run;

data work.fitstats_rmse;
	set work.fitstats;
	rmseAll = sqrt(PredAll);
	rmseOob = sqrt(PredOob);
	label rmseAll = "RMSE (Full Data)";
	label rmseOob = "RMSE (OOB)";
run;

proc sgplot data=fitstats_rmse;
	title "OOB vs Training";
	series x=NTrees y=rmseAll;
	series x=NTrees y=rmseOob / lineattrs=(pattern=shortdash thickness=2);
	yaxis label='RMSE';
run;
title;
