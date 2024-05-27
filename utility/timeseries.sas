options symbolgen source2;

data casuser.pricedata;
	set sashelp.pricedata;
run;

proc sgplot data=casuser.pricedata;
	series y=sale x=date;
	by regionName productLine productName;
run;

%let _tsname=TSATTRIBUTE;

proc cas;
	%include '/opt/sas/viya/home/SASFoundation/misc/codegenscrpt/source/casl/tsAttribute.casl';
/* 	%include TSATTRIB; */

	attrArgs.debug=0;
	attrArgs.cas.session="casauto";
	attrArgs.cas.caslibIn="casuser";
	attrArgs.cas.caslibOut="casuser";

	/*** Default output table is TSATTRIBUE ***/
	attrArgs.dataSpecification.outData="&_tsname.";
	attrArgs.dataSpecification.inData = "pricedata";

	/*** Target variable info ***/
	attrArgs.dataSpecification.dependentVar.name = "sale";
	attrArgs.dataSpecification.dependentVar.accumulation="SUM";
	attrArgs.dataSpecification.dependentVar.setMissing=0;

	/*** BY group ***/
	attrArgs.dataSpecification.byVars = "regionName productLine productName";

	/*** TimeID info ***/
	attrArgs.timeID.name = "date";
 	attrArgs.timeID.interval = "monthly";
	attrArgs.timeID.seasonality=12;
	attrArgs.timeID.horizonStart=.;

	/*** Run TSATTRIBUTE ***/
	outArgs=time_series_attribute(attrArgs);
run;
quit;