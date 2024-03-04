cas;
libname mycas cas; 

data mycas.reviews;
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
   loadtable caslib="ReferenceData" path="en_stoplist.sashdat"; 
   run;
quit;

proc cas;

   loadactionset "textMining";                  
   action tmMine;
   param
   docId="did"
   documents={ name="reviews"}
   text="text"
   nounGroups= False
   tagging = True
   stemming= True
   stopList ={ name="en_stoplist"}
   parseConfig={name="config", replace=TRUE}
   parent ={ name="parent",replace=TRUE}
   offset ={name="offset",replace=TRUE}
   terms ={ name="terms", replace=TRUE}
   reduce=2
   k=3
   docPro ={ name="docpro", replace=TRUE}
   topics ={ name="topics", replace=TRUE}
   u ={ name="svdu", replace=TRUE}
   numLabels=3
   topicDecision=True
   ;
   run;

   action table.fetch /table="topics", orderBy="_TopicID_"; 
   run;

   action table.fetch /table="docpro", orderBy="did"; 
   run;

   action table.fetch /table="svdu", orderBy="_TermNum_"; 
   run;

quit;