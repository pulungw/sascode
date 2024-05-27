cas;

data casuser.dmagecr;
   set sampsio.dmagecr;
run;

proc cas;
    action svm.svmtrain /
        table="dmagecr"
        nominals={"checking" "history" "purpose" "savings" "employed"
                   "marital" "coapp" "property" "other" "job" "housing"
                   "telephon" "foreign" "good_bad"}
        inputs={"duration" "amount" "installp" "resident" "existcr"
                "depends" "age" "checking" "history" "purpose" "savings"
                "employed" "marital" "coapp" "property" "other" "job"
                "housing" "telephon" "foreign"}
        target="good_bad";
run;
quit;