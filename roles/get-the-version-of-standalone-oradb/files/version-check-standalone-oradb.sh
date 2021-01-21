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
exit
EOF
echo "fname = $fname"
dbrel=`cat /tmp/ansible-dbrelease.txt | grep [a-z]`
dbver=`cat /tmp/ansible-dbversion.txt|grep [0-9]`
echo "$db" > /tmp/ansible-$fname
echo "NA" >> /tmp/ansible-$fname
echo "NA" >> /tmp/ansible-$fname
echo "NA" >> /tmp/ansible-$fname
echo "$dbrel" >> /tmp/ansible-$fname
echo "$dbver" >> /tmp/ansible-$fname
done