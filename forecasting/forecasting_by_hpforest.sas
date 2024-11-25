%let MAX_LAG = 12;

%macro create_lagged();
data work.train;
    set sashelp.air;

    %do i=1 %to &MAX_LAG. %by 1;
        lag_&i. = lag&i.(air);
    %end;
run;
%mend;

%create_lagged();

data work.train_part;
    length Part $10.;
    set work.train;
    if date >= "01JAN1960"d then Part = "1:TEST";
    else Part = "0:TRAIN";
run;

proc hpforest data=work.train_part(where=(Part="0:TRAIN")) importance=yes seed=10;
    target air / level=interval;
    input lag: / level=interval;
    savestate file="C:\temp\model.sasast";

    ods output FitStatistics=work.RF_FITSTAT VariableImportance=work.RF_VARIMP;
    performance details;
run;

proc sgplot data=work.RF_FITSTAT;
	series x=NTrees y=PredAll;
	series x=NTrees y=PredOOB;
	yaxis label="Average Square Error (ASE)";
run;

proc astore;
	score data=work.train_part copyvars=(_ALL_)
		store="C:\temp\model.sasast"
		out=work.scored
	;
run;

proc sgplot data=work.scored;
    scatter x=date y=air;
    series x=date y=P_AIR;
    refline "01JAN1960"d / axis=x;
run;

data work.error;
    set work.scored(rename=(AIR=actual P_AIR=predict));
    error = actual - predict;
    sq_error = error**2;
    ape = abs(error / actual);
run;

proc sql;
    select 
        Part,
        sqrt(avg(sq_error)) as RMSE,
        avg(ape) as MAPE format=percent10.1
    from work.error
    group by Part
    order by Part
    ;
quit;