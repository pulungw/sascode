set datetime=%date:~0,4%%date:~5,2%%date:~8,2%-%time:~1,1%%time:~3,2%%time:~6,2%
set sasiotest="C:\Program Files\SASHome\SASFoundation\9.4\sasiotest.exe"

set filesize=%1
set pagesize=%2

%sasiotest% c:\temp\dummy.dat -w -filesize %filesize% -pagesize %pagesize% -unbuffered
%sasiotest% c:\temp\dummy.dat -r -filesize %filesize% -pagesize %pagesize% -unbuffered