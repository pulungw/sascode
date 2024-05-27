cas;
caslib _all_ assign;

data casuser.hmeq;
	set sampsio.hmeq;
	where reason ne '';
run;

proc cas;
fairAITools.mitigateBiasDecisionTree /
    mitigateOptions={predictedVariables={"P_BAD1", "P_BAD0"},
                     responseLevels={"1", "0"},
                     seed="12345",
                     sensitiveVariable="REASON"},
    trainOptions={casOut={name="dtreeOut",
                          replace="true"},
                  crit="GAINRATIO",
                  encodeName="True",
                  inputs={"CLAGE",
                          "DEBTINC",
                          "DEROG",
                          "JOB",
                          "LOAN",
                          "MORTDUE",
                          "REASON",
                          "VALUE"},
                  maxLevel="11",
                  nBins="20",
                  nominals={"BAD",
                          "JOB",
                          "REASON"},
                  saveState={name="hmeq_dt_astore",
                          replace="True"},
                  table={caslib="casuser", name="hmeq"},
                  target="BAD"};
run;