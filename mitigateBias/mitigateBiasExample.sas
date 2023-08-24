%let sysparm=runcas:laxsmp+box:no+playpen:/u/rithar/pp;
%cassetup;

/* Manually Load Templates From Playpen */
%include "/u/rithar/pp/tkfairaitools/pgm/en/fairaitools.tpl";
/*%include "U:\pp\tkfairaitools\pgm\en\fairaitools.tpl";*/

/* Using HMEQ for Examples */
proc cas;

    table.loadTable /
        caslib = "CASUSER",
        path = "hmeq_p.sas7bdat"
        casout = "HMEQ"
    ;

quit;

/* Save Log */
proc printto new log='/u/rithar/public_html/output_reviews/fairAITools/example_mitigate.log';
run;

/* Save HTML Elements */
ods trace on / label;
ods listing file='/u/rithar/public_html/output_reviews/fairAITools/example_mitigate.lst';
ods html style=htmlblue frame='a_mitigate.html'
body='b_mitigate.html'
contents='c_mitigate.html';

/* Redirects ODS Output according to prefix */
%macro redirect_ods(prefix);
    ods output MitigationInformation=&prefix.MitigationInformation;
    ods output Timing=&prefix.Timing;
    ods output ConstraintHistory=&prefix.ConstraintHistory;
    ods output WeightHistory=&prefix.WeightHistory;
    ods output GroupMetricsHistory=&prefix.GroupMetricsHistory;
    ods output IterationHistory=&prefix.IterationHistory;
%mend redirect_ods;

/* Nominal, 1 Constraint Example */
%redirect_ods(Nominal1);

proc cas;

     /* Training Code */
    source train_forest;

        decisionTree.forestTrain result = train_res /
            table = table,
            target = "BAD",
            inputs = {"CLAGE", "CLNO", "DEBTINC", "LOAN", "MORTDUE", "VALUE","YOJ", "DELINQ", "DEROG", "JOB", "NINQ"},
            nominals = {"DELINQ", "DEROG", "JOB", "NINQ", "BAD"},
            encodeName = True,
            weight = weight,
            nTree = 100,
            savestate = {
                name = "hmeq_forest_astore",
                replace = True
            }
        ;

        astore.score result = score_res /
            table = table,
            rstore = "hmeq_forest_astore",
            casout = casout,
            copyVars = copyVars
        ;

    endsource;

    /* Call Mitigate Action */
    fairAITools.mitigateBias /
        table="hmeq",
        response="BAD",
        sensitiveVariable="REASON",
        predictedVariables={"P_BAD1", "P_BAD0"},
        responseLevels={"1", "0"},
        event="1",

        biasMetric="DEMOGRAPHICPARITY",
        learningRate=0.1,
        bound=40,
        tolerance=0.005,
        maxIters=10,
        trainProgram=train_forest
    ;

    /* Call Mitigate Action, Describe Results */
    fairAITools.mitigateBias result=mit_res /
        table="hmeq",
        response="BAD",
        sensitiveVariable="REASON",
        predictedVariables={"P_BAD1", "P_BAD0"},
        responseLevels={"1", "0"},
        event="1",

        biasMetric="DEMOGRAPHICPARITY",
        learningRate=0.1,
        bound=40,
        tolerance=0.005,
        maxIters=10,
        trainProgram=train_forest
     ;
     describe mit_res;

quit;

/* Nominal, 2 Constraint Example */
%redirect_ods(Nominal2);

proc cas;

     /* Training Code */
    source train_forest;

        decisionTree.forestTrain result = train_res /
            table = table,
            target = "BAD",
            inputs = {"CLAGE", "CLNO", "DEBTINC", "LOAN", "MORTDUE", "VALUE","YOJ", "DELINQ", "DEROG", "JOB", "NINQ"},
            nominals = {"DELINQ", "DEROG", "JOB", "NINQ", "BAD"},
            encodeName = True,
            weight = weight,
            nTree = 100,
            savestate = {
                name = "hmeq_forest_astore",
                replace = True
            }
        ;

        astore.score result = score_res /
            table = table,
            rstore = "hmeq_forest_astore",
            casout = casout,
            copyVars = copyVars
        ;

    endsource;

    /* Call Mitigate Action */
    fairAITools.mitigateBias /
        table="hmeq",
        response="BAD",
        sensitiveVariable="REASON",
        predictedVariables={"P_BAD1", "P_BAD0"},
        responseLevels={"1", "0"},
        event="1",

        biasMetric="EQUALIZEDODDS",
        learningRate=0.1,
        bound=40,
        tolerance=0.005,
        maxIters=10,
        trainProgram=train_forest
    ;

    /* Call Mitigate Action, Describe Results */
    fairAITools.mitigateBias result=mit_res /
        table="hmeq",
        response="BAD",
        sensitiveVariable="REASON",
        predictedVariables={"P_BAD1", "P_BAD0"},
        responseLevels={"1", "0"},
        event="1",

        biasMetric="EQUALIZEDODDS",
        learningRate=0.1,
        bound=40,
        tolerance=0.005,
        maxIters=10,
        trainProgram=train_forest
    ;
    describe mit_res;

quit;

/* Interval Example */
%redirect_ods(Interval);

proc cas;

     /* Training Code */
    source train_forest;

        decisionTree.forestTrain result = train_res /
            table = table,
            target = "VALUE",
            inputs = {"CLAGE", "CLNO", "DEBTINC", "LOAN", "MORTDUE","BAD", "YOJ", "DELINQ", "DEROG", "JOB", "NINQ"},
            nominals = {"DELINQ", "DEROG", "JOB", "NINQ", "BAD"},
            encodeName = True,
            weight = weight,
            nTree = 100,
            savestate = {
                name = "hmeq_forest_astore",
                replace = True
            }
        ;

        astore.score result = score_res /
            table = table,
            rstore = "hmeq_forest_astore",
            casout = casout,
            copyVars = copyVars
        ;

    endsource;

    /* Call Mitigate Action */
    fairAITools.mitigateBias /
        table="hmeq",
        response="VALUE",
        nominalResponse=False,
        sensitiveVariable="REASON",
        predictedVariables={"P_VALUE"},

        biasMetric="PREDICTIVEPARITY",
        learningRate=0.1,
        bound=40,
        tolerance=0.005,
        maxIters=10,
        trainProgram=train_forest
    ;

    /* Call Mitigate Action - Describe */
    fairAITools.mitigateBias result=mit_res /
        table="hmeq",
        response="VALUE",
        nominalResponse=False,
        sensitiveVariable="REASON",
        predictedVariables={"P_VALUE"},

        biasMetric="PREDICTIVEPARITY",
        learningRate=0.1,
        bound=40,
        tolerance=0.005,
        maxIters=10,
        trainProgram=train_forest
    ;
    describe mit_res;

quit;

ods html close;
ods listing close;
ods trace off;

%macro doit(n);
    title "&n";
    proc contents p varnum data=&n;
    ods select position;
    run;

    proc print data=&n;
    run;
%mend doit;

%macro doit_prefix(prefix);
    %doit(&prefix.MitigationInformation);
    %doit(&prefix.Timing);
    %doit(&prefix.ConstraintHistory);
    %doit(&prefix.WeightHistory);
    %doit(&prefix.GroupMetricsHistory);
    %doit(&prefix.IterationHistory);
%mend doit_prefix;

ods html file = "mitigateBias_contents.html";
ods listing file = "mitigateBias_contents.lst";
%doit_prefix(Nominal1);
%doit_prefix(Nominal2);
%doit_prefix(Interval);

%casclear(stop=yes);
