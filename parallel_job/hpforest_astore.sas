/*** Training code ***/
proc hpforest data=TEMP1_JS.TMPMODEL_M012_TRAIN maxtrees=50 maxdepth=50 seed=10 importance=yes;
	target TOGO_0 / level=interval;
	input ACTUAL HATSU_HOUR LAG_3 LAG_6 LAG_9 RELATIVE_DAY WARIRITSU / level=interval;
	input DAY_OF_WEEK JOUSHA_GROUP_EKI KOUSHA_GROUP_EKI MOVE_MONTH SET_PATTERN SHOHIN_CD / level=nominal;
	savestate file="F:\SAS_TRAIN\library\temp1\temp_models\M012.sasast";
	ods _all_ close;
	ods output FitStatistics=xdata.FITSTAT_M012 VariableImportance=VARIMP_M012;
	performance nthreads = 4;
run;


/*** Scoring code ***/
proc astore;
	score data=TEMP1_JS.TMPVALID_M012 copyvars=(_ALL_)
		store="F:\SAS_TRAIN\library\archive\models\M012.sasast"
		out=TEMP1_JS.TMPVALID_M012
	;
run;



/*** Scoring code ***/
proc astore;
	score data=TEMP1_JS.TMPVALID_M012 copyvars=(TOGO_0 MODEL_ID)
		store="F:\SAS_TRAIN\library\archive\models\M012.sasast"
		out=TEMP1_JS.TMPVALID_M012
	;
run;

