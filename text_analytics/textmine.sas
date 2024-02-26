cas;
caslib _all_ assign;

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
		reducef=2
		stop=casuser.en_stoplist;
	;
	svd
		k=3
		numlabels=3
		outdocpro=casuser.docpro
		outtopics=casuser.topics
		svds=casuser.svds
		svdu=casuser.svdu
		svdv=casuser.svdv
	;
run;

