#!/bin/ksh
db2 list active databases | egrep -i 'Database name'|awk '{print $4}' > /tmp/ansible-dblist.txt
for dbname in `cat /tmp/ansible-dblist.txt`
do
db2 connect to $dbname; db2 -x "SELECT service_level FROM TABLE  (sysproc.env_get_inst_info())" |  awk '{print $1}' > /tmp/ansible-prd.txt
product=`cat /tmp/ansible-prd.txt`
db2 connect to $dbname; db2 -x "SELECT service_level FROM TABLE  (sysproc.env_get_inst_info())" |  awk '{print $2}' > /tmp/ansible-ver.txt
dbver=`cat /tmp/ansible-ver.txt`
echo "$dbname" > /tmp/ansible-$dbname-dbversion.log
echo "$product" >> /tmp/ansible-$dbname-dbversion.log
echo "$dbver" >> /tmp/ansible-$dbname-dbversion.log
done