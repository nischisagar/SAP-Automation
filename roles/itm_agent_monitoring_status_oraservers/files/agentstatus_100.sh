#!/bin/ksh
idm=`id -u -n`
scname=`cat /tmp/itmschema_$idm.txt`
sqlplus -s sys/sys as sysdba<<EOF
set feedback off
set heading off
set echo off
spool /tmp/itmuserstatus.txt
select instance_name from v\$instance;
select UFLAG from $scname.usr02 where BNAME='IBMMON_AGENT' and MANDT='100';
spool off;
exit
EOF