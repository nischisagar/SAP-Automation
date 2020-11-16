#!/bin/ksh
sid=`db2 -x "select current server from sysibm.sysdummy1"`
sidadm=`id -u -n`
SCHEMA=`db2 -x "select tabschema from syscat.tables where tabname='BC_CVERS'"`
Jrel=`db2 -x "select distinct substr(SAPRELEASE,1,3) as SAPRELEASE from $SCHEMA.bc_compvers where scname='ENGINEAPI'"`
Jser=`db2 -x "select distinct SERVICELEVEL from $SCHEMA.bc_compvers where scname='ENGINEAPI'"`
dblevel=`db2level | grep token | awk '{print $4 " " $5}' | sed 's/"//g' |  sed 's/,//g'`
echo "$sid" > /tmp/$sidadm-sap-version-check-db2-java.log
echo "Java NW $Jrel SP $Jser" >> /tmp/$sidadm-sap-version-check-db2-java.log
disp+work|egrep -i 'variant|number' >> /tmp/$sidadm-sap-version-check-db2-java.log
echo "$dblevel" >> /tmp/$sidadm-sap-version-check-db2-java.log