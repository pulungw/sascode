cas casauto;
caslib _all_ assign;

proc fedsql sessref=casauto;
	create table sales_join as
	select 
		t1.store,
		t2.type,
		t2.size,
		t1.dept,
		t1.date,
		t1.weekly_sales,
		t1.isHoliday,
		t3.temperature,
		t3.fuel_price,
		t3.Markdown1,
		t3.Markdown2,
		t3.Markdown3,
		t3.Markdown4,
		t3.Markdown5,
		t3.CPI,
		t3.unemployment
	from sales t1
	left join stores t2 on t1.store = t2.store
	left join features t3 on t1.store = t3.store and t1.date = t3.date
	;
quit;

data casuser.test; 
	date='04/05/2018';
	sasdate = input(date, ddmmyy10.);
run;

data work.test;  
	format sasdate yymmdds10.;
	date='04/05/2018';
	sasdate=input(date,ddmmyy10.);
run;

data _null_ / sessref=casauto ;
	dot = Input('12.12.2018', ddmmyy10.);
	slash = Input('12/12/2018', ddmmyy10.);
	dash = Input('12-12-2018', ddmmyy10.);
	space = Input('12 12 2018', ddmmyy10.);
	format dot slash dash space date9. ;
	put dot slash dash space ;
run;

data _null_ ;
	dot = Input('12.12.2018', ddmmyy10.);
	slash = Input('12/12/2018', ddmmyy10.);
	dash = Input('12-12-2018', ddmmyy10.);
	space = Input('12 12 2018', ddmmyy10.);
	format dot slash dash space date9. ;
	put dot slash dash space ;
run;

data casuser.dm_sales;
/* 	format sales_date yymmdd10.;  */
	set casuser.sales_join;
	sales_date = input(date, yymmdd10.);
/* 	drop date; */
run;

proc casutil;
	droptable casdata="dm_sales" incaslib="casuser";
run;