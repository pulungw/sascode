options mprint mlogic symbolgen fullstimer;
cas;
caslib _all_ assign;

%let vars_interval = LOAN MORTDUE VALUE YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC;
%Let vars_nominal = REASON JOB;
%let target = BAD;

data casuser.train;
	set sampsio.hmeq;
run;

proc idgeneration data=casuser.train;
   output out=casuser.train_id id=xid;
run;

proc forest data=casuser.train_id isolation seed=12345;
   input &VARS_INTERVAL. / level=interval;
   input &VARS_NOMINAL. / level=nominal;
   id xid;
   output out=casuser.score copyvars=(_ALL_);
run;