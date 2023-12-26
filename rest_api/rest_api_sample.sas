%let BASEURL=%sysfunc(getoption(SERVICESBASEURL));
%put &BASEURL.;

/* REST API to external public URL */
proc http 
	url="http://httpbin.org/get";
run;

/* REST API using external DNS name */
proc http method='GET' oauth_bearer=SAS_SERVICES
	url="&BASEURL./folders/apiMeta";
run;

/* REST API using internal k8s name */
/* Check sas-shared-config Config Map under SAS_URL_SERVICE_TEMPLATE */
/* Ex) https://@k8s.service.name@ */
proc http method='GET' oauth_bearer=SAS_SERVICES
	url="https://sas-folders/folders/apiMeta";
run;