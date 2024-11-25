%let NUM_SAMP = 600;
%let start_date = 31DEC2022;
%let rand_dev = 1;
%let init_val = 25;
%let shift_val = 10;

%macro generate_data();

data work.seed;
    length MOVE_DATE 8. TRAIN_NO $4. TOGO_0 8.;
    format MOVE_DATE YYMMDD10.;

    call streaminit(10);
    %do i=1 %to &NUM_SAMP.;
        MOVE_DATE = intnx('day', "&start_date."d, &i.);
        TRAIN_NO = "0100";
        TOGO_0 = rand("normal")*&rand_dev. + &init_val.;
        output;
    %end;

    call streaminit(11);
    %do i=1 %to &NUM_SAMP.;
        MOVE_DATE = intnx('day', "&start_date."d, &i.);
        TRAIN_NO = "0200"; 
        TOGO_0 = rand("normal")*&rand_dev. + &init_val.;
        output;
    %end;

    call streaminit(12);
    %do i=1 %to &NUM_SAMP.;
        MOVE_DATE = intnx('day', "&start_date."d, &i.);
        TRAIN_NO = "0300";
        TOGO_0 = rand("normal")*&rand_dev. + &init_val.;
        output;
    %end;

    call streaminit(13);
    %do i=1 %to &NUM_SAMP.;
        MOVE_DATE = intnx('day', "&start_date."d, &i.);
        TRAIN_NO = "0400";
        TOGO_0 = rand("normal")*&rand_dev. + &init_val.;
        output;
    %end;
run;

data work.x1;
    set work.seed;
    if MOVE_DATE > "01JAN2024"d then do;
        TOGO_0 = TOGO_0 + &shift_val.;
    end;
run;

%mend;

%generate_data();

proc sql;
    create table work.x2 as
    select 
           TRAIN_NO,
           MOVE_DATE,
           avg(TOGO_0) as avg_TOGO_0
    from work.x1
    group by TRAIN_NO, MOVE_DATE
    order by TRAIN_NO, MOVE_DATE
    ;
quit;

proc sql;
    create table work.x3 as
    select
        MOVE_DATE,
        avg(avg_TOGO_0) as avg_TOGO_0,
        std(avg_TOGO_0) as std_TOGO_0
    from work.x2
    group by MOVE_DATE
    order by MOVE_DATE
    ;
quit;

data work.x4;
    set work.x3;
    _LB_ = avg_TOGO_0 - 1.96*std_TOGO_0;
    _UB_ = avg_TOGO_0 + 1.96*std_TOGO_0;
run;

proc sgplot data=work.x4;
    band x=MOVE_DATE lower=_LB_ upper=_UB_ / transparency=0.3 legendlabel="95% interval";
    series x=MOVE_DATE y=avg_TOGO_0;
run;


proc expand data=work.x4 out=work.x5 from=day to=month;
    convert avg_TOGO_0 / observed=average;
    id MOVE_DATE;
run;