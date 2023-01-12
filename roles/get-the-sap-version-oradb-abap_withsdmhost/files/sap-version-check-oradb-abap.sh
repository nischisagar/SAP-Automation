#!/bin/ksh
sid=`env|grep -i DB_SID|cut -d"=" -f2`
sidadm=`id -u -n`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/$sidadm-ansible_schemanamee.txt;
set echo off;
set feedback off;
set heading off;
SELECT OWNER FROM DBA_TABLES WHERE TABLE_NAME = 'T000';
spool off;
exit
EOF
schemaa=`cat /tmp/$sidadm-ansible_schemanamee.txt|tail -1`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/$sidadm-ansible_sapvers.log;
set echo off;
set feedback off;
set heading off;
select BANNER_FULL FROM v\$version;
select distinct STEXT from $schemaa.CVERS_TXT where LANGU='E';
spool off;
set linesize 500;
set pagesize 500;
spool /tmp/$sidadm-ansible_kernelv.log;
select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from $schemaa.PATCHHIST where EXECUTABLE='disp+work' order by 3 desc fetch  first 1 rows only;
spool off;
set linesize 500;
set pagesize 500;
spool /tmp/$sidadm-ansible-dbsize.log;
select
( select sum(bytes)/1024/1024/1024 data_size from dba_data_files ) +
( select nvl(sum(bytes),0)/1024/1024/1024 temp_size from dba_temp_files ) +
( select sum(bytes)/1024/1024/1024 redo_size from sys.v_\$log ) +
( select sum(BLOCK_SIZE*FILE_SIZE_BLKS)/1024/1024/1024 controlfile_size from v\$controlfile) "Size in GB"
from
dual;
spool off;
exit
EOF
sversion=`tail -1 /tmp/$sidadm-ansible_sapvers.log`
DBREL=`cat /tmp/$sidadm-ansible_sapvers.log|grep -i oracle`
DBVER=`cat /tmp/$sidadm-ansible_sapvers.log|grep -i version`
kernellevel=`cat /tmp/$sidadm-ansible_kernelv.log|tail -1|awk '{print $1,$2}'`
dbsize=`sed 's/ //g' /tmp/$sidadm-ansible-dbsize.log|grep "^[0-9]"`
echo "$sid" > /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$sversion" >> /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$kernellevel" >> /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$DBREL" >> /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$DBVER" >> /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$dbsize" >> /tmp/$sidadm-sap-version-check-oradb-abap.log