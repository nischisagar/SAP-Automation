#!/bin/ksh
sid=`hdbsql -U hcuser1  -j -x -C "select database_name from m_databases" | egrep -vi database_name`
sidadm=`id -u -n`
SCHEMA=`hdbsql -U hcuser1  -j -x -C "select schema_name from tables where table_name='BC_COMPVERS'" | egrep -vi schema_name`
ASCHEMA=`hdbsql -U hcuser  -j -x -C "select schema_name from tables where table_name='USR02'" | egrep -vi schema_name`
Jrel=`hdbsql -U hcuser1  -j -x -C "select distinct SAPRELEASE from $SCHEMA.bc_compvers where scname='ENGINEAPI'" | egrep -v SAPRELEASE`
Jser=`hdbsql -U hcuser1  -j -x -C "select distinct SERVICELEVEL from $SCHEMA.bc_compvers where scname='ENGINEAPI'" | egrep -v SERVICELEVEL`
dbsize=`hdbsql -U hcuser1  -j -x -C "SELECT ROUND(TO_DOUBLE(sum(disk_size)/1024/1024/1024),2) "DB_SIZE" FROM m_table_persistence_statistics" | tail -1`
kernellevel=`hdbsql -U hcuser  -j -x -C "select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from $ASCHEMA.PATCHHIST where EXECUTABLE='disp+work' order by 3" | sed 's/,/ /g'| awk '{print $1 " " $2}' | tail -1`
hdblevel=`HDB -version|grep -i version|tail -1|awk '{print $2}'|cut -d"." -f1-3`
echo "$sid" > /tmp/$sidadm-sap-version-check-hanadb-java.log
echo "Java NW $Jrel SP $Jser" >> /tmp/$sidadm-sap-version-check-hanadb-java.log
echo "$kernellevel" >> /tmp/$sidadm-sap-version-check-hanadb-java.log
echo "HANA $hdblevel" >> /tmp/$sidadm-sap-version-check-hanadb-java.log
echo "$dbsize" >> /tmp/$sidadm-sap-version-check-hanadb-java.log