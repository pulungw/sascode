%let BASEURL = %sysfunc(getoption(SERVICESBASEURL));
%put &BASEURL.;

proc http method='GET' oauth_bearer=SAS_SERVICES
	url="&BASEURL./folders/apiMeta";
run;