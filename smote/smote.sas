cas;
caslib _all_ assign;

data casuser.cars;
   set sashelp.cars(keep= MPG_City Weight EngineSize);
run;

ods graphics on;
title "Pearson Correlation and Matrix Plot of Original Data";
proc corr data=casuser.cars noprob plots=matrix(hist);
	var MPG_City Weight EngineSize;
	ods select PearsonCorr MatrixPlot;
run;

proc cas;
smote.smoteSample result=r /
	table={caslib="casuser", name="cars"}
 	k=3
 	seed=123
 	numSamples=500
 	casOut={caslib="casuser", name="cars_smote", replace=TRUE}
	;
run;

title "Pearson Correlation and Matrix Plot of Synthetic Data";
proc corr data=casuser.cars_smote noprob plots=matrix(hist);
	var MPG_City Weight EngineSize;
	ods select PearsonCorr MatrixPlot;
run;