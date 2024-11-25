/* options mprint mlogic symbolgen fullstimer;

cas casauto sessopts=(metrics=true);
caslib _all_ assign; */

%let vars_interval = LOAN MORTDUE VALUE YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC;
%Let vars_nominal = REASON JOB;
%let target = BAD;

/* data casuser.train;
	set sampsio.hmeq;
run; */

data train;
	set sampsio.hmeq;
run;

/*** Autoencoder training code ***/
proc nnet data=train standardize=range missing=mean;
	architecture mlp;
	input &vars_interval. / level=interval;
	hidden 64;

	optimization algorithm=lbfgs maxiter=100;
	train outmodel=model seed=123;
	partition fraction(validate=0.2 seed=123);
	ods output OptIterHistory=iterhist;
run;

proc sgplot data=iterhist;
	series x=Progress y=Loss;
	series x=Progress y=ValidError;
run;

/*** Autoencoder scoring code - get INPUT LAYER ***/
proc nnet data=casuser.train inmodel=casuser.model listnode=input;
	score out=casuser.scored_input copyvars=(&vars_interval.);
run;

/*** Autoencoder scoring code - get HIDDEN LAYER ***/
proc nnet data=casuser.train inmodel=casuser.model listnode=hidden;
	score out=casuser.scored_hidden copyvars=(&vars_interval.);
run;

/*** Autoencoder scoring code - get OUTPUT LAYER ***/
proc nnet data=casuser.train inmodel=casuser.model listnode=output;
	score out=casuser.scored_output copyvars=(&vars_interval.);
run;