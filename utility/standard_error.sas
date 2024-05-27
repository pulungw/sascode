data a;
  input x y;
  datalines;
1.47 52.21
1.50 53.12
1.52 54.48
1.55 55.84
1.57 57.20
1.60 58.57
1.63 59.93
1.65 61.29
1.68 63.11
1.70 64.47
1.73 66.28
1.75 68.10
1.78 69.92
1.80 72.19
1.83 74.46
;

title;
proc sgplot data=a;
	scatter X=x Y=y;
run;

/*  obtain parameter estimates */
proc reg data=a;
  model y=x;
run;
quit;

/*  obtain mean of x */
proc means data=a mean;
  var x y;
run;

/* compute squared errors and squared, mean-corrected values of X */
data se;  
	set a;
	SEBeta1= (Y - (-39.06196 + 61.27219*X))**2;
	sumXsq=(X-(1.6506667))**2;
	*StanErr=(SEBeta1/(23))/(sumXsq**.5);
run;

proc print data=se;
run;

/*  compute sum of squared errors and sum of squared, corrected X values */
proc means data=se noprint;
	title "standard error for t test here called StanErr";
	var SEBeta1 sumXsq;
	output out=out sum= ;
run;

/*  compute the standard error of the estimate of Beta */
data calc;
	set out;
	stanErr=sqrt( ( sebeta1 / ( (_freq_-2) * sumxsq ) ) );
run;

proc print data=calc;
run;