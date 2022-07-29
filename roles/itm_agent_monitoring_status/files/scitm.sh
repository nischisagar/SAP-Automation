#!/bin/ksh
idm=`id -u -n`
sqlplus -s sys/sys as sysdba<<EOF
set feedback off
set heading off
set echo off
spool /tmp/itmschema_$idm.txt
SELECT OWNER FROM DBA_TABLES WHERE TABLE_NAME = 'T000';
spool off;
exit
EOF
