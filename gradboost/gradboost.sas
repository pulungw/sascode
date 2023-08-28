/* option locale=en_us; */
/* option cashost="sas-cas-server-default-client" casport=5570; */

/* ods html5 style=Illuminate; */

/***
proc setinit;
run;
***/

cas;
caslib _all_ assign;

data casuser.hmeq;
	set sampsio.hmeq;
run;

proc partition data=casuser.hmeq partind samppct=30 samppct2=10 seed=12345;
	output out=casuser.hmeq_part;
run;

proc contents data=casuser.hmeq_part;
run;

proc gradboost data=casuser.hmeq_part outmodel=casuser.gradboost_model seed=12345 /*applyroworder*/;
	input clage clno delinq derog loan mortdue ninq value yoj / level = interval;
	input debtinc / level=interval monotonic=decreasing;
	input job reason / level=nominal; 
	target bad / level=nominal;
	partition role=_partInd_(TRAIN='0' VALIDATE='1' TEST='2');
	autotune;
	output out=casuser.hmeq_out copyvars=(_partind_ bad);; 
	ods output FitStatistics=fitstat VariableImportance=varimp;
	savestate rstore=casuser.gradboost_astore;
run;

proc assess data=casuser.hmeq_out nbins=10;
	input p_bad1;
	target bad / level=nominal event='1';
	fitstat pvar=P_bad0 / pevent='0';
	by _partind_;

	ods output 
		fitstat=work._fitstat
        rocinfo=work._rocinfo
        liftinfo=work._liftinfo
	;
run;

proc sgplot data=varimp;
	hbar variable / response=RelativeImportance;
	yaxis discreteorder=data;
run;

proc sgplot data=fitstat;
	series x=trees y=misctrain;
	series x=trees y=miscvalid;
	series x=trees y=misctest;
run;

proc sgplot data=fitstat;
	series x=trees y=loglosstrain;
	series x=trees y=loglossvalid;
	series x=trees y=loglosstest;
run;

proc cas;
action explainModel.partialDependence  result = pd_res  /
	table            = {caslib="casuser", name = "hmeq_part"},
	modelTable       = "gradboost_astore",
	inputs           = {"job" "reason" "clage" "clno" "debtinc" "delinq" "derog" "loan" "mortdue" "ninq" "value" "yoj"}
    predictedTarget  = "P_Bad1",
    analysisVariable = {name="DebtInc" nbins = 100}
	samplesize		 = 5000
    outputTables     = {includeAll = true, replace = true},
    output           = {casout={name="ICEOut", replace = true}
/*                             copyvars = {"_ID_"} */
					   },
    seed             = 1234
    ;
    print pd_res;
run;
quit;

proc sgplot data=casuser.partialdependence;
	series x=debtinc y=meanPrediction;
	yaxis min=0 max=1;
run;
	