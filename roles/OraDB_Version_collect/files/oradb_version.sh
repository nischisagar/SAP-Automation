#!/bin/ksh
idm=`id -u -n`
sqlplus -s sys/sys as sysdba<<EOF
set feedback off
set heading off
set echo off
spool /tmp/ora_version_$idm.txt
select host_name,instance_name,VERSION_FULL from v\$instance;
spool off;
exit
EOF