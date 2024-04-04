set datetime=%date:~0,4%%date:~5,2%%date:~8,2%-%time:~1,1%%time:~3,2%%time:~6,2%
set sas="C:\Program Files\SASHome\SASFoundation\9.4\sas.exe"
set project=C:\code\sascode\parallel_job
set name=parallel_job
set pgm=%project%\%name%.sas
set log=%project%\logs\%name%_%datetime%.log
set print=%project%\logs\%name%_%datetime%.lst
set sasOpt=-RSASUSER -ICON -NOLOGO -NOTERMINAL -NOOVP -NOCENTER -NODATE -NONUMBER -NOSOURCE -NOSOURCE2 -NO$SYNTAXCHECK -SASUSER work -NOMPRINT -NOMLOGIC -FULLSTIMER

%sas% -sysin %pgm% -log %log% -print %print% %sasOpt%