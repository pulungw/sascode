option locale=en_us;
option cashost="sas-cas-server-default-client" casport=5570;

cas;
caslib _all_ assign;

ods graphics on;

data casuser.hmeq;
	set sampsio.hmeq;
run;

proc partition data=casuser.hmeq partind samppct=30 samppct2=10 seed=12345;
	output out=casuser.hmeq_part;
run;

proc contents data=casuser.hmeq_part;
run;

proc surveyselect data=sampsio.hmeq out=work.hmeq_samp n=100;
run;

proc corr data=work.hmeq_samp plots=matrix(histogram);
	var debtinc delinq loan value;
run;

proc gradboost data=casuser.hmeq_part outmodel=casuser.gradboost_model seed=12345;
	input debtinc delinq loan value / level = interval;
	input job reason / level=nominal; 
	target bad / level=nominal;
	partition role=_partInd_(TRAIN='0' VALIDATE='1' TEST='2');
	output out=casuser.hmeq_out copyvars=(_partind_ bad);; 
	ods output FitStatistics=fitstat VariableImportance=varimp;
	savestate rstore=casuser.gradboost_astore;
run;