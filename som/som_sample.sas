options norsasiotranserror;
options msglevel=i;
options locale=en_US;
options compress=yes;
options casdatalimit=ALL;
options mprint mlogic symbolgen;


/***
Create test data
***/
data work.customer_data;
	length 
		customer_id $6. 
		gender $1. 
		age sweet sour salt morning noon evening 8
	;
	do i = 1 to 10000;
		customer_id = cat("C",put(i,z5.));

		if round(ranuni(42), 1) = 1 then gender = "M";
		else gender = "F";

		age = round(rand("NORMAL", 42, 10));
		sweet = rand("UNIFORM")*0.5;
		sour = rand("UNIFORM")*0.5;
		salt = abs(1 - sweet - sour);
		morning = rand("UNIFORM")*0.5;
		noon = rand("UNIFORM")*0.5;
		evening = abs(1 - morning - noon);

		output;
	end;
	drop i;
run;



/*** 
SOM Training macro
***/
%macro execute_som(input_dataset, output_dataset, id_var, interval_var, nominal_var, rows, cols);
	proc dmdb batch data=&input_dataset out=work.dmdb_out dmdbcat=work.dmdb_cat normlen=32 maxlevel=10000;
		id &id_var.;
		var &interval_var.; 
		class &nominal_var.;
	run;

	options nodate;

	proc dmvq data=&input_dataset dmdbcat=work.dmdb_cat std=std;
		input &interval_var / level=interval;
		input &nominal_var / level=nominal;

		som
			rows=&rows cols=&cols
			rowname=SOM_DIMENSION1 rowlabel="SOM DIM1"
			colname=SOM_DIMENSION2 collabel="SOM DIM2"
			somname=SOM_ID somlabel="SOM ID"
			clusname=SOM_SEGMENT cluslabel="SOM Segment"
		;
		initial radius=0 princomp;
		train
			tech=nwsom
			kmetric=2
			neighinitial=%eval(%sysfunc(max(&rows,&cols))/2)
			maxiter=200
			out=&output_dataset.

			/* Used for graphing the clustering process. (Debugging, presenting) */
			outseed=som_seed
			seediter=1
		; 
		save outstat=som_stat;
	run;
%mend;


%let id_var=customer_id;
%let interval_var=age sweet sour salt morning noon evening;
%let nominal_var=gender;

%let som_variables=age sweet sour salt morning noon evening genderF genderM;
%let som_dataset=work.som_stat;

%let rows=10;
%let cols=10;

%execute_som (
	input_dataset=customer_data,
	output_dataset=som_data,
	id_var=&id_var.,
	interval_var=&interval_var.,
	nominal_var=&nominal_var.,
	rows=&rows.,
	cols=&cols.
);




/***
Viridis color palette macro, Shane Rosanbalm, Rho, Inc., 2019
https://github.com/RhoInc/sas-viridis
***/
%let color_spectrum=cx440154 cx472777 cx3D4A89 cx30678D cx25828E cx1E9D88 cx35B778 cx6BCD59 cxB5DD2B cxFDE724;

/***
Macro for printing SOM Graphs
***/
%macro print_som(som_dataset, som_variables);
	ods layout gridded columns=3;

	%do X=1 %to %sysfunc(countw(&som_variables.));
		%let varname = %scan(&som_variables., &X., %str( ));

		ods region;
		ods graphics / width=350px height=300px antialiasmax=10000 noborder imagemap=on subpixel=on;
		title "Average Cluster of &varname.";
		/* Create the heat map. */
		proc sgplot data=&som_dataset.(where=(_TYPE_="CLUS_MEAN"));
		 	heatmapparm x=som_dimension2 y=som_dimension1 colorresponse=&varname. /
				colormodel=(&color_spectrum.) transparency=0.1 tip=(som_dimension2 som_dimension1 &varname.);
			xaxis thresholdmin=0 label="DIM2";
			yaxis thresholdmin=0 label="DIM1";
		run;
		title;
	%end;

	ods layout end;
%mend;

%print_som(&som_dataset., &som_variables);