options casport=5570 cashost="sas-cas-server-default-client"; 
cas casauto;
libname mycas cas; 

data mycas.text_to_identify;
  infile datalines delimiter='|' missover;
  length _text_ varchar(*);
  input _docid_ _expected_$ _text_;
  datalines;
    1|en|I bought this product in May and have been very satisfied with it so far.
    2|hr|Kupila sam ovo u svibnju i do sada sam vrlo zadovoljna.
    3|it|Ho acquistato questo prodotto a maggio e finora sono rimasto molto soddisfatto.
    4|ko|나는 이 제품을  5월에 구입했는데, 지금까지 매우 만족스럽습니다.
    5|zh|我在五月份购买了这个产品，一直到现在我对它都非常满意。
    6|ru|Я купил этот продукт в мае и до сих пор им очень доволен.
  ;
run;

proc cas;
   session casauto;

   builtins.loadActionSet /
      actionSet="textManagement";
   run;

   textManagement.identifyLanguage /
      casOut={name="out_language", replace=TRUE}
      copyVars={"_expected_"}
      docId="_docid_"
      table={name="text_to_identify"}
      text="_text_";
   run;

   table.fetch /
      table={name="out_language"};
   run;

quit;      