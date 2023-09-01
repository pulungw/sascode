cas;
caslib _all_ assign;

proc cas;
	ds2.runModel /
		modelName="higgs_gradboost"
		modelTable={caslib="Public" name="sas_model_table"}
		table={caslib="casuser" name="higgs10k_1"}
		casout={caslib="casuser" name="scored_higgs10k_1"}
	;
quit;

proc cas;
	ds2.runModel /
		modelName="higgs_ensemble"
		modelTable={caslib="Public" name="sas_model_table"}
		table={caslib="casuser" name="higgs10k_1"}
		casout={caslib="casuser" name="scored_higgs10k_ensemble"}
	;
quit;

data casuser.scored_higgs10k_label;
	set casuser.scored_higgs10k_1;
	/* changing char to num; */
	p_label = input (i_label,8.);
run;

proc assess data=casuser.scored_higgs10k_label;
	target label / event="1" level=nominal;
	var p_label;
run;

/* title "Confusion Matrix Based on Cutoff Value of 0.5"; */
proc freq data=casuser.scored_higgs10k_label;
   tables p_label*label / norow nocol /*nopct*/;
run;