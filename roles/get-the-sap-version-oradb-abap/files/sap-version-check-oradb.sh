#!/bin/ksh
sid=`env|grep -i DB_SID|cut -d"=" -f2`
ssmall=`echo $sid|tr '[:upper:]' '[:lower:]'`
sidadm="${ssmall}adm"
schemaa=`env|grep -i dbs_ora_schema|cut -d"=" -f2`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/$sidadm-sap-version-check-oradb.log;
set echo off;
set feedback off;
set heading off;
select BANNER_FULL FROM v\$version;
select distinct STEXT from $schemaa.CVERS_TXT where LANGU='E';
spool off;
exit
EOF
sversion=`tail -1 /tmp/$sidadm-sap-version-check-oradb.log`
DBVER=`cat /tmp/$sidadm-sap-version-check-oradb.log | grep -i version`
DBREL=`cat /tmp/$sidadm-sap-version-check-oradb.log | grep -i oracle`
echo "$sid" > /tmp/$sidadm-sap-version-check-oradb.log
echo "$sversion" >> /tmp/$sidadm-sap-version-check-oradb.log
disp+work|egrep -i 'variant|number' >> /tmp/$sidadm-sap-version-check-oradb.log
echo "$DBREL" >> /tmp/$sidadm-sap-version-check-oradb.log
echo "$DBVER" >> /tmp/$sidadm-sap-version-check-oradb.log