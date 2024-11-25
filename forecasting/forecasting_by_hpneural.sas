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

proc hpneural data=work.train_part(where=(Part="0:TRAIN"));
   id date;
   input lag:;
   target air / level=int;
   hidden 32;
   hidden 32;
   hidden 32;
   train outmodel=model_neural maxiter=1000;
   ods output Iteration=work.Iteration;
run;

proc sgplot data=work.Iteration;
	series x=IterationNum y=TrainingError;
	series x=IterationNum y=ValidationError;
	yaxis label="Error";
run;

proc hpneural data=work.train_part;
   id date air Part;
   score out=scored model=model_neural;
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