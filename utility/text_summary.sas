cas;
caslib _all_ assign;

proc cas;
   textSummarization.textSummarize / 
      corpusSummaries={caslib="casuser" name="corpusSummaries"}
      documentSummaries={caslib="casuser" name="documentSummaries"}
      id="id"
      language="JAPANESE"
      numberOfSentences=1
      table={caslib="casuser" name="sas_press_release"}
      text="text";
   run;

   table.fetch / 
       table={name="documentSummaries"};
    run;
quit;


proc cas;
   textSummarization.textSummarize / 
      corpusSummaries={caslib="casuser" name="livedoor_corpusSum" replace=TRUE}
      documentSummaries={caslib="casuser" name="livedoor_documentSum" replace=TRUE}
      id="uniqueID"
      language="JAPANESE"
      numberOfSentences=1
      table={caslib="casuser" name="livedoor_corpus_id"}
      text="text"
	useEntities=TRUE
	useTerms=TRUE
	;
   run;
quit;

proc cas;
   table.fetch / 
       table={name="livedoor_corpusSum"};
    run;
quit;

proc cas;
   table.fetch / 
       table={name="livedoor_documentSum"};
    run;
quit;