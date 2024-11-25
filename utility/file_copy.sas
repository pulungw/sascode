options mprint mlogic symbolgen fullstimer msglevel=i;

/***
https://blogs.sas.com/content/sasdummy/2013/09/17/copy-file-macro/
***/
%macro file_copy(infile,outfile);

    filename in "&infile.";
    filename out "&outfile.";

    data _null_;
        length filein 8 fileid 8;
        filein = fopen('in','I',1,'B');
        fileid = fopen('out','O',1,'B');
        rec = '20'x;
        do while(fread(filein)=0);
            rc = fget(filein,rec,1);
            rc = fput(fileid,rec);
            rc = fwrite(fileid);
        end;
        rc = fclose(filein);
        rc = fclose(fileid);
    run;

    filename in clear;
    filename out clear;

%mend;

%macro exec_file_copy(FILESIZE);
	%let infile=C:\Temp\dummy_&FILESIZE.m.dat;
	%let outfile=C:\Temp\out_&FILESIZE.m.dat;

	%file_copy(&infile, &outfile);	
%mend;


/*%exec_file_copy(10);*/
%exec_file_copy(20);
/*%exec_file_copy(30);*/
/*%exec_file_copy(40);*/
/*%exec_file_copy(50);*/
/*%exec_file_copy(60);*/
/*%exec_file_copy(70);*/
/*%exec_file_copy(80);*/
/*%exec_file_copy(90);*/


/*%exec_file_copy(100);*/
/*%exec_file_copy(200);*/
/*%exec_file_copy(300);*/
/*%exec_file_copy(400);*/
/*%exec_file_copy(500);*/
/*%exec_file_copy(600);*/
/*%exec_file_copy(700);*/
/*%exec_file_copy(800);*/
/*%exec_file_copy(900);*/
/*%exec_file_copy(1000);*/
/*%exec_file_copy(1100);*/
/*%exec_file_copy(1200);*/



%macro file_copy_new(infile,outfile);
    /*** 入力・出力ファイルの定義 ***/
    filename in "&infile." RECFM=N;
    filename out "&outfile." RECFM=N;

    data _null_;
        /*** 出力メッセージを保持する変数 ***/
        length msg $384;

        /*** ファイルコピー実行 ***/
        rc=fcopy("in", "out");

        /*** 正常終了：NOTEをログに出力 ***/
        if rc=0 then do;
            put "NOTE: ファイルコピーが正常に実行されました。";
        end;

        /*** 異常終了：エラーをログに出力して強制終了 ***/
        else do;
            msg=sysmsg();
            put "ERROR: " rc= msg=;
            abort;
        end;
    run;

    /*** 入力・出力ファイルの定義解除 ***/
    filename in clear;
    filename out clear;
%mend;


%macro exec_file_copy_new(FILESIZE);
	%let infile=C:\Temp\dummy_&FILESIZE.m.dat;
	%let outfile=C:\Temp\out_&FILESIZE.m.dat;

	%file_copy_new(&infile, &outfile);	
%mend;

%exec_file_copy_new(10);
%exec_file_copy_new(20);

%exec_file_copy_new(100);
%exec_file_copy_new(200);
%exec_file_copy_new(300);
%exec_file_copy_new(400);
%exec_file_copy_new(500);
%exec_file_copy_new(600);
%exec_file_copy_new(700);
%exec_file_copy_new(800);
%exec_file_copy_new(900);
%exec_file_copy_new(1000);