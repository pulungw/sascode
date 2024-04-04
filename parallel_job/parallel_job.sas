options mprint mlogic symbolgen fullstimer;
options sascmd="C:\Program Files\SASHome\SASFoundation\9.4\sas.exe -nosyntaxcheck" autosignon;

%macro exec_para(NPID, NTHREADS);

/* loop through number of process ID */
%do i = 1 %to &NPID.;

	/* set path to root program folder */
	%let PATH = C:\code\sascode\parallel_job;

	/* send macro variable to sub-process */
	%syslput PID = pid_&i. / remote = pid_&i.;
	%syslput PATH = &PATH. / remote = pid_&i.;
	%syslput NTHREADS = &NTHREADS. / remote = pid_&i.;

	/* execute parallel job through rsubmit */
	rsubmit pid_&i. wait=no;
		options mprint mlogic symbolgen fullstimer;
		libname xdata "&PATH.\data";

		proc hpforest data=xdata.hmeq_100k;
			performance nthreads=&NTHREADS.;
			target BAD / level=nominal;
			input CLAGE CLNO DEBTINC LOAN MORTDUE YOJ VALUE / level=interval;
			input DELINQ DEROG JOB NINQ REASON / level=nominal;
			save file="&PATH.\model\model_&PID..bin";
			savestate file="&PATH.\model\model_&PID..sasast";
			ods output FitStatistics=xdata.FITSTAT_&PID. VariableImportance=xdata.VARIMP_&PID.;
		run;

		proc astore;
			score data=xdata.hmeq_5m
				copyvars=(_ALL_)
				store="&PATH.\model\model_&PID..sasast"
				out=xdata.hmeq_scored_&PID.
			;
		run;

		/* sleep to extend execution time */
		/* data _null_;
			call sleep(600000);
		run; */

	endrsubmit;
%end;

/* synchronization point wait through all process id */
waitfor _all_
	%do i = 1 %to &NPID.;
		pid_&i.
	%end;
;

/* signoff from remote submit */
%do i = 1 %to &NPID.;
	signoff pid_&i.;
%end;

%mend;

%exec_para(NPID=1, NTHREADS=4);

