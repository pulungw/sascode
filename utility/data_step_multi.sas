data casuser.train;
	put 'Hello from ' _hostname_ 'thread #' _threadid_;
	do i = 1 to 1000;
		col1 = rand('normal') * 5;
		col2 = col1 * 3 + rand('normal') * 2;
		output;
	end;
run;


proc cas;
	datastep.runCode / nthreads=10
		code = "
			data casuser.train;
				put 'The data step is running on ' _NTHREADS_ 'threads';
				put 'Hello from ' _hostname_ 'thread #' _threadid_;
				do i = 1 to 1000;
					col1 = rand('normal') * 5;
					col2 = col1 * 3 + rand('normal') * 2;
					output;
				end;
			run;
		"
		;
run;
quit;