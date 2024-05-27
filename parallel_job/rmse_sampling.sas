options mprint mlogic symbolgen fullstimer;
%let PATH = C:\code\sascode\parallel_job;
libname xdata "&PATH.\data";

%let input_vars= 
jet_1_eta
jet_1_pt
jet_1_phi
jet_2_eta
jet_2_pt
jet_2_phi
jet_3_eta
jet_3_pt
jet_3_phi
jet_4_eta
jet_4_pt
jet_4_phi
;

%let target_var=
missing_energy_magnitude
;

proc contents data=xdata.higgs_test;
run;

proc surveyselect data=xdata.higgs_test out=xdata.higgs_10k n=10000 method=srs seed=10;
run;

%macro exec_hpforest(DS);
proc hpforest data=xdata.&DS. maxtrees=50 maxdepth=50 seed=10 importance=yes;
/*	performance nthreads=&NTHREADS. details;*/
	target &target_var. / level=interval;
	input &input_vars. / level=interval;
	savestate file="&PATH.\model\M999.sasast";
	ods output FitStatistics=xdata.FITSTAT VariableImportance=xdata.VARIMP;
run;
%mend;

%exec_hpforest(higgs_10k);














%macro exec_astore(DS, SAMPLING_NUM);

/*** Base data for RMSE result ***/
data xdata.base_&SAMPLING_NUM.;
	length MODEL_ID $4 SAMPLING_NUM 8 LOOP_ID 8 RMSE 8;
	stop;
run;

%do LOOP_ID=1 %to &LOOP_NUM.;

	/*** Sampling without replacement ***/
	proc surveyselect 
		data=xdata.&DS. 
		out=work.sampled 
		N=&SAMPLING_NUM. 
		method=srs
		;
	run;

	/*** Scoring with ASTORE ***/
	proc astore;
		score data=work.sampled
	/*		copyvars=(_ALL_)*/
			copyvars=(missing_energy_magnitude)
			store="&PATH.\model\M999.sasast"
			out=xdata.scored
		;
	run;

	/*** Calculate RMSE per loop ***/
	data work.rmse_temp;
		set xdata.scored(rename=(missing_energy_magnitude=actual P_missing_energy_magnitude=pred));
		sq_error = (actual - pred)**2;
		MODEL_ID = "M999";
	run;

	proc sql;
		create table work.rmse_model as
		select 
			MODEL_ID as MODEL_ID,
			&SAMPLING_NUM. as SAMPLING_NUM,
			&LOOP_ID. as LOOP_ID,
			sqrt(mean(sq_error)) as RMSE
		from work.rmse_temp
		group by MODEL_ID
		;
	quit;

	/*** Append RMSE per loop to the whole result ***/
	proc append base=xdata.base_&SAMPLING_NUM. data=work.rmse_model;
	run;
%end;

%mend;

%let LOOP_NUM=10;
%exec_astore(higgs_test, 1000)
%exec_astore(higgs_test, 2000)
%exec_astore(higgs_test, 3000)
%exec_astore(higgs_test, 4000)
%exec_astore(higgs_test, 5000)
%exec_astore(higgs_test, 6000)
%exec_astore(higgs_test, 7000)
%exec_astore(higgs_test, 8000)
%exec_astore(higgs_test, 9000)
%exec_astore(higgs_test, 10000)

/*** Combine all rmse result per sampling num ***/
data xdata.rmse_base_all;
	set xdata.base_:;
run;

proc sort data=xdata.rmse_base_all;
	by MODEL_ID SAMPLING_NUM LOOP_ID;
run;

/*** Calculate RMSE statistics ***/
proc summary data=xdata.rmse_base_all;
	var RMSE;
	by MODEL_ID SAMPLING_NUM;
	output out=work.RMSE_ALL_TEMP;
run;

proc transpose data=work.RMSE_ALL_TEMP out=xdata.RMSE_RESULT;
	id _STAT_;
	var RMSE;
	by MODEL_ID SAMPLING_NUM;
run;