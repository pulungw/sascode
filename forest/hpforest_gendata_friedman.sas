data work.seed;
    call streaminit(12345);
    do i=1 to 5000;
        x1 = rand("uniform");
        x2 = rand("uniform");
        x3 = rand("uniform");
        x4 = rand("uniform");
        x5 = rand("uniform");
        e = rand("normal");
        output;
    end;
    drop i;
run;

data work.train;
    set work.seed;
    pi = constant('pi');
    y = 10*sin(pi*x1*x2) + 20*((x3 - 0.5)**2) + 10*x4 + 5*x5 + e;
    drop pi;
run;

proc sgplot data=work.train;
    histogram y / fillattrs=(color=cx0766D1);
run;

proc hpforest data=work.train maxtrees=100 maxdepth=20 seed=10 importance=yes;
	target y / level=interval;
	input x1 x2 x3 x4 x5 / level=interval;
	ods output FitStatistics=work.RF_FITSTAT VariableImportance=work.RF_VARIMP;
	performance details;
run;

proc sgplot data=work.RF_FITSTAT;
    series y=PredOob x=NTrees;
    series y=PredAll x=NTrees;
run;