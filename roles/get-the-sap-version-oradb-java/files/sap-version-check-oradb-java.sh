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
exit
EOF
jversion=`tail -1 /tmp/ansible_jsapvers.log|awk '{print $1}'`
jsp=`tail -1 /tmp/ansible_jsapvers.log|awk '{print $2}'`
DBVER=`cat /tmp/ansible_jsapvers.log|grep -i version`
DBREL=`cat /tmp/ansible_jsapvers.log|grep -i oracle`
echo "$sid" > /tmp/$sidadm-sap-version-check-oradb-java.log
echo "Java NW $jversion SP $jsp" >> /tmp/$sidadm-sap-version-check-oradb-java.log
disp+work|egrep -i 'variant|number' >> /tmp/$sidadm-sap-version-check-oradb-java.log
echo "$DBREL" >> /tmp/$sidadm-sap-version-check-oradb-java.log
echo "$DBVER" >> /tmp/$sidadm-sap-version-check-oradb-java.log