%macro sim(NUM_SIM);

data x1;
    call streaminit(12345);
    do i=1 to &NUM_SIM.;
        x = rand("uniform");
        y = rand("uniform");
        c = sqrt(x**2 + y**2);
        output;
    end;
run;

data x2;
    set x1;
    if c <= 1 then do;
        circle_flg = 1;
    end;
    else do;
        circle_flg = 0;
    end;
run;

proc sql;
    create table x3 as
    select
        count(*) as area_square,
        sum(circle_flg) as area_circle
    from x2
    ;
quit;

data x4;
    set x3;
    pi = (area_circle / area_square) * 4;
run;

proc append base=base data=x4;
run;

%mend;


%macro plot(NUM_SIM);
    title "N=&NUM_SIM.";
    proc sgplot data=x2 aspect=1.0 noautolegend noborder;
        scatter x=x y=y / group=circle_flg markerattrs=(symbol=circlefilled size=5) transparency=0.5;
    run;
    title;
%mend;



data base;
    length area_square 8. area_circle 8. pi 8.;
    stop;
run;

%macro exec_sim();
    %do i=100  %to 100000 %by 100;
        %put i is &i.;
        %sim(&i.);

/*        %if %sysfunc(mod(&i.,10000)) eq 0 %then %do;*/
/*            %plot(&i.);*/
/*        %end;*/
    %end;   
%mend;

%exec_sim();

proc sgplot data=base;
    series x=area_square y=pi;
run;