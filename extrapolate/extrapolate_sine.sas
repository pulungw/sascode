cas;
caslib _all_ assign;

options locale=en_US;

data _null_;
    pi = constant('pi');
    call symput("PI_VALUE",pi);
run;
%put &=PI_VALUE;


/***
Train Data
***/
data casuser.input;
    call streaminit(12345);
    do i=1 to 5000;
        x = rand("uniform",0,1000);
        e = rand("normal");
        output;
    end;
    drop i;
run;

data casuser.train;
    set casuser.input;
    y = 200*sin(0.035*x) + 50*e;
run;

proc sgplot data=casuser.train noautolegend;
	title "Training Data ";
    scatter x=x y=y / markerattrs=(symbol=circlefilled size=10 color=blue) transparency=0.7;
    /* lineparm x=0 y=0 slope=&PI_VALUE. / lineattrs=(thickness=3 color=red pattern=solid); */
	refline 1000 / axis=x lineattrs=(pattern=dash);
    xaxis max=1500;
run;


/***
Test Data
***/
data casuser.input;
    call streaminit(12345);
    do i=1 to 5000;
        x = rand("uniform",0,1500);
        e = rand("normal");
        output;
    end;
    drop i;
run;

data casuser.test;
    set casuser.input;
    y = 200*sin(0.035*x) + 50*e;
run;

proc sgplot data=casuser.test noautolegend;
    scatter x=x y=y / markerattrs=(symbol=circlefilled size=10) transparency=0.7;
    /* lineparm x=0 y=0 slope=&PI_VALUE. / lineattrs=(thickness=3 color=red pattern=shortdash); */
	refline 1000 / axis=x lineattrs=(pattern=dash);
run;


/***
Assess Macro Definition
***/
%macro assess(MODEL_NAME, GRAPH_TITLE);
proc astore;
	score data=casuser.test copyvars=(_ALL_) 
		rstore=casuser.model_&MODEL_NAME. out=casuser.scored_&MODEL_NAME.
	;
run;

ods graphics / noborder;

proc sgplot data=casuser.scored_&MODEL_NAME. noautolegend;
	title "&GRAPH_TITLE.";
    scatter x=x y=y / markerattrs=(symbol=circlefilled size=10) transparency=0.7;
    series x=x y=P_y / lineattrs=(thickness=4 color=orange pattern=solid);
	refline 1000 / axis=x lineattrs=(pattern=dash);
run;
%mend;


/***
Linear Regression
***/
proc regselect data=casuser.train;
    model y = x;
    store out=casuser.model_reg;
run;


/***
Gradient Boosting
****/
proc gradboost data=casuser.train;
    target y / level=interval;
    input x / level=interval;
    savestate rstore=casuser.model_gb;
	ods output FitStatistics=work.GB_FITSTAT VariableImportance=work.GB_VARIMP;
run;


/***
Neural Network
***/

proc nnet data=casuser.train;
	architecture mlp;
	target y / level=interval;
	input x / level=interval;
	hidden 64;
	hidden 64;
	hidden 64;

	optimization algorithm=lbfgs maxiter=100;
	train outmodel=casuser.nnet_outmodel seed=123;
	savestate rstore=casuser.model_nnet;
	ods output OptIterHistory=iterhist;
run;


/***
Random Forest
****/
proc forest data=casuser.train;
    target y / level=interval;
    input x / level=interval;
    savestate rstore=casuser.model_forest;
	ods output FitStatistics=work.RF_FITSTAT VariableImportance=work.RF_VARIMP;
run;

/***
Decision Tree
****/
proc treesplit data=casuser.train;
    target y / level=interval;
    input x / level=interval;
    savestate rstore=casuser.model_tree;
run;


/***
Support Vector Machine
****/
proc svmachine data=casuser.train;
    target y / level=interval;
    input x / level=interval;
    savestate rstore=casuser.model_svm;
run;


/***
Non-Linear Regression
***/
proc regselect data=casuser.train;
    model y = x*x x;
    store out=casuser.model_reg_nonlinear;
run;




%assess(reg, Linear Regression);
%assess(gb, Gradient Boosting);
%assess(nnet, Neural Network);
%assess(forest, Random Forest);
%assess(tree, Decision Tree);
%assess(svm, Support Vector Machine);
%assess(reg_nonlinear, Non-Linear Regression);


