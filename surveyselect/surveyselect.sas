proc surveyselect
    data = sashelp.cars
    seed = 1234
    method=srs
    sampsize=12
    out= work.carsample12
    ;
run;


/* data payroll;
    time_slept=sleep(3,1);
    set sashelp.cars;
 run; */