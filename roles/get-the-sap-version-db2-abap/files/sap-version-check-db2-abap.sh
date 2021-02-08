# #!/bin/ksh
# sid=`db2 -x "select current server from sysibm.sysdummy1"`
# sidadm=`id -u -n`
# SCHEMA=`db2 -x "select tabschema from syscat.tables where tabname='CVERS_TXT'"`
# sapvers=`db2 -x "select distinct varchar(STEXT,25) from $SCHEMA.CVERS_TXT where LANGU='E'"`
# dblevel=`db2level | grep token | awk '{print $4 " " $5}' | sed 's/"//g' |  sed 's/,//g'`
# kernellevel=`db2 -x  "select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from $SCHEMA.PATCHHIST where EXECUTABLE='disp+work' order by 3" | awk '{print $1 " " $2}' | tail -1`
# echo "$sid" > /tmp/$sidadm-sap-version-check-db2-abap.log
# echo "$sapvers" >> /tmp/$sidadm-sap-version-check-db2-abap.log
# echo "$kernellevel" >> /tmp/$sidadm-sap-version-check-db2-abap.log
# echo "$dblevel" >> /tmp/$sidadm-sap-version-check-db2-abap.log

#!/bin/ksh
sid=`db2 -x "select current server from sysibm.sysdummy1"`
sidadm=`id -u -n`
SCHEMA=`db2 -x "select tabschema from syscat.tables where tabname='CVERS_TXT'"`
sapvers=`db2 -x "select distinct varchar(STEXT,25) from $SCHEMA.CVERS_TXT where LANGU='E'"`
dblevel=`db2level | grep token | awk '{print $4 " " $5}' | sed 's/"//g' |  sed 's/,//g'`
kernellevel=`db2 -x  "select SAPRELEASE,Trim(Leading '0' from patchno),timestamp from $SCHEMA.PATCHHIST where EXECUTABLE='disp+work' order by 3" | awk '{print $1 " " $2}' | tail -1`
dbsize=`db2 -x "SELECT round(SUM(db_size/1024/1024/1024),2) FROM systools.stmg_dbsize_info"| awk '{print $1}'`
echo "$sid" > /tmp/$sidadm-sap-version-check-db2-abap.log
echo "$sapvers" >> /tmp/$sidadm-sap-version-check-db2-abap.log
echo "$kernellevel" >> /tmp/$sidadm-sap-version-check-db2-abap.log
echo "$dblevel" >> /tmp/$sidadm-sap-version-check-db2-abap.log
echo "$dbsize" >> /tmp/$sidadm-sap-version-check-db2-abap.log