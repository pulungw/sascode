cas;
caslib _all_ assign;


data casuser.livedoor_corpus_id / single=yes;
	set casuser.livedoor_corpus;
	did = _N_;

/* 	uniqueID = put(_threadid_,8.) || '_' || Put(_n_,8.); */
/* 	uniqueID = _THREADID_; */

/* 	if _N_ = 1 then do; */
/* 		_mult = 10 ** (int(log10(_NTHREADS_)) + 1); */
/* 		retain _mult; */
/* 		drop _mult; */
/* 	end; */
/* 	uniqueID = _THREADID_ + (_N_ * _mult); */
run;

proc casutil;
	save casdata="livedoor_corpus_id" incaslib="casuser" outcaslib="casuser" casout="livedoor_corpus_id.sashdat";
run;

/* proc casutil; */
/* 	droptable incaslib="casuser" casdata="livedoor_corpus_id"; */
/* run; */