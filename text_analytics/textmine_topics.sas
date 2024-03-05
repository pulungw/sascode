cas;
caslib _all_ assign;
%let ASTORE_PATH=/tmp/tmmodel.astore;

data casuser.reviews;
   infile datalines delimiter='|' missover;
   length text $300 category $20;
   input text$ positive category$ did;
   datalines;
    This is the greatest phone ever! love it! It can replace my tv! |1|electronics|1
    The phone's battery life is too short and screen resolution is low.|0|electronics|2
    The screen resolution is low, but I love this tv. Good viewing.|1|electronics|3
    The movie itself is great and I liked watching it. Good acting! |1|movies|4
    The movie's story is boring and the acting is poor.|0|movies|5
    I watched this movie but it was boring. |0|movies|6
    The book has a terrific plot!|1|books |7
    The book's plot was suspenseful. Good read.|1|books|8
    I love the author, but this book is a waste of time to read.|0|books|9
;
run;

proc cas;                                            
   loadtable 
		caslib="ReferenceData" 
		path="en_stoplist.sashdat"
		casout={caslib="casuser" name="en_stoplist" replace=TRUE}
	;
	loadtable
		caslib="ReferenceData"
		path="ja_stoplist.sashdat"
		casout={caslib="casuser" name="ja_stoplist" replace=TRUE}
	;
	tableinfo caslib="casuser" name="en_stoplist";
	tableinfo caslib="casuser" name="ja_stoplist";
run;

proc textmine data=casuser.reviews language=english;
	doc_id did;
	variables text;
	parse
		outterms=casuser.terms
		outchild=casuser.child
		outparent=casuser.parent
		outconfig=casuser.config
		reducef=2
		stop=casuser.en_stoplist
		entities=std
	;
	svd
		k=3
		numlabels=5
		outdocpro=casuser.docpro
		outtopics=casuser.topics
		svds=casuser.svds
		svdu=casuser.svdu
		svdv=casuser.svdv
	;
	savestate rstore=casuser.tmmodel;
run;

proc print data=casuser.svdu;
run;

proc print data=casuser.terms;
run;

proc print data=casuser.topics;
run;

proc tmscore
	data=casuser.reviews
	terms=casuser.terms
	config=casuser.config
	svdu=casuser.svdu
	svddocpro=casuser.tmscore_out
	;
doc_id did;
variables text;
run;

proc astore;
	download 
		rstore=casuser.tmmodel 
		store="&ASTORE_PATH."
	;
run;

proc astore;
	upload 
		rstore=casuser.tmmodel 
		store="&ASTORE_PATH."
	;
run;

proc cas;
	table.tableinfo caslib="casuser" name="tmmodel";
	table.tabledetails caslib="casuser" name="tmmodel";
	table.tabledetails caslib="casuser" name="terms";
	table.tabledetails caslib="casuser" name="config";
	table.tabledetails caslib="casuser" name="svdu";
	table.tabledetails caslib="casuser" name="docpro";
run;

proc astore;
	score 
		data=casuser.reviews
		rstore=casuser.tmmodel
		out=casuser.score_out copyvars=(_ALL_)
	;
quit;
