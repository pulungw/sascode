libname xdata "C:\code\sascode\parallel_job\data";

/*data xdata.hmeq_100k;*/
/*	set */
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*	;*/
/*run;*/
/**/
/*data xdata.hmeq_50k;*/
/*	set */
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*		xdata.hmeq*/
/*	;*/
/*run;*/
/**/
/*data xdata.hmeq_1000k;*/
/*	set */
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*xdata.hmeq_100k*/
/*	;*/
/*run;*/


data xdata.hmeq_10m;
	set
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
xdata.hmeq_1000k
	;
run;

proc options;
run;

proc contents data=xdata.hmeq_10m;
run;

data xdata.hmeq_1m;
	set 
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_5m;
	set
xdata.hmeq_1m
xdata.hmeq_1m
xdata.hmeq_1m
xdata.hmeq_1m
xdata.hmeq_1m
	;
run;


data xdata.hmeq_2m;
	set
xdata.hmeq_1m
xdata.hmeq_1m
	;
run;

data xdata.hmeq_3m;
	set
xdata.hmeq_2m
xdata.hmeq_1m
	;
run;

data xdata.hmeq_4m;
	set
xdata.hmeq_2m
xdata.hmeq_2m
	;
run;

data xdata.hmeq_6m;
	set
xdata.hmeq_3m
xdata.hmeq_3m
	;
run;

data xdata.hmeq_7m;
	set
xdata.hmeq_6m
xdata.hmeq_1m
	;
run;

data xdata.hmeq_8m;
	set
xdata.hmeq_7m
xdata.hmeq_1m
	;
run;

data xdata.hmeq_9m;
	set
xdata.hmeq_8m
xdata.hmeq_1m
	;
run;



data xdata.hmeq_200k;
	set
xdata.hmeq_100k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_300k;
	set
xdata.hmeq_200k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_400k;
	set
xdata.hmeq_300k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_500k;
	set
xdata.hmeq_400k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_600k;
	set
xdata.hmeq_500k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_700k;
	set
xdata.hmeq_600k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_800k;
	set
xdata.hmeq_700k
xdata.hmeq_100k
	;
run;

data xdata.hmeq_900k;
	set
xdata.hmeq_800k
xdata.hmeq_100k
	;
run;



data xdata.hmeq_12m;
	set
xdata.hmeq_10m
xdata.hmeq_2m
	;
run;

data xdata.hmeq_14m;
	set
xdata.hmeq_12m
xdata.hmeq_2m
	;
run;

data xdata.hmeq_16m;
	set
xdata.hmeq_14m
xdata.hmeq_2m
	;
run;

data xdata.hmeq_18m;
	set
xdata.hmeq_16m
xdata.hmeq_2m
	;
run;

data xdata.hmeq_20m;
	set
xdata.hmeq_18m
xdata.hmeq_2m
	;
run;