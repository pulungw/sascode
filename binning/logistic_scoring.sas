data work.x1;
	input beta var;
	datalines;
0.1 3
0.2 .
0.4 7
0.5 9
;
run;

data work.x2;
	set work.x1;
	_linp_ = 0;
/*	do _i_=1 to 9;*/
		_linp_ + beta * var;
/*	end;*/
run;

data work.x3;
	set work.x2;
  if (_linp_ > 0) then do;
     P_BAD1 = 1 / (1+exp(-_linp_));
  end; else do;
     P_BAD1 = exp(_linp_) / (1+exp(_linp_));
  end;
run;