/* SAS code */


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
    source train_gb;

        decisionTree.gbtreetrain result = train_res /
            table = table,
            target = "&dm_dec_vvntarget",
            inputs = {%interval_inputs},
            nominals = {%nominal_inputs} + {"&dm_dec_vvntarget"},
            encodeName = True,
            weight = weight,
            nTree = 15,
            savestate = {
                name = "saved_gb_astore",
                replace = True
            }
        ;

        astore.score result = score_res /
            table = table,
            rstore = "saved_gb_astore",
            casout = casout,
            copyVars = copyVars
        ;
        
        describe train_res;
        print train_res;
        
        send_response(
            {
                astore_table = {
                    name = "saved_gb_astore"
                },
                
                /* Note, spaces in levelizations have to match, hence the kstrip */
                responseLevels = train_res["EncodedName"].compute("_level_",kstrip(LEVNAME))[,"_level_"],
                predictedVariables = train_res["EncodedName"][,"VARNAME"]
            }
        );

    endsource;


    /* Call Mitigate Action */
    fairAITools.mitigateBias result = mitigate_res /
        table={name="&dm_memname"},
        response="&dm_dec_vvntarget",
        sensitiveVariable="sex",
        event="&dm_dec_event",
        learningRate=0.1,
        bound=40,
        maxIters=5,
        trainProgram=train_gb,
        logLevel=3,
        biasMetric="PREDICTIVEPARITY",
        
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
run;
quit;



data &dm_lib..constrainthistory;
    set work.constrainthistory;
run;



data &dm_lib..groupmetricshistory;
    set work.groupmetricshistory;
run;

proc print data=groupmetricshistory;
run;

%dmcas_report(
    dataset=constrainthistory,
    reporttype=seriesplot,
    description=Group Mu over Iterations,
    x=Iteration,
    y=MuLevel,
    group=Group
);

/* Bar Chart - sorted X-axis */
%dmcas_report(
      dataset=groupmetricshistory, 
      reportType=BarChart, 
      category=group, 
      group=iteration, 
      response=MCLL, sortBy=iteration, description=%nrbquote(Multiclass Log Loss per Iteration and Group));

/* Bar Chart - sorted X-axis */
%dmcas_report(
      dataset=groupmetricshistory, 
      reportType=BarChart, 
      category=group, 
      group=iteration, 
      response=C, sortBy=iteration, description=%nrbquote(Area Under the Curve per Iteration and Group));



/* Bar Chart - sorted X-axis */
%dmcas_report(
      dataset=groupmetricshistory, 
      reportType=BarChart, 
      category=group, 
      group=iteration, 
      response=TPR, sortBy=iteration, description=%nrbquote(True Positive Rate per Iteration and Group));


