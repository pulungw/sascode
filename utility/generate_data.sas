%let NUM_SAMP = 5000;

/***
Normal distribution seed
***/
%macro generate_seed(seednum);
data work.seed;
    call streaminit(&seednum.);
    do i=1 to &NUM_SAMP.;
        x1 = rand("normal");
        x2 = rand("normal");
        x3 = rand("normal");
        x4 = rand("uniform");
        x5 = rand("uniform");
        e = rand("normal");
        output;
    end;
    drop i;
run;
%mend;

%generate_seed(10);
data work.data_v1;
    set work.seed;
    y = 2*x1 + 5*x2 + 10*x3 + e;
run;

%generate_seed(42);
data work.data_v2;
    set work.seed;
    y = 2*x1 + 5*x2 + 10*x3 + e;
run;

%generate_seed(10);
data work.data_v3;
    set work.seed;
    y = 2.5*x1 + 5.5*x2 + 10.5*x3 + e;
run;
