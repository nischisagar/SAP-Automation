#!/bin/ksh
sid=`hdbsql -U hcuser  -j -x -C "select database_name from m_databases" | egrep -vi database_name`
sidadm=`id -u -n`
SCHEMA=`hdbsql -U hcuser  -j -x -C "select schema_name from tables where table_name='USR02'" | egrep -vi schema_name`
sapvers=`hdbsql -U hcuser  -j -x -C "select distinct STEXT from $SCHEMA.CVERS_TXT where LANGU='E'" | egrep -v STEXT`
kernellevel=`hdbsql -U hcuser  -j -x -C "select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from $SCHEMA.PATCHHIST where EXECUTABLE='disp+work' order by 3" | sed 's/,/ /g'| awk '{print $1 " " $2}' | tail -1`
hdblevel=`HDB -version|grep -i version|tail -1|awk '{print $2}'|cut -d"." -f1-3`
echo "$sid" > /tmp/$sidadm-sap-version-check-hanadb-abap.log
echo "$sapvers" >> /tmp/$sidadm-sap-version-check-hanadb-abap.log
echo "$kernellevel" >>  /tmp/$sidadm-sap-version-check-hanadb-abap.log
echo "HANA $hdblevel" >>  /tmp/$sidadm-sap-version-check-hanadb-abap.log