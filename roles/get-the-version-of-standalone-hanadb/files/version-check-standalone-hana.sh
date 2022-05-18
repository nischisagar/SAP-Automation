#!/bin/ksh
sid=`hdbsql -U hcuser  -j -x -C "select database_name from m_databases" | egrep -vi database_name`
sidadm=`id -u -n`
dbsize=`hdbsql -U BACKUP_T -j -x -C  "SELECT ROUND(TO_DOUBLE(sum(disk_size)/1024/1024/1024),2) "DB_SIZE" FROM m_table_persistence_statistics"|tail -1`
hdblevel=`HDB -version|grep -i version|tail -1|awk '{print $2}'|cut -d"." -f1-3`
echo "$sid" > /tmp/$sidadm-sap-version-check-hanadb-abap.log
echo "HANA $hdblevel" >>  /tmp/$sidadm-sap-version-check-hanadb-abap.log
echo "$dbsize" >> /tmp/$sidadm-sap-version-check-hanadb-abap.log