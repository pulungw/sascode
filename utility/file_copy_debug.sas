%macro file_copy(infile,outfile);

    filename in "&infile.";
    filename out "&outfile.";

    data _null_;
        length filein 8 fileid 8;

        /***
        fileref: 'in'
        open-mode: INPUT
        record-length: 1 Byte
        record-format: Bynary
        ***/
        filein = fopen('in','I',1,'B');
        fileid = fopen('out','O',1,'B');

        rec = '20'x;
        do while(fread(filein)=0);
            rc = fget(filein,rec,1);
            rc = fput(fileid,rec);
            rc = fwrite(fileid);
            put filein hex8. "|" fileid hex8. "|" rec hex8. "|";
            output;
        end;
        rc = fclose(filein);
        rc = fclose(fileid);
    run;

    filename in clear;
    filename out clear;

%mend;

%macro exec_file_copy(FILESIZE);
	%let infile=C:\Temp\model.sasast;
	%let outfile=C:\Temp\out_model.sasast;

	%file_copy(&infile, &outfile);	
%mend;


%exec_file_copy();
/*%exec_file_copy(100k);*/
/*%exec_file_copy(1m);*/