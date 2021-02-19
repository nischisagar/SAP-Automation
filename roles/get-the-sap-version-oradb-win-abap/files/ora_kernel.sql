set linesize 500
set pagesize 500
set heading off
select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from SAPSR3.PATCHHIST where EXECUTABLE='disp+work' order by 3 desc fetch  first 1 rows only;
exit