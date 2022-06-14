#!/bin/ksh
sidadm=`id -u -n`
hname=`hostname`
sqlplus -s sys/sys as sysdba<<EOF
Set heading off
spool /tmp/$sidadm-hashtable.log;
select segment_name,segment_type,bytes/1024/1024 as "size in MB" from dba_segments where segment_name like '%#$';
select instance_name,HOST_NAME from v\$instance;
spool off;
exit
EOF
cat /tmp/$sidadm-hashtable.log|sed '/^$/d' >> /tmp/$hname-hashtable_final.log
chmod 777 /tmp/$hname-hashtable_final.log
echo "=====================================================================================================" >> /tmp/$hname-hashtable_final.log
