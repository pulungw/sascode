libname viewtst "C:\code\data\view";
libname futurum "C:\code\data\futurum";

data viewtst.class / view=viewtst.class;
	set sashelp.class;
run;

data viewtst.higgs10k / view=viewtst.higgs10k;
	set futurum.higgs10k_1 futurum.higgs10k_2 futurum.higgs10k_3;
run;

proc contents data=viewtst.higgs10k;
run;

data work.x1;
	a=1;
run;

data work.x2;
	a=2;
run;

data work.x3;
	a=3;
run;

proc datasets lib=work nolist nowarn;
	delete x:;
run;

proc datasets lib=viewtst nolist;
	delete higgs10k: (memtype=view) ;
run;