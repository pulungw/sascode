options emailsys=smtp emailhost=mailhost.fyi.sas.com emailid="replies-disabled@sas.com" emailport=25;
proc options;run;

filename mymail email "Pulung.Waskito@sas.com" subject="test message";
data _null_;
	file mymail;
	put 'Hello there';
run;