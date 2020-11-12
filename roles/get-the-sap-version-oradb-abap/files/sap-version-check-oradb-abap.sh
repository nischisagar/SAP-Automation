#!/bin/ksh
sid=`env|grep -i DB_SID|cut -d"=" -f2`
sidadm=`id -u -n`
schemaa=`env|grep -i dbs_ora_schema|cut -d"=" -f2`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/ansible_sapvers.log;
set echo off;
set feedback off;
set heading off;
select BANNER_FULL FROM v\$version;
select distinct STEXT from $schemaa.CVERS_TXT where LANGU='E';
spool off;
set linesize 500;
set pagesize 500;
spool /tmp/ansible_kernelv.log;
select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from $schemaa.PATCHHIST where EXECUTABLE='disp+work' order by 3 desc fetch  first 1 rows only;
spool off;
exit
EOF
sversion=`tail -1 /tmp/ansible_sapvers.log`
DBREL=`cat /tmp/ansible_sapvers.log|grep -i oracle`
DBVER=`cat /tmp/ansible_sapvers.log|grep -i version`
kernellevel=`cat /tmp/ansible_kernelv.log|tail -1|awk '{print $1,$2}'`
echo "$sid" > /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$sversion" >> /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$kernellevel" >> /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$DBREL" >> /tmp/$sidadm-sap-version-check-oradb-abap.log
echo "$DBVER" >> /tmp/$sidadm-sap-version-check-oradb-abap.log