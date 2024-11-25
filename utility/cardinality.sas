cas;
caslib _all_ assign;

/* Create and promote the test data */
data casuser.tmp001;
  do i = 1 to 100000 ;
    var000 = ( ranuni( 0 ) > 0.8 ) ;
    var001 = int( 10 ** ( 1 + ranuni( 1 ) ) ) ;
    var002 = int( 10 ** ( 2 + ranuni( 2 ) ) ) ;
    var003 = int( 10 ** ( 3 + ranuni( 3 ) ) ) ;
    var004 = int( 10 ** ( 4 + ranuni( 4 ) ) ) ;
    var005 = int( 10 ** ( 5 + ranuni( 5 ) ) ) ;
    var006 = int( 10 ** ( 6 + ranuni( 6 ) ) ) ;
    var007 = int( 10 ** ( 7 + ranuni( 7 ) ) ) ;
    var008 = int( 10 ** ( 8 + ranuni( 8 ) ) ) ;
    var009 = int( 10 ** ( 9 + ranuni( 9 ) ) ) ;
    output ;
  end ;
run ;

/* Use PROC CARDINALITY to get the cardinality of variables. */
proc cardinality data=casuser.tmp001 maxlevels=254 outcard=casuser.outcard;
/*   var var007 var008 var009;*/
    var _ALL_;
run;

/* Use the distinct action to count the number of distinct values for the var007, var008, var009 variables*/
proc cas;
   simple.distinct /
      casOut={caslib="casuser",name="tmp001_cnt"}
      table={caslib="casuser", name="tmp001",vars={{name="var007"}, {name="var008"},{name="var009"}}};
run;
 