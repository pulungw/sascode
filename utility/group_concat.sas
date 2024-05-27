data work.x1;
	input Name $ Score;
	length Name $10. Score 8;
	datalines;
Ricky 29
Ricky 42
Julian 99
Julian 89
;
run;

proc sql;
	create table work.x2 as
	select Name, 
		sum(Score) as Score
	from work.x1
	group by Name
	order by Name
	;
quit;