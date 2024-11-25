ods graphics on;

data work.train;
    set sashelp.air;
run;

proc sgplot data=work.train;
    series x=date y=air / lineattrs=(thickness=2);
run;

proc timeseries data=work.train
            out=_NULL_ 
            outdecomp = decomp
            plot=(decomp);
    id date interval=month;
    var air;
run;

proc hpfdiagnose data=work.train
                 repository=work.repository
                 outest=est;
   id date interval=month;
   forecast air;
run;

proc hpfengine data=work.train
               inest=est outest=outest
               repository=work.repository
               print=(select estimates summary statistics)
               plot=forecasts
               lead=12
               back=12
               outfor=outfor
    ;
   id date interval=month;
   forecast air;
run;

data work.outfor_part;
    length Part $10.;
    set work.outfor;
    if date >= "01JAN1960"d then Part = "1:TEST";
    else Part = "0:TRAIN";
run;

data work.error;
    set work.outfor_part;
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