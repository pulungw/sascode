import pandas

df = SAS.sd2df('sashelp.cars')

## Location to create the new sas7bdat file. Please modify to a path in your environment
outpath = '/mnt/viya-share/data/tmp'       
SAS.submit(f"libname mydata '{outpath}' ;")

SAS.df2sd(df,'mydata.cars')