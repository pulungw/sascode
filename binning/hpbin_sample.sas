libname em_res "C:\code\em_project\binning\Workspaces\EMWS2";

data work.hmeq;
	set sampsio.hmeq;
run;

proc contents data=work.hmeq;
run;

proc hpbin data=work.hmeq output=work.hmeq_bin numbin=10 quantile woe;
	input CLAGE CLNO DEBTINC DELINQ DEROG LOAN MORTDUE NINQ VALUE YOJ;
	target BAD;
RUN;
	