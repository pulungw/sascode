cas;
caslib _all_ assign;

data casuser.hmeq;
	set sampsio.hmeq;
	where reason ne '';
run;

proc cas;
fairAITools.mitigateBias /
    biasMetric="DEMOGRAPHICPARITY",
    event="1",
    learningRate="0.01",
    maxIters="10",
    predictedVariables={"P_BAD0", "P_BAD1"},
    response="BAD",
    responseLevels={"0", "1"},
    sensitiveVariable="reason",
    table={caslib="casuser", name="hmeq"},
    tolerance="0.005",
    trainProgram="
         decisionTree.gbtreeTrain result=train_res /
            table=table,
            weight=weight,
            target=""BAD"",
            inputs= {
               ""loan"", ""mortdue"", ""value"",
               ""yoj"", ""derog"", ""delinq"",
               ""clage"", ""ninq"", ""clno"",
               ""debtinc"", ""job""
            },
            nominals={""BAD"",""job""},
            nBins=50,
            quantileBin=True,
            maxLevel=5,
            maxBranch=2,
            leafSize=5,
            missing=""USEINSEARCH"",
            minUseInSearch=1,
            binOrder=True,
            varImp=True,
            mergeBin=True,
            encodeName=True,
            nTree=15,
            seed=12345,
            ridge=1,
            savestate={
               name=""hmeq_gb_astore"",
               replace=True
            }
         ;
         astore.score result=score_res /
            table=table,
            casout=casout,
            copyVars=copyVars,
            rstore=""hmeq_gb_astore""
         ;
      ",
    tuneBound="True";
run;