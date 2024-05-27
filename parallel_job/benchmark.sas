options mprint mlogic symbolgen fullstimer;
%let PATH = C:\code\sascode\parallel_job;
libname xdata "&PATH.\data";

%macro exec_hpforest(DS, NTHREADS);
proc hpforest data=xdata.&DS.;
	performance nthreads=&NTHREADS. details;
	target BAD / level=nominal;
	input CLAGE CLNO DEBTINC LOAN MORTDUE YOJ VALUE / level=interval;
	input DELINQ DEROG JOB NINQ REASON / level=nominal;
	save file="&PATH.\model\model_&DS..bin"
        RULES=xdata.rf_rules              /* undocumented, unsupported */
       TOPOLOGY=xdata.rf_topology        /* undocumented, unsupported */
        STATSBYNODE=xdata.rf_statsbynode  /* undocumented, unsupported */
;
	savestate file="&PATH.\model\model_&DS..sasast";
	ods output FitStatistics=xdata.FITSTAT VariableImportance=xdata.VARIMP;
run;
%mend;

%macro exec_astore(DS, NTHREADS);
proc astore;
	score data=xdata.&DS.
		copyvars=(_ALL_)
		store="&PATH.\model\model.sasast"
		out=xdata.scored
/*		nthreads=&NTHREADS.*/
	;
run;
%mend;

%macro exec_hp4score(DS, NTHREADS);
proc hp4score data=xdata.&DS.;
	performance nthreads=&NTHREADS.;
	score file="&PATH.\model\model.bin" 
		out=xdata.scored_&DS.
	;
run;
%mend;


%let NTHREADS=1;
%exec_astore(hmeq_1m, 1);
%exec_astore(hmeq_1m, 2);
%exec_astore(hmeq_1m, 4);
%exec_astore(hmeq_1m, 8);
%exec_astore(hmeq_1m, 16);
%exec_astore(hmeq_1m, 32);
%exec_astore(hmeq_1m, 64);
%exec_astore(hmeq_1m, 128);
%exec_astore(hmeq_1m, 256);


%exec_astore(hmeq_2m, 4);
%exec_astore(hmeq_3m, 4);
%exec_astore(hmeq_4m, 4);
%exec_astore(hmeq_5m, 4);
%exec_astore(hmeq_6m, 4);
%exec_astore(hmeq_7m, 4);
%exec_astore(hmeq_8m, 4);
%exec_astore(hmeq_9m, 4);
%exec_astore(hmeq_10m, 4);


%exec_astore(hmeq_12m, 4);
%exec_astore(hmeq_14m, 4);
%exec_astore(hmeq_16m, 4);
%exec_astore(hmeq_18m, 4);
%exec_astore(hmeq_20m, 4);


/*%exec_hpforest(hmeq_100k, 4);*/
/*%exec_hpforest(hmeq_100k, 8);*/
/*%exec_hpforest(hmeq_100k, 16);*/
/*%exec_hpforest(hmeq_100k, 32);*/
/*%exec_hpforest(hmeq_100k, 64);*/
/*%exec_hpforest(hmeq_100k, 128);*/
/*%exec_hpforest(hmeq_100k, 256);*/
/**/
/**/
/*%exec_astore(hmeq_100k);*/
/*%exec_astore(hmeq_200k);*/
/*%exec_astore(hmeq_300k);*/
/*%exec_astore(hmeq_400k);*/
/*%exec_astore(hmeq_500k);*/
/*%exec_astore(hmeq_600k);*/
/*%exec_astore(hmeq_700k);*/
/*%exec_astore(hmeq_800k);*/
/*%exec_astore(hmeq_900k);*/
/*%exec_astore(hmeq_1m);*/
/**/
/**/
%let NTHREADS=4;

%exec_hpforest(hmeq_100k, &NTHREADS.);
%exec_hpforest(hmeq_200k, &NTHREADS.);
%exec_hpforest(hmeq_300k, &NTHREADS.);
%exec_hpforest(hmeq_400k, &NTHREADS.);
%exec_hpforest(hmeq_500k, &NTHREADS.);
%exec_hpforest(hmeq_600k, &NTHREADS.);
%exec_hpforest(hmeq_700k, &NTHREADS.);
%exec_hpforest(hmeq_800k, &NTHREADS.);
%exec_hpforest(hmeq_900k, &NTHREADS.);
%exec_hpforest(hmeq_1m, &NTHREADS.);
/**/
/**/
/**/
/**/
/*%let NTHREADS=16;*/
/**/
/*%exec_hp4score(hmeq_100k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_200k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_300k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_400k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_500k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_600k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_700k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_800k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_900k, &NTHREADS.);*/
/*%exec_hp4score(hmeq_1m, &NTHREADS.);*/
/**/
/**/
/*%exec_hp4score(hmeq_1m, 1);*/
/*%exec_hp4score(hmeq_1m, 2);*/
/*%exec_hp4score(hmeq_1m, 4);*/
/*%exec_hp4score(hmeq_1m, 8);*/
/*%exec_hp4score(hmeq_1m, 16);*/
/*%exec_hp4score(hmeq_1m, 32);*/
/*%exec_hp4score(hmeq_1m, 64);*/
/*%exec_hp4score(hmeq_1m, 128);*/
/*%exec_hp4score(hmeq_1m, 256);*/