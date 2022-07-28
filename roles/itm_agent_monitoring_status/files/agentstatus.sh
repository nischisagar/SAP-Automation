#!/bin/ksh
sqlplus -s sys/sys as sysdba<<EOF
set feedback off
set heading off
set echo off
spool /tmp/itmuserstatus.txt
select instance_name from v\$instance;
select UFLAG from sapsr3.usr02 where BNAME='IBMMON_AGENT' and MANDT='000';
spool off;
exit
EOF