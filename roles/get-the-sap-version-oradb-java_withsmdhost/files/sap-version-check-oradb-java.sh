#!/bin/ksh
sid=`id -u -n|cut -c 1-3|tr '[:lower:]' '[:upper:]'`
sidadm=`id -u -n`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/ansible_schemaname.txt;
set echo off;
set feedback off;
set heading off;
select owner from dba_tables where table_name='SDBAH';
spool off;
exit
EOF
schemaa=`cat /tmp/ansible_schemaname.txt|tail -1`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/ansible_jsapvers.log;
set echo off;
set feedback off;
set heading off;
select BANNER_FULL FROM v\$version;
select distinct SAPRELEASE,SERVICELEVEL from $schemaa.bc_compvers where scname='CORE-TOOLS';
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
jversion=`tail -1 /tmp/ansible_jsapvers.log|awk '{print $1}'`
jsp=`tail -1 /tmp/ansible_jsapvers.log|awk '{print $2}'`
DBVER=`cat /tmp/ansible_jsapvers.log|grep -i version`
DBREL=`cat /tmp/ansible_jsapvers.log|grep -i oracle`
dbsize=`sed 's/ //g' /tmp/$sidadm-ansible-dbsize.log|grep "^[0-9]"`
echo "$sid" > /tmp/$sidadm-sap-version-check-oradb-java.log
echo "Java NW $jversion SP $jsp" >> /tmp/$sidadm-sap-version-check-oradb-java.log
disp+work|egrep -i 'variant|number' >> /tmp/$sidadm-sap-version-check-oradb-java.log
echo "$DBREL" >> /tmp/$sidadm-sap-version-check-oradb-java.log
echo "$DBVER" >> /tmp/$sidadm-sap-version-check-oradb-java.log
echo "$dbsize" >> /tmp/$sidadm-sap-version-check-oradb-java.log
