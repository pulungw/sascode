cas;
caslib _all_ assign;

data casuser.hmeq;
	set sampsio.hmeq;
	keep BAD LOAN MORTDUE VALUE YOJ DEROG;
run;

proc cas;
	loadactionset "smote";
	action smoteSample result=r/
		table={name="hmeq"}
 		classColumn="BAD"
 		classToAugment=1
 		seed=10
 		numSamples=1000,
 		casout={name="out3",replace="TRUE"}
 	;
run;