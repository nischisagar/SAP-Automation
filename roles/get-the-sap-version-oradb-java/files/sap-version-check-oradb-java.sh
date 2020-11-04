#!/bin/ksh
sid=`env|grep -i DB_SID|cut -d"=" -f2`
sidadm=`id -u -n`
schemaa=`env|grep -i dbs_ora_schema|cut -d"=" -f2`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/ansible_jsapvers.log;
set echo off;
set feedback off;
set heading off;
select BANNER_FULL FROM v\$version;
select distinct SAPRELEASE,SERVICELEVEL from sapsr3db.bc_compvers where scname='ENGINEAPI';
spool off;
exit
EOF
jversion=`tail -1 /tmp/ansible_jsapvers.log|awk '{print $1}'`
jsp=`tail -1 /tmp/ansible_jsapvers.log|awk '{print $2}'`
DBVER=`cat /tmp/ansible_jsapvers.log|grep -i version`
DBREL=`cat /tmp/ansible_jsapvers.log|grep -i oracle`
echo "$sid" > /tmp/$sidadm-sap-version-check-oradb-java.log
echo "Java NW $jversion SP $jsp " >> /tmp/$sidadm-sap-version-check-oradb-java.log
disp+work|egrep -i 'variant|number' >> /tmp/$sidadm-sap-version-check-oradb-java.log
echo "$DBREL" >> /tmp/$sidadm-sap-version-check-oradb-java.log
echo "$DBVER" >> /tmp/$sidadm-sap-version-check-oradb-java.log