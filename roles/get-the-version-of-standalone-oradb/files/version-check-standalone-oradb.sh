#!/bin/ksh
ps -ef|grep -i pmon|grep -v grep|cut -d"_" -f3 > /tmp/ansible-dblist.txt
for db in `cat /tmp/ansible-dblist.txt`
do
homepath=`grep -iw $db /etc/oratab|cut -d ":" -f2|tail -1`
export ORACLE_HOME=$homepath
export ORACLE_SID=$db
echo "ORACLE_HOME = $ORACLE_HOME , ORACLE_SID = $ORACLE_SID"
fname=$ORACLE_SID-dbversion.log
sqlplus -s sys/sys as sysdba<<EOF
spool /tmp/ansible-dbrelease.txt;
set heading off;
SELECT product FROM PRODUCT_COMPONENT_VERSION where product like '%racle%';
spool off;
spool /tmp/ansible-dbversion.txt;
set heading off;
SELECT version FROM V\$INSTANCE;
spool off;
spool /tmp/ansible-dbsize.txt;
set heading off;
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
echo "fname = $fname"
dbrel=`cat /tmp/ansible-dbrelease.txt | grep [a-z]`
dbver=`cat /tmp/ansible-dbversion.txt|grep [0-9]`
dbsize=`sed 's/ //g' /tmp/ansible-dbsize.txt|grep "^[0-9]"`
echo "$db" > /tmp/ansible-$fname
echo "$dbrel" >> /tmp/ansible-$fname
echo "$dbver" >> /tmp/ansible-$fname
echo "$dbsize" >> /tmp/ansible-$fname
done