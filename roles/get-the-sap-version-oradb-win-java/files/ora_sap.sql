set linesize 500
set pagesize 500
set heading off
select distinct SAPRELEASE from SAPSR3DB.BC_COMPVERS where SCNAME='CORE-TOOLS';
exit