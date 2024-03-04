cas;
caslib _all_ assign;
%let ASTORE_PATH=/tmp/tmmodel.astore;

/* Load stoplist */
proc cas;                                            
	loadtable
		caslib="ReferenceData"
		path="ja_stoplist.sashdat"
		casout={caslib="casuser" name="ja_stoplist" replace=TRUE}
	;
	tableinfo caslib="casuser" name="ja_stoplist";
run;

/* Check input data */
proc cas;
	tableinfo caslib="casuser" name="livedoor_corpus_id";
run;

/* Perform text parsing, entities extraction, topic extraction */
proc textmine data=casuser.livedoor_corpus_id language=japanese;
	doc_id did;
	variables text;
	parse
		outterms=casuser.terms
		outchild=casuser.child
		outparent=casuser.parent
		outconfig=casuser.config
		reducef=1
		stop=casuser.ja_stoplist
		entities=std
	;
	svd
		k=10
		numlabels=5
		outdocpro=casuser.docpro
		outtopics=casuser.topics
		svds=casuser.svds
		svdu=casuser.svdu
		svdv=casuser.svdv
	;
	savestate rstore=casuser.tmmodel;
run;

/* Extract nlpPerson */
data casuser.nlpPerson;
	set casuser.terms;
	where Role="nlpPerson";
run;

/* Extract nlpOrganization */
data casuser.nlpOrganization;
	set casuser.terms;
	where Role="nlpOrganization";
run;

/* Extract nlpPlace */
data casuser.nlpPlace;
	set casuser.terms;
	where Role="nlpPlace";
run;

/* Extract nlpDate */
data casuser.nlpDate;
	set casuser.terms;
	where Role="nlpDate";
run;
