cas;
libname mycas cas; 

data mycas.concept_rules_long;                      /*  */
   length config varchar(*);
   infile datalines delimiter='|' missover;
   input config$;
   ruleid=monotonic();
   datalines;
      ENABLE:COMPANY
      FULLPATH:COMPANY:Top/COMPANY
      PRIORITY:COMPANY:10
      CASE_INSENSITIVE_MATCH:COMPANY
      CLASSIFIER:COMPANY: Microsoft
      CLASSIFIER:COMPANY: Amazon
      CLASSIFIER:COMPANY: Google
      ENABLE:PRODUCT
      FULLPATH:PRODUCT:Top/PRODUCT
      PRIORITY:PRODUCT:10
      CASE_INSENSITIVE_MATCH:PRODUCT
      CLASSIFIER:PRODUCT: xbox
      CLASSIFIER:PRODUCT: windows
      CLASSIFIER:PRODUCT: chrome
      CLASSIFIER:PRODUCT: fire
      ENABLE:TEST_PRED
      FULLPATH:TEST_PRED:Top/TEST_PRED
      PRIORITY:TEST_PRED:10
      CASE_INSENSITIVE_MATCH:TEST_PRED
      PREDICATE_RULE:TEST_PRED(company, product):(DIST_1, "_company{COMPANY}","_product{PRODUCT}")
      ENABLE:Top
      FULLPATH:Top:Top
      PRIORITY:Top:10
      CASE_INSENSITIVE_MATCH:Top
   ;
run;

data mycas.apply_concept_text;                      /*  */
   length text varchar(*);
   infile datalines delimiter='|' missover;
   docid=monotonic();
   input text$;
   datalines;
      I just bought an amazon fire tablet
      microsoft Windows in an operating system
      Dave uses the Google chrome browser
   ;
run;




proc cas;                                              /*  */
   
   builtins.loadActionSet /                            /*  */
      actionSet="textRuleDevelop";
   
   builtins.loadActionSet /                            /*  */
      actionSet="textRuleScore";
                        
   textRuleDevelop.compileConcept /                    /*  */
      casOut={name="outli", replace=TRUE}
      ruleid="ruleid"
      config="config"                
      table={name="concept_rules_long"};
   run;

   textRuleScore.applyConcept /                        /*  */
      casOut={name="out_concept", replace=TRUE}
      docId="docid"
      factOut={name="out_fact", replace=TRUE}
      model={name="outli"}
      ruleMatchOut={name="out_rule_match", replace=TRUE}
      table={name="apply_concept_text"}
      text="text";
   run;
   
   table.fetch /                                       /*  */
      table={name="out_concept"};
   run;

   table.fetch /                                       /*  */
      table={name="out_fact"};
   run;

   table.fetch /                                       /*  */
      table={name="out_rule_match"};
   run;

quit;                                                  /*  */