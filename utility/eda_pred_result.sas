options locale=ja_JP;
libname toyores base "/greenmonthly-export/ssemonthly/homes/Pulung.Waskito@sas.com/toyores/";

proc sql;
	create table work.pred_result_agg as
	select 
		t1.vehicle_id,
		t1.number_plate,
		t1.tire_id,
		t1.display_prediction_date,
		avg(t1.display_groove) as display_groove
	from toyores.pred_result t1
	group by vehicle_id, number_plate, tire_id, display_prediction_date
	order by vehicle_id, number_plate, tire_id, display_prediction_date 
	;
quit;

/* %macro plot_tire_groove(VEHICLE_ID); */
/* 	proc sql noprint; */
/* 		select distinct t1.number_plate into :NUMBER_PLATE */
/* 		from work.pred_result_agg t1 */
/* 		where vehicle_id = &VEHICLE_ID. */
/* 		; */
/* 	quit; */
/* 	 */
/* 	proc sgplot data=work.pred_result_agg(where=(vehicle_id=&VEHICLE_ID.)); */
/* 		title "(車両ID=&VEHICLE_ID.) &NUMBER_PLATE." font='Times New Roman'; */
/* 		series x=display_prediction_date y=display_groove / group=tire_id markers; */
/* 		xaxis interval=month; */
/* 		yaxis min=0; */
/* 	run; */
/* %mend; */
/*  */
/* title; */
/* %plot_tire_groove(1); */
/* %plot_tire_groove(2); */
/* %plot_tire_groove(3); */
/* %plot_tire_groove(4); */
/* %plot_tire_groove(5); */
/* %plot_tire_groove(6); */
/* %plot_tire_groove(7); */
/* %plot_tire_groove(8); */
/* %plot_tire_groove(9); */
/* %plot_tire_groove(10); */
/* %plot_tire_groove(11); */
/* %plot_tire_groove(12); */
/* %plot_tire_groove(13); */

proc sql;
	create table work.pred_result_gps as
	select distinct t1.vehicle_id, 
		t1.number_plate,
		t1.display_prediction_date,
		t1.gps_mileage
	from toyores.pred_result t1
	group by vehicle_id, display_prediction_date, gps_mileage
	order by vehicle_id, display_prediction_date, gps_mileage
	;
quit;

%macro plot_gps(VEHICLE_ID);
	proc sql noprint;
		select distinct t1.number_plate into :NUMBER_PLATE
		from work.pred_result_gps t1
		where vehicle_id = &VEHICLE_ID.
		;
	quit;

	proc sgplot data=work.pred_result_agg(where=(vehicle_id=&VEHICLE_ID.));
		title "残溝深さ (車両ID=&VEHICLE_ID.) &NUMBER_PLATE." font='Times New Roman';
		series x=display_prediction_date y=display_groove / group=tire_id markers;
		xaxis interval=month;
		yaxis min=0;
	run;

	proc sgplot data=work.pred_result_gps(where=(vehicle_id=&VEHICLE_ID.));
		title "GPS走行距離 (車両ID=&VEHICLE_ID.) &NUMBER_PLATE." font='Times New Roman';
		vbar display_prediction_date / response=gps_mileage;
	run;
%mend;
%plot_gps(1);
%plot_gps(2);
%plot_gps(3);
%plot_gps(4);
%plot_gps(5);
%plot_gps(6);
%plot_gps(7);
%plot_gps(8);
%plot_gps(9);
%plot_gps(10);
%plot_gps(11);
%plot_gps(12);
%plot_gps(13);