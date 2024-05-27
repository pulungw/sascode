


/*** INPUTデータが閾値以上の場合、サンプリングを実施 ***/
%let THRESHOLD=1000000;
%if &n_obs. > &THRESHOLD. %then %do;

	/*** 精度評価データの無作為抽出 ***/
	proc surveyselect 
		data=&lib..TMPMODEL_&model._VALID 
		out=&lib..TMPMODEL_&model._VALID
		N=&THRESHOLD.
		method=srs
		seed=10
		;
	run;

%end;



proc contents data=xdata.higgs_test;
run;

proc surveyselect data=xdata.higgs_test out=xdata.tmp_higgs n=10000 method=srs seed=10;
run;

proc contents data=xdata.tmp_higgs;
run;

proc surveyselect 
	data=xdata.tmp_higgs 
	out=xdata.tmp_higgs 
	n=100 
	method=srs 
	seed=10;
run;

proc contents data=xdata.tmp_higgs;
run;