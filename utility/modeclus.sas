title 'Modeclus Example with Univariate Distributions';
title2 'Uniform Distribution';

data uniform;
   drop n;
   true=1;
   do n=1 to 100;
      x=ranuni(123);
      output;
   end;
run;

proc modeclus data=uniform m=1 k=10 20 40 60 out=out short;
   var x;
run;

proc sgplot data=out /*noautolegend*/;
   y2axis label='True' values=(0 to 2 by 1.);
   yaxis values=(0 to 3 by 0.5);
   scatter y=density x=x / /*markerchar=cluster*/ group=cluster;
   pbspline y=true x=x / y2axis nomarkers lineattrs=(thickness= 1);
   by _K_;
run;

proc modeclus data=uniform m=1 r=.05 .10 .20 .30 out=out short;
   var x;
run;

proc sgplot data=out /*noautolegend*/;
   y2axis label='True' values=(0 to 2 by 1.);
   yaxis values=(0 to 2 by 0.5);
   scatter y=density x=x / /*markerchar=cluster*/ group=cluster;
   pbspline y=true x=x / y2axis nomarkers lineattrs=(thickness= 1);
   by _R_;
run;


data test;
   drop n;
   true=1;
   do n=1 to 100;
      x=ranuni(123);
	  y=ranuni(456);
	  z=0.5;
      output;
   end;
run;

proc modeclus data=test method=1 Neighbor out=out;
/* 	var x y; */
	var z;
run;

proc sgplot data=out /*noautolegend*/;
   y2axis label='True' values=(0 to 2 by 1.);
   yaxis values=(0 to 3 by 0.5);
   scatter y=density x=x / /*markerchar=cluster*/ group=cluster;
   pbspline y=true x=x / y2axis nomarkers lineattrs=(thickness= 1);
   by _R_;
run;