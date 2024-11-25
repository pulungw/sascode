%let vars_interval = 
    area1 area2 area3 
    compactness1 compactness2 compactness3 
    concave_points1 concave_points2 concave_points3 
    concavity1 concavity2 concavity3 
    fractal_dimension1 fractal_dimension2 fractal_dimension3 
    perimeter1 perimeter2 perimeter3 
    radius1 radius2 radius3 
    smoothness1 smoothness2 smoothness3 
    symmetry1 symmetry2 symmetry3 
    texture1 texture2 texture3
    ;
%let target = diagnosis;

/*** Import dataset ***/
proc import datafile="&WORKSPACE_PATH./data/breast_cancer.csv"
   out=breast_cancer
   dbms=csv
   replace;
run;

/*** Create ID ***/
data train;
    length id 8;
    set breast_cancer;
    id = _N_;
run;

/*** Autoencoder training code ***/
proc nnet data=train standardize=range missing=mean;
	architecture mlp;
	input &vars_interval. / level=interval;
	hidden 64;

	optimization algorithm=lbfgs maxiter=100;
	train outmodel=model_autoenc seed=123;
	partition fraction(validate=0.2 seed=123);
	ods output OptIterHistory=iterhist;
run;

proc sgplot data=iterhist;
	series x=Progress y=Loss;
	series x=Progress y=ValidError;
run;

/*** Autoencoder scoring code - get INPUT LAYER ***/
proc nnet data=train inmodel=model_autoenc listnode=input;
	score out=scored_input copyvars=(id);
run;

title2 "Input Layer";
proc print data=scored_input(obs=10);
run;
title2;

/*** Autoencoder scoring code - get HIDDEN LAYER ***/
proc nnet data=train inmodel=model_autoenc listnode=hidden;
	score out=scored_hidden copyvars=(id);
run;

title2 "Hidden Layer";
proc print data=scored_hidden(obs=10);
run;
title2;

/*** Autoencoder scoring code - get OUTPUT LAYER ***/
proc nnet data=train inmodel=model_autoenc listnode=output;
	score out=scored_output copyvars=(id);
run;

title2 "Output Layer";
proc print data=scored_output(obs=10);
run;
title2;
