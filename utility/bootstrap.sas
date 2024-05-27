
data work.x1;
	do i=1 to 10000;
		x=i;
		output;
	end;
run;


%macro bootstrap;

proc surveyselect data=work.x1 out=work.x2 
	method=urs samprate=1 outhits;
run;

proc sql;
	select count(distinct i) as uniq_cnt from work.x2;
quit;

%mend;

%bootstrap;
%bootstrap;
%bootstrap;
%bootstrap;
%bootstrap;