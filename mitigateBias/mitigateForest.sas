%dmcas_varmacro(
    name = interval_inputs,
    metadata = &dm_metadata,
    where = %nrbquote(ROLE="INPUT"),
    key = NAME,
    nummacro = __foo__,
    quote = Y,
    singlequote = Y,
    comma = Y
);

%dmcas_varmacro(
    name = nominal_inputs,
    metadata = &dm_metadata,
    where = %nrbquote(ROLE="INPUT" and LEVEL ^in("INTERVAL","NULL")),
    key = NAME,
    nummacro = __bar__,
    quote = Y,
    singlequote = Y,
    comma = Y
);

proc cas;

    /* Training Code */
    source train_forest;

        decisionTree.forestTrain result = train_res /
            table = table,
            target = "&dm_dec_vvntarget",
            inputs = {%interval_inputs},
            nominals = {%nominal_inputs} + {"&dm_dec_vvntarget"},
            encodeName = True,
            weight = weight,
            nTree = 150,
            savestate = {
                name = "saved_forest_astore",
                replace = True
            }
        ;

        astore.score result = score_res /
            table = table,
            rstore = "saved_forest_astore",
            casout = casout,
            copyVars = copyVars
        ;
        
        describe train_res;
        print train_res;
        
        send_response(
            {
                astore_table = {
                    name = "saved_forest_astore"
                },
                
                /* Note, spaces in levelizations have to match, hence the kstrip */
                responseLevels = train_res["EncodedName"].compute("_level_",kstrip(LEVNAME))[,"_level_"],
                predictedVariables = train_res["EncodedName"][,"VARNAME"]
            }
        );

    endsource;

    /* Call Mitigate Action */
    fairAITools.mitigateBias result = mitigate_res /
        table={name="&dm_memname", where="^missing(REASON)"},
        response="&dm_dec_vvntarget",
        sensitiveVariable="reason",
        event="&dm_dec_event",
        learningRate=0.1,
        bound=40,
        maxIters=50,
        trainProgram=train_forest,
        logLevel=3,
        biasMetric="DEMOGRAPHICPARITY",
        
        tableSaveList = {
            {
                key = "astore_table",
                casout = {
                    name = "&dm_rstoretable",
                    caslib = "&dm_data_caslib"
                }
            }
        }
     ;
     run;

     print mitigate_res;
     saveresult mitigate_res;

quit;

data &dm_lib..constrainthistory;
    set work.constrainthistory;
run;

%dmcas_report(
    dataset=constrainthistory,
    reporttype=seriesplot,
    description=Group Mu over Iterations,
    x=Iteration,
    y=MuLevel,
    group=Group
);

