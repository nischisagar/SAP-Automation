#!/bin/ksh
sid=`env|grep -i DB_SID|cut -d"=" -f2`
sidadm=`id -u -n`
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/$sidadm-bctstatus.log
column Host_name format a15
column Instance_name format a8
set heading off;
select
sysdate "Date",
(select HOST_NAME from  v\$instance) "Host_name" ,
(select INSTANCE_NAME from  v\$instance) "Instance_name" ,
( select  status   from   v\$block_change_tracking) "BCT_STATUS"
from
dual;
spool off;
exit
EOF